`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 08:25:14 PM
// Design Name: 
// Module Name: controller
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


module controller(
    input  logic [6:0] op_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7b5_i,
    input  logic       zero_i,
    
    output logic [1:0] resultsrc_o,
    output logic       memwrite_o,
    output logic       pcsrc_o, 
    output logic       alusrc_o,
    output logic       regwrite_o, 
    output logic       jump_o,
    output logic [1:0] immsrc_o,
    output logic [2:0] alucontrol_o
);

    logic [1:0] aluop;
    logic       branch;
    
    maindec md(
        .op_i           (op_i),
        .resultSrc_o    (resultsrc_o),
        .memwrite_o     (memwrite_o),
        .branch_o       (branch), 
        .alusrc_o       (alusrc_o),
        .regwrite_o     (regwrite_o), 
        .jump_o         (jump_o),
        .immsrc_o       (immsrc_o),
        .aluop_o        (aluop)
    );
    
    aludec ad(
        .opb5_i         (op_i[5]),
        .funct3_i       (funct3_i),
        .funct7b5_i     (funct7b5_i),
        .aluop_i        (aluop),
        .alucontrol_o   (alucontrol_o)  
    );
    
    assign pcsrc_o = branch & zero_i | jump_o;
endmodule