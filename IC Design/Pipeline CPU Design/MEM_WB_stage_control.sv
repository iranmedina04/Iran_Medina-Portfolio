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


module MEM_WB_stage_control(
    input  logic       clk_i,
    input  logic       rst_i,
    
    input  logic       regwriteM_i,
    input  logic [1:0] resultsrcM_i,
    
    output logic       regwriteW_o,
    output logic [1:0] resultsrcW_o
  
    );
    
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
            regwriteW_o    <= '0;
            resultsrcW_o   <= '0;
            
            end
            
        else begin
            regwriteW_o    <= regwriteM_i;
            resultsrcW_o   <= resultsrcM_i;
            end
        
    end
    
endmodule
