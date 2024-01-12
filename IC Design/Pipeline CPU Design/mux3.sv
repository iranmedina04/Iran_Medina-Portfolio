`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 10:36:59 PM
// Design Name: 
// Module Name: mux3
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

module mux3 #(
    parameter WIDTH = 32
)
(
    input  logic [WIDTH-1:0] d0_i, 
    input  logic [WIDTH-1:0] d1_i,
    input  logic [WIDTH-1:0] d2_i,
    input  logic [1:0]       s_i,
    
    output logic [WIDTH-1:0] y_o
);

    always_comb begin
        case (s_i)
            2'b00:
                y_o = d0_i;
            2'b01:
                y_o = d1_i;
            2'b10:
                y_o = d2_i;
            2'b11:
                y_o = '0;
        endcase
    end
endmodule
