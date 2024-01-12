`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2023 12:12:23 AM
// Design Name: 
// Module Name: demux_2_a_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module demux_2_a_1(
    input  logic in_i,    
    input  logic sel_i,
    
    output logic out2_o,
    output logic out1_o
);

    always_comb begin
        case (sel_i)
            1'b0: begin
                out1_o = in_i;
                out2_o = 0;
            end
            
            1'b1: begin
                out1_o = 0;
                out2_o = in_i;
            end
            
            default: begin
                out1_o = 0;
                out2_o = 0;
            end
        endcase
    end

endmodule
