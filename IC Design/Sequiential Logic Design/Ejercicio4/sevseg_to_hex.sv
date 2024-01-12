`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 07:47:14 PM
// Design Name: 
// Module Name: sevseg_to_hex
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


module sevseg_to_hex(
    input  logic [6:0] seg,
    output logic [3:0] hex
    );
    
    always_comb begin
        case(seg)
            ~7'b1110111:
                hex = 4'b0000;
            ~7'b1000001:
                hex = 4'b0001;
            ~7'b1101110:
                hex = 4'b0010;
            ~7'b1101011:
                hex = 4'b0011;
            ~7'b1011001:
                hex = 4'b0100;
            ~7'b0111011:
                hex = 4'b0101;
            ~7'b0111111:
                hex = 4'b0110;
            ~7'b1100001:
                hex = 4'b0111;
            ~7'b1111111:
                hex = 4'b1000;
            ~7'b1111001:
                hex = 4'b1001;
            ~7'b1111101:
                hex = 4'b1010;
            ~7'b0011111:
                hex = 4'b1011;
            ~7'b0110110:
                hex = 4'b1100;
            ~7'b1001111:
                hex = 4'b1101;
            ~7'b0111110:
                hex = 4'b1110;
            ~7'b0111100:
                hex = 4'b1111;
            default:
                hex = 4'b0000;
        endcase
    end 
    
endmodule
