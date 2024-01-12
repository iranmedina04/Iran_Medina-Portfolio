`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2023 01:55:05 PM
// Design Name: 
// Module Name: register_n_bits
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


module register_n_bits
    #(
        parameter N = 16
    )
    (
    input  logic               clk_i, rst_i, we_i,
    input  logic  [ N - 1 : 0] data_i,
    output logic  [ N - 1 : 0] data_o
    );
    
    always_ff@(posedge clk_i)begin
    
        if (!rst_i)
            data_o <= 0;
            
        else if (we_i)
            data_o <= data_i;
            
        else
            data_o <= data_o;
            
    end
endmodule
