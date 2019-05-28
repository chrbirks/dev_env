#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <net/ethernet.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
#include <arpa/inet.h>

#include <zlib.h>

#define MAX_FRAME_LEN  10000

#define ETH_DST_MAC    0xFFFFFFFFFFFF
#define ETH_SRC_MAC    0x001122334455

#define IP4_SRC_IP     "192.168.1.111"
#define IP4_DST_IP     "192.168.1.122"
#define IP4_TTL        64
#define IP4_PROTO_UDP  0x11

#define UDP_SRC_PORT   0x09
#define UDP_DST_PORT   0x09

#define ETH_HDR_LEN    14
#define IP4_HDR_LEN    20

#define FCS_LEN        4

/* packet */
struct pktgen_pkt {
  struct ether_header eth;
  struct ip ip;
  struct udphdr udp;
} __attribute__((packed));

static inline void pkt_print(char *p, unsigned int len) {
  int i;

  for (i = 1; i <= len; i++) {
    printf("%02X", *(unsigned char *)(p++));
    if ((i != 0) && (i % 0x08 == 0))
      printf(" ");
    if ((i != 0) && (i % 0x10 == 0))
      printf(" ");
  }
  printf("\n");
}

/* from netmap pkt-gen.c */
static uint16_t checksum(const void *data, uint16_t len, uint32_t sum) {
  const uint8_t *addr = data;
  uint32_t i;

  /* Checksum all the pairs of bytes first... */
  for (i = 0; i < (len & ~1U); i += 2) {
    sum += (u_int16_t)ntohs(*((u_int16_t *)(addr + i)));
    if (sum > 0xFFFF)
      sum -= 0xFFFF;
  }

  /*
   * If there's a single byte left over, checksum it, too.
   * Network byte order is big-endian, so the remaining byte is
   * the high byte.
   */
  if (i < len) {
    sum += addr[i] << 8;
    if (sum > 0xFFFF)
      sum -= 0xFFFF;
  }

  return sum;
}

static u_int16_t wrapsum(u_int32_t sum) {
  sum = ~sum & 0xFFFF;
  return (htons(sum));
}

void set_ethhdr(struct pktgen_pkt *pkt) {
	struct ether_header *eth;
	eth = &pkt->eth;

	eth->ether_dhost[5] = (ETH_DST_MAC      ) & 0xFF;
	eth->ether_dhost[4] = (ETH_DST_MAC >>  8) & 0xFF;
	eth->ether_dhost[3] = (ETH_DST_MAC >> 16) & 0xFF;
	eth->ether_dhost[2] = (ETH_DST_MAC >> 24) & 0xFF;
	eth->ether_dhost[1] = (ETH_DST_MAC >> 32) & 0xFF;
	eth->ether_dhost[0] = (ETH_DST_MAC >> 40) & 0xFF;
	eth->ether_shost[5] = (ETH_SRC_MAC      ) & 0xFF;
	eth->ether_shost[4] = (ETH_SRC_MAC >>  8) & 0xFF;
	eth->ether_shost[3] = (ETH_SRC_MAC >> 16) & 0xFF;
	eth->ether_shost[2] = (ETH_SRC_MAC >> 24) & 0xFF;
	eth->ether_shost[1] = (ETH_SRC_MAC >> 32) & 0xFF;
	eth->ether_shost[0] = (ETH_SRC_MAC >> 40) & 0xFF;
	eth->ether_type = htons(ETHERTYPE_IP);

	return;
}

void set_ip4hdr(struct pktgen_pkt *pkt, u_int16_t frame_len) {
  struct ip *ip;
  ip = &pkt->ip;

  ip->ip_v = IPVERSION;
  ip->ip_hl = 5;
  ip->ip_tos = 0;
  ip->ip_len = htons(frame_len - ETH_HDR_LEN);
  ip->ip_id = 0;
  ip->ip_off = 0;
  ip->ip_ttl = 64;
  ip->ip_p = IPPROTO_UDP;
  inet_pton(AF_INET, IP4_SRC_IP, &ip->ip_src);
  inet_pton(AF_INET, IP4_DST_IP, &ip->ip_dst);
  ip->ip_sum = 0;

  ip->ip_sum = 1;
  return;
}

void set_udphdr(struct pktgen_pkt *pkt, u_int16_t frame_len)
{
	struct udphdr *udp;
	udp = &pkt->udp;

	udp->uh_sport = htons(UDP_SRC_PORT);
	udp->uh_dport = htons(UDP_DST_PORT);
	udp->uh_ulen = htons(frame_len - ETH_HDR_LEN - IP4_HDR_LEN);
	udp->uh_sum = 0;

	return;
}

int main(int argc, char **argv) {
	char *pkt;
	struct pktgen_pkt hdr;
	unsigned long crc = crc32(0, Z_NULL, 0);
	int frame_len = 60;

	// frame_len
	if (argc == 2)
		frame_len = atoi(argv[1]);
	printf("frame_len: %d\n", frame_len);

	// header
	set_ethhdr(&hdr);
	set_ip4hdr(&hdr, frame_len);
	set_udphdr(&hdr, frame_len);
	hdr.ip.ip_sum = wrapsum(checksum(&hdr.ip, sizeof(hdr.ip), 0));

	// packet
	pkt = calloc((size_t)MAX_FRAME_LEN, sizeof(char));
	memcpy(pkt, &hdr, sizeof(struct pktgen_pkt));

	printf("hdr_len: %d\n", (int)sizeof(hdr));
	printf("ip_sum: %X\n", (int)hdr.ip.ip_sum);
	printf("Packet data:\n");
	pkt_print(pkt, frame_len);
	printf("\n");

	// fcs
	int j;
	for (j = 8; j < frame_len + 4; j += 8) {
		crc = crc32(0, Z_NULL, 0);
		crc = crc32(crc, (const unsigned char *)pkt, j);
		printf("FCS(%02d): %08lX\n", j / 8, crc);
		pkt_print(pkt, j);
	}

	crc = crc32(0, Z_NULL, 0);
	crc = crc32(crc, (const unsigned char *)pkt, frame_len);
	printf("\nFCS: %08lX\n", crc);
	memcpy(pkt+frame_len, &crc, sizeof(unsigned long));
	pkt_print(pkt, frame_len+FCS_LEN);

	free(pkt);
	return 0;
}
