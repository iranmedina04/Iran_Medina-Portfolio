`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2023 09:38:52 PM
// Design Name: 
// Module Name: top_sumadores
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


module top_sumadores(
    input logic [7:0] a_i,
    input logic [7:0] b_i,
    input logic       ci_i, 
    
    output logic [7:0] rca_sum_o,
    output logic [8:0] rca_co_o,
    
    output logic [7:0] cla_sum_o,
    output logic [8:0] cla_co_o
    
    );
    
    localparam ANCHO = 8;
    
    ripple_carry_adder #(.ANCHO(ANCHO)) rca (
        .a_i        (a_i),
        .b_i        (b_i),
        .ci_i       (ci_i),
        
        .sum_o      (rca_sum_o),
        .co_o       (rca_co_o)
    
    );
    
    carry_lookahead_adder cla (
        .a_i        (a_i),
        .b_i        (b_i),
        .ci_i       (ci_i), 
            
        .sum_o      (cla_sum_o),
        .co_o       (cla_co_o)
    );
    
endmodule
