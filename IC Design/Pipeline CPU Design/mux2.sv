`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 10:33:58 PM
// Design Name: 
// Module Name: mux2
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


module mux2 #(
parameter WIDTH = 8
)
(
    input  logic [WIDTH-1:0] d0_i,
    input  logic [WIDTH-1:0] d1_i,
    input  logic             s_i,
    output logic [WIDTH-1:0] y_o
);

assign y_o = s_i ? d1_i : d0_i;

endmodule
