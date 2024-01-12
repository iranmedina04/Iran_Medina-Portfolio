`timescale 1ns / 1ps

module reg_control_uart (

    input logic        clk_i,
    input logic        rst_i,
    input logic        wr1_i,
    input logic        wr2_i,
    input logic [31:0] data1_i,
    input logic [31:0] data2_i,

    output logic [31:0] out_o

);

  always_ff @(posedge clk_i) begin
    if (!rst_i) begin
      out_o <= '0;
    end else begin
      if (wr1_i == 1) begin
        out_o <= data1_i;
      end
      else if (wr2_i == 1) begin
        out_o <= data2_i;
      end
      else begin 
        out_o <= '0;
      end
    end
  end


endmodule
