`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2023 05:32:40 PM
// Design Name: 
// Module Name: MEM_WB_stage_reg
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


module MEM_WB_stage_reg(
    input  logic        clk_i,
    input  logic        rst_i,
    
    input  logic [31:0] aluresultM_i,
    input  logic [31:0] readdataM_i,
    input  logic [4:0]  rdM_i, //instr[11:7], parte de la instruccion
    input  logic [31:0] pcplus4M_i,
   
    output logic [31:0] aluresultW_o,
    output logic [31:0] readdataW_o,
    output logic [4:0]  rdW_o, //instr[11:7], parte de la instruccion
    output logic [31:0] pcplus4W_o
    );
    
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
            aluresultW_o    <= '0;      
            readdataW_o     <= '0;
            rdW_o           <= '0;
            pcplus4W_o      <= '0;
    
            end
            
        else begin
            aluresultW_o    <= aluresultM_i;      
            readdataW_o     <= readdataM_i ;
            rdW_o           <= rdM_i      ;
            pcplus4W_o      <= pcplus4M_i  ;
            end
            
        
    end
endmodule
