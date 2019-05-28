#!/usr/local/bin/perl5
###############################################################################
#        Author: Chris Borrelli
#  Contributors: Nick Price, Mike Peattie
# Last Modified: 02/26/2001, Chris Borrelli
#       Version: 1.6
#
#    Disclaimer: THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
#                WHATSOEVER AND XILINX SPECIFICALLY DISCLAIMS ANY 
#                IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
#                A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
#
#  Copyright (c) 2001 Xilinx, Inc.  All rights reserved.
#
###############################################################################
use strict;
use Getopt::Long;
###############################################################################
# Default CRC parameters
###############################################################################
my $modulename  = "crc32";
my $input_width = 8;
my $crc_width   = 32;
my $filename    = "crc" . $crc_width . "_" . $input_width . ".v";
my @polynomial  = (1, 1, 1, 0, 1, 1, 0, 1,
                   1, 0, 1, 1, 1, 0, 0, 0,
                   1, 0, 0, 0, 0, 0, 1, 1,
                   0, 0, 1, 0, 0, 0, 0, 0, 1);
my $reg_init    = "F";
###############################################################################
# Defines
###############################################################################
my $input_msb_index = $input_width - 1;
my $crc_msb_index   = $crc_width - 1;
my $usage = 
   "nUsage: crcgen.pl [-crcwidth <width:8,12,16,32>] " .
   "[-inputwidth <width:1...32>]n [-poly <polynomial>] " .
   "[-crcinit <init:preset,reset>] " .
   "<outfile>nn";
