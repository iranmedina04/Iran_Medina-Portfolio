`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 09:10:03 PM
// Design Name: 
// Module Name: datapath
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

module datapath(
    input  logic        clk_i, 
    input  logic        reset_i,
    input  logic [1:0]  resultsrc_i,
    input  logic        pcsrc_i, 
    input  logic        alusrc_i,
    input  logic        regwrite_i,
    input  logic [1:0 ] immsrc_i,
    input  logic [2:0 ] alucontrol_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] readdata_i,
    
    output logic        zero_o,
    output logic [31:0] pc_o,
    output logic [31:0] aluresult_o, 
    output logic [31:0] writedata_o

);
    logic [31:0] pcnext, pcplus4, pctarget;
    logic [31:0] immext;
    logic [31:0] srca, srcb;
    logic [31:0] result;
    
    // next PC logic
    
    flopr #(.WIDTH(32)) pcreg(
        .clk_i      (clk_i), 
        .reset_i    (reset_i),
        .d_i        (pcnext),
        .q_o        (pc_o)
    );
    
    adder pcadd4(
        .a      (pc_o), 
        .b      (32'd4),
        .y      (pcplus4)
    );
    
    adder pcaddbranch(
        .a      (pc_o), 
        .b      (immext),
        .y      (pctarget)
    );
    
    mux2 #(.WIDTH(32)) pcmux(
        .d0_i   (pcplus4),
        .d1_i   (pctarget),
        .s_i    (pcsrc_i),
        .y_o    (pcnext)
    );
    
    // register file logic
//    regfile rf(
//        clk_i, 
//        regwrite_i, 
//        instr_i[19:15], 
//        instr_i[24:20],
//        instr_i[11:7], 
//        result, 
//        srca, 
//        writedata_o
//    );
    
    module_banco_de_registros #(    
        .N(32),
        .W(32)
        ) br
        (  
        //Entradas
        .addr_rs1       (instr_i[19:15]),
        .addr_rs2       (instr_i[24:20]),
        .addr_rd        (instr_i[11:7]),
        .clk            (clk_i),
        .we             (regwrite_i),
        .rst            (!reset_i),
        .data_in        (result),
        
        //Salidas
        .rs1            (srca),
        .rs2            (writedata_o)
        );
    
    extend ext(
        .instr_i        (instr_i[31:7]),
        .immsrc_i       (immsrc_i),
        .immext_o       (immext)
    );
    
    // ALU logic
    mux2 #(.WIDTH(32)) srcbmux(
        .d0_i   (writedata_o),
        .d1_i   (immext),
        .s_i    (alusrc_i),
        .y_o    (srcb)
        
    );
    
    
    ALU   #(.N(32)) alu_result  (
        .sel_i  (alucontrol_i), 
        .a_i    (srca), 
        .b_i    (srcb), 
        .s_o    (aluresult_o), 
        .z_o    (zero_o) 
    
    );
    
    mux3 #(.WIDTH(32)) resultmux(
        .d0_i       (aluresult_o), 
        .d1_i       (readdata_i),
        .d2_i       (pcplus4),
        .s_i        (resultsrc_i),
        .y_o        (result)
    );

endmodule
