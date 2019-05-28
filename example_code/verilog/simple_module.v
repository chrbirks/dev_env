module simple_module 
  (
   clk,
   reset
   );
  input         clk;
  input         reset;

  wire [31:0] next_crc;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      next_crc <= 32'hFFFFFFFF;
    end
    else begin
      next_crc <= 32'h00000000;
    end
  end

  assign next_crc = 32'h12345678;
  
endmodule
