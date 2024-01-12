`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 11:07:34 PM
// Design Name: 
// Module Name: reg_control
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


module reg_control(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        wr1_i,
    input  logic        wr2_i,
    input  logic        hold_ctrl_i,
    
    input  logic [31:0] data1_i,
    input  logic [31:0] data2_i,
    
    output logic [31:0] out_o

);

always_ff @(posedge clk_i) begin
    if (rst_i)
        out_o <= 0;
    
    else if ((wr1_i == 1) &  (hold_ctrl_i == 0))
        out_o <= data1_i;
       
    else if (wr2_i == 1)
        out_o <= data2_i;
    
    else 
        out_o <= out_o;
    
end


endmodule