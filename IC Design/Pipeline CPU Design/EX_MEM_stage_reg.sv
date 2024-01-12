`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2023 04:36:07 PM
// Design Name: 
// Module Name: EX_MEN_stage_reg
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


module EX_MEM_stage_reg(
    input  logic        clk_i,
    input  logic        rst_i,
    
    input  logic [31:0] aluresultE_i,
    input  logic [31:0] writedataE_i,
    input  logic [4:0]  rdE_i, //instr[11:7], parte de la instruccion
    input  logic [31:0] pcplus4E_i,
    
    output logic [31:0] aluresultM_o,
    output logic [31:0] writedataM_o,
    output logic [4:0]  rdM_o, //instr[11:7], parte de la instruccion
    output logic [31:0] pcplus4M_o
   
    );
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
            aluresultM_o    <= '0;      
            writedataM_o    <= '0;
            rdM_o           <= '0;
            pcplus4M_o      <= '0;
            
            end
            
        else begin
            aluresultM_o    <= aluresultE_i;      
            writedataM_o    <= writedataE_i;
            rdM_o           <= rdE_i;
            pcplus4M_o      <= pcplus4E_i;
            end
        
    end
    
    
    
    
    
endmodule