###############################################################################
# Command-line Parsing
###############################################################################
my $help;
my $crcwidth_opt;
my $inputwidth_opt;
my $poly_opt;
my $crcinit_opt;
if ( @ARGV > 0) {
   GetOptions( 'crcwidth=i' => $crcwidth_opt,
               'inputwidth=i' => $inputwidth_opt,
               'poly=s' => $poly_opt,
               'crcinit=s' => $crcinit_opt,
               'help' => $help)
      or die $usage;
}
if ($help > 0) {die $usage;}
if ($crcwidth_opt) {
   if ($crcwidth_opt == 8 or $crcwidth_opt == 12 or 
       $crcwidth_opt == 16 or $crcwidth_opt == 32)   {
      $crc_width = $crcwidth_opt;
   }
   else {die "nERROR: Invalid CRC Width.n" . $usage;}
}
if ($inputwidth_opt) {
   if ($inputwidth_opt > 0 and $inputwidth_opt < 33) {
      $input_width = $inputwidth_opt;
   }
   else {die "nERROR: Invalid Input Width.n" . $usage;}
}
if ($poly_opt) {
   @polynomial = reverse(split //, $poly_opt);
   if ($poly_opt =~ /[^0-1]/) {
      die "nERROR: Invalid Polynomial: $poly_opt.n" . $usage;
   } 
}
if ($crcinit_opt) {
   if ($crcinit_opt eq "preset") {
      $reg_init = "F";
   }
   elsif ($crcinit_opt eq "reset") {
      $reg_init = "0";
   }
   else { die "nERROR: Invalid crcinit option: $crcinit_opt.n" . $usage; }
}
if (@ARGV > 0) {
   $filename    = $ARGV[0];
} else {$filename = "crc" . $crc_width . "_" . $input_width . ".v";}
open (OUTFILE, "> $filename") or die "Couldn't open file $filename: $!nn";
###############################################################################
# Check validity of parameters
###############################################################################
if (@polynomial != ($crc_width + 1)) {
   die "nERROR: Invalid Polynomial length for CRC Width of $crc_width.n" . 
       $usage;
}
if ( ($crc_width % $input_width) != 0) {
   die "nERROR: CRC Width must be evenly divisible by Input Width.n" . 
       $usage;
}
###############################################################################
# Generate xor equations
###############################################################################
my $i;
my $j;
my @crc;
my @ncrc;
for ($i = 0; $i < $crc_width; $i++) {
   $crc[$i] = "crc_reg[${i}]";
}
for ($i = 0; $i < $input_width; $i++) {
   $ncrc[0] =  $crc[$crc_width-1] . " d[${i}]";
   for ($j = 1; $j < $crc_width; $j++) {
      if ($polynomial[$j] == 1) {
         $ncrc[$j] = $crc[$j - 1] . " $crc[$crc_width-1] d[${i}]";
      }
      else {
         $ncrc[$j] = $crc[$j -1];
      }
   }
   @crc = @ncrc;
}  
###############################################################################
# Optimize xor Equations
###############################################################################
my @crc_temp;
my %crc_opt_hash;
my $hash_key;
my $hash_val;
my @crc_opt;
for ($i = 0; $i < $crc_width; $i++) {
   @crc_temp = split(' ', $crc[$i]);
   for ($j = 0; $j < ($#crc_temp+1); $j++){
      if (defined ($crc_opt_hash{$crc_temp[$j]})) {
         $crc_opt_hash{$crc_temp[$j]} =
            $crc_opt_hash{$crc_temp[$j]} + 1;
      }
      else {$crc_opt_hash{$crc_temp[$j]} = 1;}
   }
   while ( ($hash_key, $hash_val)=each %crc_opt_hash) {
      if ($hash_val % 2 != 0) {
         if (length($crc_opt[$i]) > 0) {
            $crc_opt[$i] .= " ^ $hash_key";
         }
         else {
            $crc_opt[$i] = "$hash_key";
         }
      }
   }
   ###############################
   # clear hash for next iteration
   while ( ($hash_key, $hash_val)=each %crc_opt_hash) {
      delete $crc_opt_hash{$hash_key};
   }
}
###############################################################################
# Generate Verilog source for Module statement and I/O definitions
###############################################################################
print OUTFILE <<END_OF_MODULE_DECLARATION;
//////////////////////////////////////////////////////////////////////////////
//
// crc calculation
// This VERILOG code was generated using CRCGEN.PL version 1.6
// Last Modified: 02/26/2001
// Options Used:
//    Module Name = $modulename
//      CRC Width = $crc_width
//     Data Width = $input_width
//     CRC Init   = $reg_init
//     Polynomial = [0 -> $crc_width]
//        @polynomial
//
// Disclaimer: THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY 
//             WHATSOEVER AND XILINX SPECIFICALLY DISCLAIMS ANY 
//             IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR
//             A PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
//
// Copyright (c) 2001 Xilinx, Inc.  All rights reserved.
//
//
//////////////////////////////////////////////////////////////////////////////
module $modulename (
   crc_reg, 
   crc,
   d,
   calc,
   init,
   d_valid,
   clk,
   reset
   );
output [$crc_msb_index:0] crc_reg;
output [$input_msb_index:0]  crc;
input  [$input_msb_index:0]  d;
input         calc;
input         init;
input         d_valid;
input         clk;
input         reset;
reg    [$crc_msb_index:0] crc_reg;
reg    [$input_msb_index:0]  crc;
//////////////////////////////////////////////////////////////////////////////
// Internal Signals
//////////////////////////////////////////////////////////////////////////////
wire   [$crc_msb_index:0] next_crc;
END_OF_MODULE_DECLARATION
###############################################################################
# Generate Internal Perl Strings for Later Verilog source output
###############################################################################
$i = 0;
my $crc_out1 = "";
my $crc_out2 = "";
my $a;
for ($a=$crc_width-$input_width;$a<$crc_width;$a++) {
   $crc_out1 = $crc_out1 . "next_crc[$a]";
   $crc_out2 = $crc_out2 . "crc_reg[" . sprintf("%d", $a-$input_width) . "]";
   $i = $i + 1;
   
   if ($a < ($crc_width-1) ) {
      $crc_out1 = $crc_out1 . ",";
      $crc_out2 = $crc_out2 . ",";
      
      if ($i == 4) {
         $crc_out1 = $crc_out1 . "n                   ";
         $crc_out2 = $crc_out2 . "n                   ";
         $i = 0;
      }
      else {
         $crc_out1 = $crc_out1 . " ";
         $crc_out2 = $crc_out2 . " ";
      }
   }   
}
my $crc_reg_init = "";
my $crc_init = "";
for ($a=0;$a<($crc_width/4);$a++) {$crc_reg_init = $crc_reg_init . $reg_init;}
for ($a=0;$a<($input_width/4);$a++) {$crc_init = $crc_init . $reg_init;}
my $crc_reg_shift_index = $crc_width - $input_width - 1;
###############################################################################
# Generate Verilog source for Registers and Control Logic
###############################################################################
print OUTFILE <<END_OF_REGISTERS;
//////////////////////////////////////////////////////////////////////////////
// Infer CRC-$crc_width registers
// 
// The crc_reg register stores the CRC-$crc_width value.
// The crc register is the most significant $input_width bits of the 
// CRC-$crc_width value.
//
// Truth Table:
// -----+---------+----------+----------------------------------------------
// calc | d_valid | crc_reg  | crc 
// -----+---------+----------+----------------------------------------------
//  0   |     0   | crc_reg  | crc 
//  0   |     1   |  shift   | bit-swapped, complimented msbyte of crc_reg
//  1   |     0   | crc_reg  | crc 
//  1   |     1   | next_crc | bit-swapped, complimented msbyte of next_crc
// -----+---------+----------+----------------------------------------------
// 
//////////////////////////////////////////////////////////////////////////////
 
always @ (posedge clk or posedge reset)
begin
   if (reset) begin
      crc_reg <= ${crc_width}'h$crc_reg_init;
      crc     <= ${input_width}'h$crc_init;
   end
   
   else if (init) begin
      crc_reg <= ${crc_width}'h$crc_reg_init;
      crc     <=  ${input_width}'h$crc_init;
   end
   else if (calc & d_valid) begin
      crc_reg <= next_crc;
      crc     <= ~{$crc_out1};
   end
   
   else if (~calc & d_valid) begin
      crc_reg <=  {crc_reg[$crc_reg_shift_index:0], ${input_width}'h$crc_init};
      crc     <= ~{$crc_out2};
   end
end
END_OF_REGISTERS
###############################################################################
# Generate Verilog source from optimized xor equations
###############################################################################
print OUTFILE <<END_OF_XOR_COMMENTS;
//////////////////////////////////////////////////////////////////////////////
// CRC XOR equations
//////////////////////////////////////////////////////////////////////////////
END_OF_XOR_COMMENTS
for ($i = 0; $ i < $crc_width; $i++){
  print OUTFILE "assign next_crc[${i}] = $crc_opt[$i];n";
}
###############################################################################
# Generate Verilog source for endmodule statement
###############################################################################
print OUTFILE "endmodulen";
close (OUTFILE);
