`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2023 06:58:46 PM
// Design Name: 
// Module Name: MEM_WB_stage_control
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


module EX_MEM_stage_control(
    input  logic       clk_i,
    input  logic       rst_i,
    
    input  logic       regwriteE_i,
    input  logic [1:0] resultsrcE_i,
    input  logic       memwriteE_i,
    
    output logic       regwriteM_o,
    output logic [1:0] resultsrcM_o,
    output logic       memwriteM_o
    );
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
            regwriteM_o     <= '0;
            resultsrcM_o    <= '0;
            memwriteM_o     <= '0;
            end
            
        else begin
            regwriteM_o     <=  regwriteE_i;
            resultsrcM_o    <=  resultsrcE_i;
            memwriteM_o     <=  memwriteE_i; 
            end
        
    end
    
    
    
endmodule