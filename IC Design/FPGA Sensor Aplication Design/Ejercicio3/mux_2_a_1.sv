`timescale 1ns / 1ps

module mux_2_a_1 (

    input logic [31:0] a_i,
    input logic [31:0] b_i,
    input logic        sel_i,

    output logic [31:0] out_o
);

  always_comb begin
    case (sel_i)
      1'b0: out_o = a_i;
      1'b1: out_o = b_i;
      default: out_o = '0;
    endcase
  end

endmodule
