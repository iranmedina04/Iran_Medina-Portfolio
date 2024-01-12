`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 07:59:39 PM
// Design Name: 
// Module Name: riscvsingle
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


module riscvsingle(
    input  logic        clk_i, 
    input  logic        reset_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] readdata_i,
    
    output logic [31:0] pc_o,
    output logic        memwrite_o,
    output logic [31:0] aluresult_o, 
    output logic [31:0] writedata_o
);
logic       alusrc;
logic       regwrite;
logic       jump; 
logic       zero;
logic       pcsrc;
logic [1:0] resultsrc;
logic [1:0] immsrc;
logic [2:0] alucontrol;

controller c(
    instr_i[6:0], 
    instr_i[14:12], 
    instr_i[30], 
    zero,
    resultsrc, 
    memwrite_o, 
    pcsrc,
    alusrc, 
    regwrite, 
    jump,
    immsrc, 
    alucontrol
);

datapath dp(
    .clk_i          (clk_i), 
    .reset_i        (reset_i),
    .resultsrc_i    (resultsrc),
    .pcsrc_i        (pcsrc), 
    .alusrc_i       (alusrc),
    .regwrite_i     (regwrite),
    .immsrc_i       (immsrc),
    .alucontrol_i   (alucontrol),
    .instr_i        (instr_i),
    .readdata_i     (readdata_i),
    .zero_o         (zero),
    .pc_o           (pc_o),
    .aluresult_o    (aluresult_o ), 
    .writedata_o    (writedata_o)
);
endmodule
