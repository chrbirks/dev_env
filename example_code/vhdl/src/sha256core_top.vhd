-------------------------------------------------------------------------------
-- Title      : sha256core_top
-- Project    :
-------------------------------------------------------------------------------
-- File       : sha256core_top.vhd
-- Author     :   <chrbi_000@SURFACE>
-- Company    :
-- Created    : 2016-04-08
-- Last update: 2019-05-12
-- Platform   :
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2016
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-04-08  1.0      chrbi_000       Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_sha256_common.all;

entity sha256core_top is
  generic (
    g_msg_size : integer := 256);
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    --
    message       : in  unsigned(g_msg_size-1 downto 0);
    message_valid : in  std_logic;
    message_ready : out std_logic;
    --
    digest        : out unsigned(255 downto 0);
    digest_valid  : out std_logic;
    digest_ready  : in  std_logic);
end entity sha256core_top;

-------------------------------------------------------------------------------

architecture rtl_3 of sha256core_top is
  constant c_block_size  : integer                                                    := 512;
  constant c_length_size : integer                                                    := 64;
  constant c_zeros       : unsigned(c_block_size-g_msg_size-c_length_size-2 downto 0) := (others => '0');

  type t_fsm_state is (s_wait, s_init, s_processing, s_digest_valid);
  signal cur_state  : t_fsm_state;
  signal next_state : t_fsm_state;

  signal digest_valid_int    : std_logic                     := '0';
  signal message_ready_int   : std_logic                     := '0';
  -- Array for determining when output is valid. LSB is strobe for valid output
  signal message_valid_array : std_logic_vector(64 downto 0) := (others => '0');

  signal counter : integer range 0 to 67;

  --signal reset : std_logic;
  --signal message_zero_padded   : unsigned(c_block_size-1 downto 0) := (others => '0');
  --signal message_length_padded : unsigned(c_block_size-1 downto 0) := (others => '0');

  signal w : t_word_array := (others => (others => '0'));

  type t_working_word_array is array (0 to 64) of unsigned(31 downto 0);
  signal a                              : t_working_word_array  := (0      => c_H0, others => (others => '0'));
  signal b                              : t_working_word_array  := (0      => c_H1, others => (others => '0'));
  signal c                              : t_working_word_array  := (0      => c_H2, others => (others => '0'));
  signal d                              : t_working_word_array  := (0      => c_H3, others => (others => '0'));
  signal e                              : t_working_word_array  := (0      => c_H4, others => (others => '0'));
  signal f                              : t_working_word_array  := (0      => c_H5, others => (others => '0'));
  signal g                              : t_working_word_array  := (0      => c_H6, others => (others => '0'));
  signal h                              : t_working_word_array  := (0      => c_H7, others => (others => '0'));
  signal T_1, T_2                       : t_working_word_array  := (others => (others => '0'));
  signal H0, H1, H2, H3, H4, H5, H6, H7 : unsigned(31 downto 0) := (others => '0');

