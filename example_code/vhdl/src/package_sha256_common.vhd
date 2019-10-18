-------------------------------------------------------------------------------
-- Title      : package_sha256_common
-- Project    :
-------------------------------------------------------------------------------
-- File       : package_sha256_common.vhd
-- Author     :   <chrbirks@CHRBIRKS-PC>
-- Company    :
-- Created    : 2016-05-01
-- Last update: 2019-10-16
-- Platform   :
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Common constants and functions for SHA256.
-------------------------------------------------------------------------------
-- Copyright (c) 2016
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2016-05-01  1.0      chrbirks        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package package_sha256_common is

  type working_vars is record
    a   : unsigned(31 downto 0);
    b   : unsigned(31 downto 0);
    c   : unsigned(31 downto 0);
    d   : unsigned(31 downto 0);
    e   : unsigned(31 downto 0);
    f   : unsigned(31 downto 0);
    g   : unsigned(31 downto 0);
    h   : unsigned(31 downto 0);
    T_1 : unsigned(31 downto 0);
    T_2 : unsigned(31 downto 0);
  end record;

  constant c_H0 : unsigned(31 downto 0) := x"6A09E667";
  constant c_H1 : unsigned(31 downto 0) := x"BB67AE85";
  constant c_H2 : unsigned(31 downto 0) := x"3C6EF372";
  constant c_H3 : unsigned(31 downto 0) := x"A54FF53A";
  constant c_H4 : unsigned(31 downto 0) := x"510E527F";
  constant c_H5 : unsigned(31 downto 0) := x"9B05688C";
  constant c_H6 : unsigned(31 downto 0) := x"1F83D9AB";
  constant c_H7 : unsigned(31 downto 0) := x"5BE0CD19";

  type t_word_array is array (0 to 63) of unsigned(31 downto 0);
  constant c_K : t_word_array :=
    (0  => x"428a2f98", 1 => x"71374491", 2 => x"b5c0fbcf", 3 => x"e9b5dba5",
     4  => x"3956c25b", 5 => x"59f111f1", 6 => x"923f82a4", 7 => x"ab1c5ed5",
     8  => x"d807aa98", 9 => x"12835b01", 10 => x"243185be", 11 => x"550c7dc3",
     12 => x"72be5d74", 13 => x"80deb1fe", 14 => x"9bdc06a7", 15 => x"c19bf174",
     16 => x"e49b69c1", 17 => x"efbe4786", 18 => x"0fc19dc6", 19 => x"240ca1cc",
     20 => x"2de92c6f", 21 => x"4a7484aa", 22 => x"5cb0a9dc", 23 => x"76f988da",
     24 => x"983e5152", 25 => x"a831c66d", 26 => x"b00327c8", 27 => x"bf597fc7",
     28 => x"c6e00bf3", 29 => x"d5a79147", 30 => x"06ca6351", 31 => x"14292967",
     32 => x"27b70a85", 33 => x"2e1b2138", 34 => x"4d2c6dfc", 35 => x"53380d13",
     36 => x"650a7354", 37 => x"766a0abb", 38 => x"81c2c92e", 39 => x"92722c85",
     40 => x"a2bfe8a1", 41 => x"a81a664b", 42 => x"c24b8b70", 43 => x"c76c51a3",
     44 => x"d192e819", 45 => x"d6990624", 46 => x"f40e3585", 47 => x"106aa070",
     48 => x"19a4c116", 49 => x"1e376c08", 50 => x"2748774c", 51 => x"34b0bcb5",
     52 => x"391c0cb3", 53 => x"4ed8aa4a", 54 => x"5b9cca4f", 55 => x"682e6ff3",
     56 => x"748f82ee", 57 => x"78a5636f", 58 => x"84c87814", 59 => x"8cc70208",
     60 => x"90befffa", 61 => x"a4506ceb", 62 => x"bef9a3f7", 63 => x"c67178f2");

  function sigma_0_lower (x : in unsigned(31 downto 0))
    return unsigned;

  function sigma_1_lower (x : in unsigned(31 downto 0))
    return unsigned;

  function sigma_0_upper (x : unsigned(31 downto 0))
    return unsigned;

  function sigma_1_upper (x : unsigned(31 downto 0))
    return unsigned;

  function Ch (x, y, z : unsigned(31 downto 0))
    return unsigned;

  function Maj (x, y, z : unsigned(31 downto 0))
    return unsigned;

  --function digest (d : working_vars)
  --  return working_vars;

  procedure digest_proc (
    constant c_K : in    unsigned(31 downto 0);
    variable w   : in    unsigned(31 downto 0);
    variable a   : inout unsigned(31 downto 0);
    variable b   : inout unsigned(31 downto 0);
    variable c   : inout unsigned(31 downto 0);
    variable d   : inout unsigned(31 downto 0);
    variable e   : inout unsigned(31 downto 0);
    variable f   : inout unsigned(31 downto 0);
    variable g   : inout unsigned(31 downto 0);
    variable h   : inout unsigned(31 downto 0);
    variable T_1 : inout unsigned(31 downto 0);
    variable T_2 : inout unsigned(31 downto 0));

