`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2023 07:54:37 PM
// Design Name: 
// Module Name: module_sevseg
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


module module_sevseg(
    input logic  [3:0] d_i,
    output logic [6:0] s_o,
    output logic [7:0] en 
    );
    assign en = 7'b01111111;
    
    always_comb begin
        case (d_i)
            4'b0000:
                s_o = ~7'b1110111;
            4'b0001:
                s_o = ~7'b1000001;
            4'b0010:
                s_o = ~7'b1101110;
            4'b0011:
                s_o = ~7'b1101011;
            4'b0100:
                s_o = ~7'b1011001;
            4'b0101:
                s_o = ~7'b0111011;
            4'b0110:
                s_o = ~7'b0111111;
            4'b0111:
                s_o = ~7'b1100001;
            4'b1000:
                s_o = ~7'b1111111;
            4'b1001:
                s_o = ~7'b1111001;
            4'b1010:
                s_o = ~7'b1111101;
            4'b1011:
                s_o = ~7'b0011111;
            4'b1100:
                s_o = ~7'b0110110;
            4'b1101:
                s_o = ~7'b1001111;
            4'b1110:
                s_o = ~7'b0111110;
            4'b1111:
                s_o = ~7'b0111100;
            default:
                s_o = ~7'b0000000;
        endcase
    end 
endmodule
