-------------------------------------------------------------------------------
-- Title      : sha256core_wrapper
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256core_wrapper.vhd
-- Author     :   <chrbi_000@SURFACE>
-- Company    : 
-- Created    : 2016-04-08
-- Last update: 2016-05-08
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Wrapper for core_top.vhd
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

entity sha256core_wrapper is
  port (
    clk_50mhz : in  std_logic;
    reset_n   : in  std_logic;
    valid_led : out std_logic);
end entity sha256core_wrapper;

architecture str of sha256core_wrapper is
  constant c_msg_size   : integer  := 24;
  constant c_digest_ref : unsigned := x"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad";  -- For message x"616263"

  signal clk_200mhz    : std_logic := '0';
  signal reset         : std_logic                       := '0';
  signal message       : unsigned(c_msg_size-1 downto 0) := (others => '0');
  signal message_valid : std_logic                       := '1';
  signal message_ready : std_logic;
  signal digest        : unsigned(255 downto 0)          := (others => '0');
  signal digest_valid  : std_logic;
  signal digest_ready  : std_logic                       := '1';
begin

  reset <= not reset_n;

  i_pll : entity work.pll
    port map (
      areset => reset,
      inclk0 => clk_50mhz,
      c0     => clk_200mhz,
      locked => open);

  i_sha256core_top : entity work.sha256core_top(rtl_3)
    generic map (
      g_msg_size => c_msg_size)
    port map (
      clk           => clk_200mhz,
      reset         => reset,
      message       => message,
      message_valid => message_valid,
      message_ready => message_ready,
      digest        => digest,
      digest_valid  => digest_valid,
      digest_ready  => digest_ready);

  p_main : process(clk_200mhz) is
  begin
    if (rising_edge(clk_200mhz)) then
      message       <= x"616263";
      message_valid <= '1';
      digest_ready  <= '1';

      if (digest = c_digest_ref) then
        --if (digest(0) = '1') then
        valid_led <= '1';
      else
        valid_led <= '0';
      end if;

      if (reset = '1') then
        message       <= x"000000";
        message_valid <= '0';
        digest_ready  <= '0';
      end if;
    end if;

  end process p_main;

end architecture str;
