//-----------------------------------------------------------------------------
// Title         : Layer Decoder Reference Model
// Project       : Napablaze
//-----------------------------------------------------------------------------
// File          : layer_decoder_ref_model_pkg.sv
// Author        : cbs  <cbs@napablaze.com>
// Created       : 22.03.2019
// Last modified : 22.03.2019
//-----------------------------------------------------------------------------
// Description :
// 
//-----------------------------------------------------------------------------
// Copyright (c) 2019 by Napablaze This model is the confidential and
// proprietary property of Napablaze and the possession or use of this
// file requires a written license from Napablaze.
//------------------------------------------------------------------------------
// Modification history :
// 22.03.2019 : created
//-----------------------------------------------------------------------------

`include "nb_system_pkg.sv";

package layer_decoder_ref_model_pkg;
  import nb_system_pkg::*;
  // import laydec_interface_sequencer_pkg::*;
  // import ca_packet_process_rx_pkg::*;
  
  // class layer_decoder_ref_model;
  typedef struct packed {
    logic [7:0]                        data[$];
    logic [PPR_LD_OFFSET_WIDTH-1:0] 	 offset = 0;
    logic [$clog2(200):0]              header_bytes = 0;
    ppr_protocols_t                    next_prot = notknown;
    ppr_protocols_t                 	 this_prot = notknown;
    ppr_protocols_sub_t             	 this_prot_sub;
    bit                                match = 0;
  } ref_model_t;
  

  //---------------------------------------------------------------------
  // Ref model wrapper that converts between sequence items and ref model
  // data.
  //---------------------------------------------------------------------
  function laydec_sequence_item layer_decoder_ref_model(laydec_sequence_item item_in, bit verbose = 0);
    ref_model_t          ref_input;
    ref_model_t          ref_out;
    laydec_sequence_item item_out;
    
    if (verbose) $display("layer_decoder_ref_model(): Input data=%h", item_in.data);
    
    // Assign input seq item to data struct
    for (int i=0; i<NB_PPR_PACKET_EXTRACT_DEPTH/8; i++)
      ref_input.data.push_front(item_in.data[(i*8)+7 -: 8]);

    ref_input.offset        = item_in.offset;
    ref_input.next_prot     = item_in.next_prot;
    ref_input.this_prot     = item_in.this_prot;
    ref_input.this_prot_sub = item_in.this_prot_sub;

    // Run ref model
    ref_out = decode(ref_input, 0, verbose);

    // $cast(item_out, item_in.clone());
    item_out = laydec_sequence_item::type_id::create("item_out");

    $display("FIXME: ref_out.data.size()=%h", ref_out.data.size());
    
    // Assign data struct to output seq item
    // for (int i=0; i<NB_PPR_PACKET_EXTRACT_DEPTH/8; i++) begin
    //   if (ref_out.data.size() > 0) begin
    //     item_out.data[(i*8)+7 -: 8] = ref_out.data.pop_front();
    //   end
    // end
    item_out.data = 0;
    for (int i=0; i<ref_out.offset+1; i++) begin
      item_out.data[(ref_out.offset)*8-1 - ((i*8)) -: 8] = ref_input.data.pop_front();
      $display("FIXME: index=%0d, %h", (ref_out.offset)*8-1 - ((i*8)), item_out.data[(ref_out.offset)*8-1 - ((i*8)) -: 8]);
    end
    if (verbose) $display("layer_decoder_ref_model(): item_out.data=%h", item_out.data);
    
    item_out.offset        = item_in.offset + ref_out.offset;
    if (verbose) $display("layer_decoder_ref_model(): item_out.offset=%h", item_out.offset);

    if (item_out.offset >= NB_PPR_PACKET_EXTRACT_DEPTH/8)
      item_out.next_prot = none;
    else
      item_out.next_prot = ref_out.next_prot;

    if (verbose) $display("layer_decoder_ref_model(): item_out.next_prot=%h", item_out.next_prot);

    item_out.this_prot     = ref_out.this_prot;
    if (verbose) $display("layer_decoder_ref_model(): item_out.this_prot=%h", item_out.this_prot);

    item_out.this_prot_sub = ref_out.this_prot_sub;
    if (verbose) $display("layer_decoder_ref_model(): item_out.this_prot.subtype=%h", item_out.this_prot_sub);

    // item_out.match = ref_out.match;
    // if (verbose) $display("layer_decoder_ref_model(): item_out.match=%h", item_out.match);

    return item_out;
  endfunction // layer_decoder_ref_model


  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode(ref_model_t in, bit write_transaction = 0, bit verbose = 0);
    ref_model_t out;

    //FIXME: remove after debugging
    // out.offset = 0;
    // out.next_prot = ipv4;
    // out.this_prot = ethernet;
    // return out;

    // FIXME: testing...
    // out.data = in.data;
    
    // Determine which protocol to decode
    case (in.next_prot)
      // 
      notknown: begin
        if (verbose) $display("decode(): Decoding unknown layer");
        if (in.this_prot == mpls || in.this_prot == gtp) begin
          out = decode_ipv4(in, write_transaction, verbose);
        end else begin
          out.match = 0;
        end
        if (out.match == 0 && (in.this_prot == mpls || in.this_prot == gtp)) begin
          out = decode_ipv6(in, write_transaction, verbose);
        end
      end
      // 
      ethernet: begin
        if (verbose) $display("decode(): Decoding Ethernet layer");
        out = decode_ethernet(in, write_transaction, verbose);
      end
      // 
      vlan: begin
        if (verbose) $display("decode(): Decoding VLAN");
        out = decode_vlan(in, write_transaction, verbose);
      end
      // 
      mpls: begin
        if (verbose) $display("decode(): Decoding MPLS");
        out = decode_mpls(in, write_transaction, verbose);
      end
      // 
      ipv4: begin
        if (verbose) $display("decode(): Decoding IPv4");
        out = decode_ipv4(in, write_transaction, verbose);
      end
      // 
      ipv6: begin
        if (verbose) $display("decode(): Decoding IPv6");
        out = decode_ipv6(in, write_transaction, verbose);
      end
      // 
      tcp: begin
        if (verbose) $display("decode(): Decoding TCP");
        out = decode_tcp(in, write_transaction, verbose);
      end
      // 
      udp: begin
        if (verbose) $display("decode(): Decoding UDP");
        out = decode_udp(in, write_transaction, verbose);
      end
      // 
      gtp: begin
        if (verbose) $display("decode(): Decoding GTP");
        out = decode_gtp(in, write_transaction, verbose);
      end
      // 
      icmp: begin
        if (verbose) $display("decode(): Decoding ICMP");
        out = decode_icmp(in, write_transaction, verbose);
      end
      // 
      default: begin
        if (verbose) $display("decode(): Error");
        // TODO: ERROR
      end
    endcase // case (prev_prot.next_prot)

    if (out.match == 0) begin
      if (verbose) $display("decode(): No protocol match found");
      out.this_prot = notknown;
      out.next_prot = notknown;
      out.offset = 0;
      out.header_bytes = 0;
    end

    if (in.next_prot == none) begin
      if (verbose) $display("decode(): No more layers expected");
      out.this_prot = notknown;
      out.next_prot = notknown;
      out.match = 0;
      out.offset = in.offset;
    end

    //If the decode depth have exceeded the extract depth we cannot decode the next protocol. Therefore we set it to none to force the next layer to ignore match from any protocol matchers.
    if (out.offset > NB_PPR_PACKET_EXTRACT_DEPTH/8) begin
      if (verbose) $display("decode(): Max layer depth reached");
      out.next_prot = none;
    end

    // TODO: include again?
    // // Terminate if end of data
    // if (out.data.size() == 0) begin
    //   if (verbose) $display("decode(): End of data");
    //   out.next_prot = none;
    // end
 
    // // TODO: if loop==1 call decode() recursively
    // if (out.prot != notknown && out.next_prot != none) begin
    //   out = decode(out, write_transaction, verbose);
    // end else begin
    //   packet_end = 1;
    //   return out;
    // end
    
    return out;
  endfunction // decode


  //---------------------------------------------------------------------
  // Offsets |          0            |          1            |          2            |          3            |
  //     Bit | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|
  //       0 | Destination MAC 0     | Destination MAC 1     | Destination MAC 2     | Destination MAC 3     |
  //      32 | Destination MAC 4     | Destination MAC 5     | Source MAC 0          | Source MAC 1          |
  //      64 | Source MAC 2          | Source MAC 3          | Source MAC 4          | Source MAC 5          |
  //---------------------------------------------------------------------
  function ref_model_t decode_ethernet(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;
    logic [15:0] type_field;
    // const DATA_BYTES = 14;
    logic [13:0][7:0] data; // 14 bytes

    for (int i=0; i<14; i++)
      data[i] = in.data.pop_front();
    
    // Get ether type field
    type_field = {data[12], data[13]};

    if (verbose) $display("decode_ethernet(): type_field=%h", type_field);

    if (type_field == 16'h0800)
      out.next_prot = ipv4;
    else if (type_field == 16'h86DD)
      out.next_prot = ipv6;
    else if (type_field == 16'h8100 || type_field == 16'h9100 || type_field == 16'h88A8)
      out.next_prot = vlan;
    else if (type_field == 16'h8847 || type_field == 16'h8848)
      out.next_prot = mpls;
    else
      out.next_prot = notknown;

    if (verbose)
      $display($sformatf("decode_ethernet(): Next protocol layer found: %s", out.next_prot));
    
    out.this_prot = ethernet;
    out.this_prot_sub = {default:0};
    out.match = 1;
    out.offset += 14;
    out.header_bytes = 14;

    // if (write_transaction)
      // TODO
      
    return out;
  endfunction


  //---------------------------------------------------------------------
  // Offsets |          0            |          1            |          2            |          3            |
  //     Bit | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|
  //       0 | Tag protocol indentifier (TPID)               | Tag control information (TCI)                 |
  // TODO: header_bytes?
  //---------------------------------------------------------------------
  function ref_model_t decode_vlan(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;
    logic [15:0]      type_field;
    logic [3:0][7:0]  data;
    automatic int     vlan_tag_cnt = 0;


    for (int i=0; i<4; i++)
      data[i] = in.data.pop_front();

    type_field = {data[2], data[3]};
    if (verbose) $display("decode_vlan(): type_field=%h", type_field);

    while (type_field == 16'h8100 || type_field == 16'h9100) begin
      vlan_tag_cnt++;
      for (int i=0; i<2; i++)
        data[i] = in.data.pop_front();
      type_field = {data[2], data[3]};
      if (verbose) $display("decode_vlan(): type_field=%h", type_field);
    end

    if (type_field == 16'h0800)
      out.next_prot = ipv4;
    if (type_field == 16'h86dd)
      out.next_prot = ipv6;
    if (type_field == 16'h8100 ||  type_field == 16'h9100)
      out.next_prot = vlan;
    if (type_field == 16'h8847 || type_field == 16'h8848)
      out.next_prot = mpls;
    else
      out.next_prot = notknown;
    
    out.match = 1;
    out.this_prot = vlan;
    out.offset += 4 + (vlan_tag_cnt)*4;
    out.this_prot_sub = vlan_tag_cnt+1;

    return out;
//    char* type_field;
//  
//  protocol_struct this_protocol;
//  int vlan_tag = 0;
//  type_field = byte_extract(prtcl_hdr, offset+2, 2);
//  while (strcmp(type_field,"8100")==0 || strcmp(type_field,"9100")==0){
//    vlan_tag++;
//    type_field = byte_extract(prtcl_hdr, offset+2+vlan_tag*4, 2);
//  }
//  if (verbose) cout << type_field << endl;
//  this_protocol.offset = offset+(vlan_tag+1)*4;
//  this_protocol.header_bytes = (vlan_tag+1)*4;
//  this_protocol.protocol = vlan;
//  if ( strcmp(type_field,"0800")==0){
//    this_protocol.next_protocol = ipv4;
//  } else if ( strcmp(type_field,"86dd")==0){
//    this_protocol.next_protocol = ipv6;
//  } else if ( strcmp(type_field,"8100")==0 || strcmp(type_field,"9100")==0){
//    this_protocol.next_protocol = vlan;
//  } else if ( strcmp(type_field,"8847")==0 || strcmp(type_field,"8848")==0){
//    this_protocol.next_protocol = mpls;    
//  } else {
//    this_protocol.next_protocol = notknown;
//  }
//  
//  this_protocol.subtype.value = vlan_tag+1;
//  this_protocol.match = 1;
//  
//  if(verbose) printf("vlan match found \n");
//  return this_protocol;
  endfunction
  

  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode_mpls(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;

    return out;
  endfunction


  //----------------------------------------------------------------------------------------------------------
  // Offsets |          0            |          1            |          2            |          3            |
  //     Bit | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|
  //       0 | Version   | IHL       | DSCP            | ECN | Total Length                                  |
  //      32 | Identification                                | Flags  | Fragment Offset                      |
  //      64 | Time To Live          | Protocol              | Header Checksum                               |
  //      96 | Source IP Address                                                                             |
  //     128 | Destination IP Address                                                                        |
  //     160 | Options (if IHL > 5)                                                                          |
  // TODO: header_bytes?
  //----------------------------------------------------------------------------------------------------------
  function ref_model_t decode_ipv4(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;
    logic [23:0][7:0] data;
    logic [3:0]       version;
    logic [3:0]       ihl;
    logic [2:0]       flags;
    // logic       fragmented;
    logic [12:0]      frag_offset;
    logic [7:0]       next_prot;

    for (int i=0; i<24; i++)
      data[i] = in.data.pop_front();

    version = data[0] >> 4;
    if (verbose) $display("decode_ipv4(): version=%h", version);
    ihl = data[0] && 8'b00001111;
    if (verbose) $display("decode_ipv4(): ihl=%h", ihl);
    flags = data[6] >> 7;
    if (verbose) $display("decode_ipv4(): flags=%h", flags);
    // fragmented = 
    frag_offset = {data[6], data[7]} >> 3;
    if (verbose) $display("decode_ipv4(): frag_offset=%h", frag_offset);
    next_prot = data[9];
    if (verbose) $display("decode_ipv4(): next_prot=%h", next_prot);


    return out;
  endfunction


  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode_ipv6(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;

    return out;
  endfunction 


  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode_tcp(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;

    return out;
  endfunction 


  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode_udp(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;

    return out;
  endfunction 


  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode_gtp(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;

    return out;
  endfunction 


  //---------------------------------------------------------------------
  // 
  //---------------------------------------------------------------------
  function ref_model_t decode_icmp(ref_model_t in, bit write_transaction = 0, bit verbose);
    ref_model_t out;

    return out;
  endfunction 

  
endpackage // layer_decoder_ref_model_pkg
  
