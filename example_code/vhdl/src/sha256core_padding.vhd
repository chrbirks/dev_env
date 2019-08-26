-------------------------------------------------------------------------------
-- Title      : sha256core_padding
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256core_padding.vhd
-- Author     :   <chrbirks@CHRBIRKS-PC>
-- Company    : 
-- Created    : 2016-05-08
-- Last update: 2016-05-08
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-05-08  1.0      chrbirks	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity padding is
  
  generic (
    g_msg_size : integer := 256);

  port (
    message        : in  unsigned(1 downto 0);
    message_padded : out unsigned(1 downto 0));

end entity padding;

architecture rtl of padding is

begin  -- architecture rtl

  message_padded := message & '1' & c_zeros & to_unsigned(g_msg_size, c_length_size);

end architecture rtl;
