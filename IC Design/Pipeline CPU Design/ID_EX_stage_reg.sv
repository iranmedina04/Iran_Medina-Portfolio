`timescale 1ns / 1ps

module ID_EX_stage_reg(

    input  logic         clk_i,
    input  logic         rst_i,
    
    input   logic [31:0] rd1_i,
    input   logic [31:0] rd2_i,
    input   logic [31:0] pcD_i,
    input   logic [4:0]  rs1D_i,
    input   logic [4:0]  rs2D_i,
    input   logic [4:0]  rdD_i,
    input   logic [31:0] immextD_i,
    input   logic [31:0] pcplus4D_i,
    
    output  logic [31:0] rd1E_o,
    output  logic [31:0] rd2E_o,
    output  logic [31:0] pcE_o,
    output  logic [4:0]  rs1E_o,
    output  logic [4:0]  rs2E_o,
    output  logic [4:0]  rdE_o,
    output  logic [31:0] immextE_o,
    output  logic [31:0] pcplus4E_o
    );
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
        
            rd1E_o     <= '0;
            rd2E_o     <= '0;
            pcE_o      <= '0;
            rs1E_o     <= '0;
            rs2E_o     <= '0;
            rdE_o      <= '0;
            immextE_o  <= '0;
            pcplus4E_o <= '0;
            
            end
            
        else begin
        
            rd1E_o     <= rd1_i;
            rd2E_o     <= rd2_i;
            pcE_o      <= pcD_i;
            rs1E_o     <= rs1D_i;
            rs2E_o     <= rs2D_i;
            rdE_o      <= rdD_i;
            immextE_o  <= immextD_i;
            pcplus4E_o <= pcplus4D_i;
            
            end
        
    end
endmodule
