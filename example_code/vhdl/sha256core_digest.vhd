-------------------------------------------------------------------------------
-- Title      : sha256core_digest
-- Project    :
-------------------------------------------------------------------------------
-- File       : sha256core_digest.vhd
-- Author     :   <chrbirks@CHRBIRKS-PC>
-- Company    :
-- Created    : 2016-04-24
-- Last update: 2019-05-27
-- Platform   :
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2016
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-04-24  1.0      chrbirks        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_sha256_common.all;

entity digester is
  generic (
    k : unsigned(31 downto 0));
  port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    w       : in  unsigned(31 downto 0);
    a_in    : in  unsigned(31 downto 0);
    b_in    : in  unsigned(31 downto 0);
    c_in    : in  unsigned(31 downto 0);
    d_in    : in  unsigned(31 downto 0);
    e_in    : in  unsigned(31 downto 0);
    f_in    : in  unsigned(31 downto 0);
    g_in    : in  unsigned(31 downto 0);
    h_in    : in  unsigned(31 downto 0);
    T_1_in  : in  unsigned(31 downto 0);
    T_2_in  : in  unsigned(31 downto 0);
    a_out   : out unsigned(31 downto 0);
    b_out   : out unsigned(31 downto 0);
    c_out   : out unsigned(31 downto 0);
    d_out   : out unsigned(31 downto 0);
    e_out   : out unsigned(31 downto 0);
    f_out   : out unsigned(31 downto 0);
    g_out   : out unsigned(31 downto 0);
    h_out   : out unsigned(31 downto 0);
    T_1_out : out unsigned(31 downto 0);
    T_2_out : out unsigned(31 downto 0));
end entity digester;

architecture rtl of digester is
begin

  process(clk) is
    variable T_1, T_2 : unsigned(31 downto 0);
  begin
    if (rising_edge(clk)) then
      T_1 := h_in + sigma_1_upper(e_in) + Ch(e_in, f_in, g_in) + K + w;
      T_2 := sigma_0_upper(a_in) + Maj(a_in, b_in, c_in);

      T_1_out <= T_1;
      T_2_out <= T_2;
      h_out   <= g_in;
      g_out   <= f_in;
      f_out   <= e_in;
      e_out   <= d_in + T_1;
      d_out   <= c_in;
      c_out   <= b_in;
      b_out   <= a_in;
      a_out   <= T_1 + T_2;

      if reset = '1' then
        a_out   <= (others => '0');
        b_out   <= (others => '0');
        c_out   <= (others => '0');
        d_out   <= (others => '0');
        e_out   <= (others => '0');
        f_out   <= (others => '0');
        g_out   <= (others => '0');
        h_out   <= (others => '0');
        T_1_out <= (others => '0');
        T_2_out <= (others => '0');
      end if;
    end if;
  end process;

end rtl;
