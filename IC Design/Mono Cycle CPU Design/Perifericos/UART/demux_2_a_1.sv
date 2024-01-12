`timescale 1ns / 1ps

module demux_2_a_1 (

    input logic   in_i,
    input logic   sel_i,

    output logic  out1_o,
    output logic  out2_o
);

  always_comb begin
    case (sel_i)
      1'b0: begin 
          out1_o = in_i;
          out2_o = '0;
      end
      1'b1: begin 
          out2_o = in_i;
          out1_o = '0;
      end
      default: begin
        out1_o = '0;
        out2_o = '0;
      end
    endcase
  end

endmodule
