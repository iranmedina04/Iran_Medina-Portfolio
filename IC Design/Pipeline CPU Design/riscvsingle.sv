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
    input  logic        rst_i,
    
    output logic [31:0] writedataM_o,
    output logic [31:0] aluresultM_o,
    output logic        memwriteM_o
    
);
    
    logic        clk2;
    logic        locked;
    logic        alusrcE;
    logic        regwriteW;
   
    logic        jump; 
    logic        zeroE;
    logic        pcsrcE;
    
    logic [1:0]  immsrcD;
    logic [2:0]  alucontrolE;
    logic [31:0] instrD;
    logic [1:0]  resultsrcW;
   
    logic [1:0]  resultsrcE;
    logic        regwriteM;
    logic [31:0] instr;
    logic [31:0] readdata;
    logic        stallF;
    logic        stallD;
    logic [31:0] pc;
    logic        flushE;
    logic [1:0]  forwardAE;
    logic [1:0]  forwardBE;
    logic [4:0]  rs1D;
    logic [4:0]  rs2D;
    logic [4:0]  rdE;
    logic [4:0]  rs2E;
    logic [4:0]  rs1E;
    logic [4:0]  rdW;
    logic [4:0]  rdM;
    
    controller c(
        .clk_i          (clk2),
        .rst_i          (locked),
        .op_i           (instrD[6:0]  ),
        .funct3_i       (instrD[14:12]),
        .funct7b5_i     (instrD[30]   ),
        .zeroE_i        (zeroE),
        
        .resultsrcE_o   (resultsrcE),
        .resultsrcW_o   (resultsrcW),
        .memwriteM_o    (memwriteM_o),
        .pcsrcE_o       (pcsrcE),
        .alusrcE_o      (alusrcE),
        .regwriteW_o    (regwriteW),
        .regwriteM_o    (regwriteM),
        .immsrcD_o      (immsrcD),
        .alucontrolE_o  (alucontrolE)
    );

    datapath dp(
        .clk_i          (clk2), 
        .reset_i        (locked),
        .resultsrcW_i   (resultsrcW),
        .pcsrcE_i       (pcsrcE), 
        .alusrcE_i      (alusrcE),
        .regwriteW_i    (regwriteW),
        .immsrcD_i      (immsrcD),
        .alucontrolE_i  (alucontrolE),
        .instr_i        (instr),
        .readdata_i     (readdata),
        .stallF_i       (stallF),
        .stallD_i       (stallD),
        .flushE_i       (flushE),
        .forwardAE_i    (forwardAE),
        .forwardBE_i    (forwardBE),
        
        .zeroE_o         (zeroE),
        .pc_o           (pc),
        .instrD_o       (instrD),
        .rs1D_o         (rs1D),
        .rs2D_o         (rs2D),
        .rdM_o          (rdM),
        .rdW_o          (rdW),
        .rs2E_o         (rs2E),
        .rs1E_o         (rs1E),
        .rdE_o          (rdE),
        
        .aluresultM_o    (aluresultM_o), 
        .writedataM_o    (writedataM_o)
    );
    
    hazard hazard(
        .Rs1D            (rs1D),
        .Rs2D            (rs2D),
        .Rs1E            (rs1E),
        .Rs2E            (rs2E),
        .RdE             (rdE),
        .RdM             (rdM),
        .RdW             (rdW),
                         
        .PCSrcE          (pcsrcE),
        .ResultSrcEb0    (resultsrcE[0]),
        .RegWriteM       (regwriteM),
        .RegWriteW       (regwriteW),
                         
        .ForwardAE       (forwardAE),
        .ForwardBE       (forwardBE),
        .StallF          (stallF),
        .StallD          (stallD),
        .FlushD          (),
        .FlushE          ()
    );
 
 
    
    RAM ram (
        .a      (aluresultM_o),    // input wire [7 : 0] a
        .d      (writedataM_o),  // input wire [31 : 0] d
        .clk    (clk2),         // input wire clk
        .we     (memwriteM_o),    // input wire we
        .spo    (readdata)      // output wire [31 : 0] spo
    );
    
    ROM rom (
        .a      (pc[10:2]),      // input wire [8 : 0] a
        .spo    (instr)          // output wire [31 : 0] spo
    );
    
    clock reloj
   (
        .clk_o      (clk2),   
        .reset      (rst_i), 
        .locked     (locked),
        .clk_i      (clk_i)
    );

    
endmodule