begin

  assert g_msg_size < 447 report "Input message wrong length" severity failure;

  p_main : process(clk)
  begin
    if rising_edge(clk) then
      cur_state <= next_state;

      if reset = '1' then
        cur_state <= s_wait;
      end if;
    end if;
  end process p_main;

  digest_valid  <= digest_valid_int;
  message_ready <= message_ready_int;

  p_fsm : process(cur_state, digest_ready, digest_valid_int, message_valid)
  begin
    case cur_state is

      when s_wait =>
        if message_valid = '1' then
          next_state <= s_init;
        else
          next_state <= s_wait;
        end if;

      when s_init =>
        next_state <= s_processing;

      when s_processing =>
        if digest_valid_int = '1' then
          if digest_ready = '1' then
            next_state <= s_wait;
          else
            next_state <= s_digest_valid;
          end if;
        else
          next_state <= s_processing;
        end if;

      when s_digest_valid =>
        if digest_ready = '1' then
          next_state <= s_wait;
        else
          next_state <= s_digest_valid;
        end if;

      when others =>
        null;

    end case;
  end process p_fsm;

  p_counter : process(clk)
  begin
    if rising_edge(clk) then

      case cur_state is

        when s_wait =>
          if message_valid = '1' then
            message_ready_int <= '0';
          else
            message_ready_int <= '1';
          end if;

        when s_init =>
          message_ready_int <= '0';

        when others =>
          null;                         -- FIXME: Latches created here?

      end case;

      if reset = '1' then
        message_ready_int <= '0';
      end if;

    end if;
  end process p_counter;

  -- p_state_memory : process(clk) is
  -- begin
  --   if (rising_edge(clk)) then

  --     --cur_state <= next_state;

  --     --counter <= counter + 1;
  --     --digest_valid <= '0';

  --     if (counter = 66) then
  --       counter <= 0;
  --     --digest_valid <= '1';
  --     end if;

  --     if (reset = '1') then
  --       --cur_state <= s_init;
  --       counter <= 0;
  --     --digest_valid <= '0';
  --     end if;
  --   --
  --   end if;
  -- end process p_state_memory;

  -----------------------------------------------------------------------------
  -- Delay through the pipeline is 67 clock cycles. Delay message_valid by 67
  -- clock cycles and make it assert digest_valid.
  -----------------------------------------------------------------------------
  p_valid : process(clk) is
  begin
    if (rising_edge(clk)) then

      case cur_state is
        when s_wait =>
          message_valid_array <= (others => '0');
        when s_init =>
          message_valid_array <= (message_valid_array'left => '1', others => '0');
        when s_processing =>
          -- Shift right and pad with 0 but hold value at the end
          if message_valid_array(0) = '1' then
            message_valid_array <= (message_valid_array'right => '1', others => '0');
          else
            message_valid_array <= '0' & message_valid_array(message_valid_array'length-1 downto 1);
          end if;
        when s_digest_valid =>
          message_valid_array <= (message_valid_array'right => '1', others => '0');
      end case;

      digest_valid_int <= message_valid_array(0);

      if (reset = '1') then
        message_valid_array <= (others => '0');
        digest_valid_int    <= '0';
      end if;
    end if;
  end process p_valid;

  -----------------------------------------------------------------------------
  -- Pipelining calculation of all working variables.
  -- Input is i, output is i+1, so final output is a(64), b(64), etc.
  -----------------------------------------------------------------------------
  digest_loop : for i in 0 to 63 generate
  begin
    i_digester : entity work.digester(rtl)
      generic map (
        K => c_K(i))
      port map (
        clk     => clk,
        reset   => reset,
        w       => w(i),
        a_in    => a(i),
        b_in    => b(i),
        c_in    => c(i),
        d_in    => d(i),
        e_in    => e(i),
        f_in    => f(i),
        g_in    => g(i),
        h_in    => h(i),
        T_1_in  => T_1(i),
        T_2_in  => T_2(i),
        a_out   => a(i+1),
        b_out   => b(i+1),
        c_out   => c(i+1),
        d_out   => d(i+1),
        e_out   => e(i+1),
        f_out   => f(i+1),
        g_out   => g(i+1),
        h_out   => h(i+1),
        T_1_out => T_1(i+1),
        T_2_out => T_2(i+1));
  end generate digest_loop;

  p_hash : process(clk) is
    variable message_zero_padded : unsigned(c_block_size-1 downto 0) := (others => '0');
  --variable w_int : t_word_array := (others => (others => '0'));
  begin
    if (rising_edge(clk)) then

      -- Cycle 1: Pad message
      message_zero_padded := message & '1' & c_zeros & to_unsigned(g_msg_size, c_length_size);

      -- Cycle 1: Prepare message schedule, FIXME: convert to for-generate?
      for t in 0 to 15 loop
        w(t) <= message_zero_padded(message_zero_padded'left - t*32 downto message_zero_padded'left - t*32 - 31);
      --w_int(t) := message_zero_padded(message_zero_padded'left - t*32 downto message_zero_padded'left - t*32 - 31);
      end loop;
      for t in 16 to 63 loop
        w(t) <= sigma_1_lower(w(t-2)) + w(t-7) + sigma_0_lower(w(t-15)) + w(t-16);
      --w_int(t) := sigma_1_lower(w(t-2)) + w(t-7) + sigma_0_lower(w(t-15)) + w(t-16);
      end loop;
      --w <= w_int;

      -- Cycle 66: Compute the intermediate hash value
      H0 <= a(64) + c_H0;
      H1 <= b(64) + c_H1;
      H2 <= c(64) + c_H2;
      H3 <= d(64) + c_H3;
      H4 <= e(64) + c_H4;
      H5 <= f(64) + c_H5;
      H6 <= g(64) + c_H6;
      H7 <= h(64) + c_H7;

      -- Cycle 67: Concatenate the digest
      digest <= H0 & H1 & H2 & H3 & H4 & H5 & H6 & H7;

      if (reset = '1') then
        message_zero_padded := (others => '0');
        w                   <= (others => (others => '0'));

        a(0) <= c_H0;
        b(0) <= c_H1;
        c(0) <= c_H2;
        d(0) <= c_H3;
        e(0) <= c_H4;
        f(0) <= c_H5;
        g(0) <= c_H6;
        h(0) <= c_H7;
      end if;
    end if;

  end process p_hash;

end architecture rtl_3;