end package package_sha256_common;

package body package_sha256_common is

  function sigma_0_lower (
    x : in unsigned(31 downto 0))
    return unsigned is
  begin
    return rotate_right(x, 7) xor rotate_right(x, 18) xor shift_right(x, 3);
  end sigma_0_lower;

  function sigma_1_lower (
    x : in unsigned(31 downto 0))
    return unsigned is
  begin
    return rotate_right(x, 17) xor rotate_right(x, 19) xor shift_right(x, 10);
  end sigma_1_lower;

  function sigma_0_upper (
    x : unsigned(31 downto 0))
    return unsigned is
  begin
    return rotate_right(x, 2) xor rotate_right(x, 13) xor rotate_right(x, 22);
  end sigma_0_upper;

  function sigma_1_upper (
    x : unsigned(31 downto 0))
    return unsigned is
  begin
    return rotate_right(x, 6) xor rotate_right(x, 11) xor rotate_right(x, 25);
  end sigma_1_upper;

  function Ch (
    x, y, z : unsigned(31 downto 0))
    return unsigned is
  begin
    return (x and y) or ((not x) and z);
  end Ch;

  function Maj (
    x, y, z : unsigned(31 downto 0))
    return unsigned is
  begin
    return (x and y) or (x and z) or (y and z);
  end Maj;

  --function digest (
  --  signal d : working_vars)
  --  return working_vars is
  --begin  -- function digest
  --  return (d.a, d.b, d.c, d.d, d.e, d.f, d.g, d.h, d.T_1, d.T_2);
  --end function digest;

  procedure digest_proc (
    constant c_K : in    unsigned(31 downto 0);
    variable w   : in    unsigned(31 downto 0);
    variable a   : inout unsigned(31 downto 0);
    variable b   : inout unsigned(31 downto 0);
    variable c   : inout unsigned(31 downto 0);
    variable d   : inout unsigned(31 downto 0);
    variable e   : inout unsigned(31 downto 0);
    variable f   : inout unsigned(31 downto 0);
    variable g   : inout unsigned(31 downto 0);
    variable h   : inout unsigned(31 downto 0);
    variable T_1 : inout unsigned(31 downto 0);
    variable T_2 : inout unsigned(31 downto 0)) is
  begin  -- procedure digest
    T_1 := h + sigma_1_upper(e) + Ch(e, f, g) + c_K + w;
    T_2 := sigma_0_upper(a) + Maj(a, b, c);
    h   := g;
    g   := f;
    f   := e;
    e   := d + T_1;
    d   := c;
    c   := b;
    b   := a;
    a   := T_1 + T_2;
  end procedure digest_proc;

end package body package_sha256_common;
