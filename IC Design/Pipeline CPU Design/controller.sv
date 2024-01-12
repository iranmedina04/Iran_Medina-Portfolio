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
    input  logic       clk_i,
    input  logic       rst_i,
    input  logic [6:0] op_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7b5_i,
    input  logic       zeroE_i,
    
    output logic [1:0] resultsrcE_o,
    output logic [1:0] resultsrcW_o,
    output logic       memwriteM_o,
    
    
    output logic       pcsrcE_o, 
    output logic       alusrcE_o,
    
    output logic       regwriteW_o, 
    output logic       regwriteM_o,
   
    output logic [1:0] immsrcD_o,
    output logic [2:0] alucontrolE_o
);

    logic [1:0] aluop;
    
    //Decode stage variables
    logic       regwriteD;
    logic [1:0] resultsrcD;
    logic       memwriteD;
    logic       jumpD;
    logic       branchD;  
    logic [2:0] alucontrolD;
    logic       alusrcD;  
    
    //Execution stage variables
    logic       regwriteE;
    logic       memwriteE;
    logic       jumpE;
    logic       branchE; 
    
    //MEM stage variables
  
    logic [1:0] resultsrcM;
  
    
    //Write back variables
    //Ambas son salidas.
   
    maindec md(
        .op_i           (op_i),
        .resultSrc_o    (resultsrcD),
        .memwrite_o     (memwriteD),
        .branch_o       (branchD),
        .alusrc_o       (alusrcD),
        .regwrite_o     (regwriteD), 
        .jump_o         (jumpD),
        .immsrc_o       (immsrcD_o),
        .aluop_o        (aluop)
    );
    
    aludec ad(
        .opb5_i         (op_i[5]),
        .funct3_i       (funct3_i),
        .funct7b5_i     (funct7b5_i),
        .aluop_i        (aluop),
        .alucontrol_o   (alucontrolD)  
    );
    
    assign pcsrcE_o = branchE & zeroE_i | jumpE;
    
    ID_EX_stage_control ID_EX_control(

        .clk_i              (clk_i),
        .rst_i              (rst_i),
                            
        .regwriteD_i        (regwriteD),
        .resultsrcD_i       (resultsrcD),
        .memwriteD_i        (memwriteD),
        .jumpD_i            (jumpD),
        .branchD_i          (branchD),
        .alucontrolD_i      (alucontrolD),
        .alusrcD_i          (alusrcD),
                            
        .regwriteE_o        (regwriteE),
        .resultsrcE_o       (resultsrcE_o),
        .memwriteE_o        (memwriteE),
        .jumpE_o            (jumpE),
        .branchE_o          (branchE),
        .alucontrolE_o      (alucontrolE_o),
        .alusrcE_o          (alusrcE_o)
    
    );
    
    EX_MEM_stage_control EX_MEM_control(
        .clk_i          (clk_i),
        .rst_i          (rst_i),
                        
        .regwriteE_i    (regwriteE),
        .resultsrcE_i   (resultsrcE_o),
        .memwriteE_i    (memwriteE),
                        
        .regwriteM_o    (regwriteM_o),
        .resultsrcM_o   (resultsrcM),
        .memwriteM_o    (memwriteM_o)
    );
    
    MEM_WB_stage_control MEM_WB_control(
        .clk_i          (clk_i),
        .rst_i          (rst_i),
                        
        .regwriteM_i    (regwriteM_o),
        .resultsrcM_i   (resultsrcM),
                        
        .regwriteW_o    (regwriteW_o),
        .resultsrcW_o   (resultsrcW_o)
  
    );
endmodule