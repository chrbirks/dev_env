-------------------------------------------------------------------------------
-- Title      : Testbench for design "sha256core_top"
-- Project    :
-------------------------------------------------------------------------------
-- File       : sha256core_top_tb.vhd
-- Author     :   <chrbi_000@SURFACE>
-- Company    :
-- Created    : 2016-04-08
-- Last update: 2016-06-06
-- Platform   :
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2016
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-04-08  1.0      chrbirks       Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

-------------------------------------------------------------------------------

entity sha256core_top_24bit_tb is
end entity sha256core_top_24bit_tb;

-------------------------------------------------------------------------------

architecture bhv of sha256core_top_24bit_tb is

  -- constants
  constant c_200mhz_clk_period : time := 5 ns;

  -- component ports
  signal reset         : std_logic;
  signal message       : unsigned(23 downto 0) := (others => '0');
  signal message_valid : std_logic             := '0';
  signal message_ready : std_logic;
  signal digest        : unsigned(255 downto 0);
  signal digest_valid  : std_logic;
  signal digest_ready  : std_logic             := '0';

  -- clock
  signal clk_200mhz_tb : std_logic := '0';

begin  -- architecture bhv

  -- component instantiation
  DUT : entity work.sha256core_top(rtl_3)
    generic map (
      g_msg_size => 24)
    port map (
      clk           => clk_200mhz_tb,   -- in
      reset         => reset,           -- in
      message       => message,         -- in
      message_valid => message_valid,   -- in
      message_ready => message_ready,   -- out
      digest        => digest,          -- out
      digest_valid  => digest_valid,    -- out
      digest_ready  => digest_ready);   -- in

  -- clock generation
  clk_200mhz_tb <= not clk_200mhz_tb after c_200mhz_clk_period/2;

  -- waveform generation
  p_stimuli : process
  begin
    reset   <= '1';
    message <= x"616263";               -- "abc"

    wait until clk_200mhz_tb = '1';
    wait until clk_200mhz_tb = '1';
    wait until clk_200mhz_tb = '1';
    wait until clk_200mhz_tb = '1';
    wait until clk_200mhz_tb = '1';
    reset <= '0';

    if (message_ready = '0') then
      wait until clk_200mhz_tb = '1' and message_ready = '1';
    end if;

    message_valid <= '1';
    digest_ready  <= '1';
    wait until clk_200mhz_tb = '1';
    message_valid <= '0';

    wait until digest_valid = '1';
    --report "signal digest is " & integer'image(to_integer(digest));
--    report "      and ref is " & integer'image(to_integer(x"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"));
    assert digest = x"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" report "Wrong digest!" severity failure;

    wait for 10*c_200mhz_clk_period;

    ---------------------------------------------------------------------------
    -- Test new message
    ---------------------------------------------------------------------------
    digest_ready <= '0';
    message       <= x"636261";         -- "cba"
    message_valid <= '1';

    if message_ready = '0' then
      wait until clk_200mhz_tb = '1' and message_ready = '1';
    end if;

    wait until clk_200mhz_tb = '1';
    message_valid <= '0';

    wait until digest_valid = '1';
    wait for 10*c_200mhz_clk_period;
    digest_ready <= '1';
    wait until clk_200mhz_tb = '1';
    assert digest = x"6d970874d0db767a7058798973f22cf6589601edab57996312f2ef7b56e5584d" report "Wrong digest!" severity failure;

    wait for 10*c_200mhz_clk_period;

    ---------------------------------------------------------------------------
    -- Test new message
    ---------------------------------------------------------------------------
    wait until clk_200mhz_tb = '1';

    message       <= x"06af3f";
    message_valid <= '1';

    if message_ready = '0' then
      wait until clk_200mhz_tb = '1' and message_ready = '1';
    end if;

    wait until clk_200mhz_tb = '1';
    message_valid <= '0';

    wait until digest_valid = '1';
    assert digest = x"d9d4786ae228f2c62bed8132c8975443cd6ce72b4aa81329566e8effa5efda6b" report "Wrong digest!" severity failure;

    ---------------------------------------------------------------------------
    -- Finish testbench
    ---------------------------------------------------------------------------
    digest_ready <= '0';

    wait for 10*c_200mhz_clk_period;
    reset <= '1';

    -- End testbench
    wait for 100*c_200mhz_clk_period;
    --report "Simulation finished" severity failure;
    stop(2);
  end process p_stimuli;



end architecture bhv;

-------------------------------------------------------------------------------

-- configuration sha256core_top_tb_bhv_cfg of sha256core_top_tb is
--   for bhv
--   end for;
-- end sha256core_top_tb_bhv_cfg;

-------------------------------------------------------------------------------
