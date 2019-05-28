`include "common_pkg.sv";
import common_pkg::*;

module testmodule (
  input logic                    clk_i,
  input [$clog2(TEST_PARAM)-1:0] aa_i,
  input logic                    a_i,
  output logic [1:0]             b_o
  );

  mytype2_t my;

  initial begin
    my.a = 0;
    my.b = 0;
  end

  always @(posedge clk_i) begin
    undeclared_var <= 1'b1;

    my.a <= 1'b1;
    my.b <= 1'b1;
  end
  logic undeclared_var;

  always_comb begin
    tmpa = tmpb;
    tmpb = 1;
  end
  logic tmpa;
  logic tmpb;

  
  
endmodule // testmodule
