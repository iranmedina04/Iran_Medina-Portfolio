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
    input  logic [1:0]  resultsrcW_i,
    input  logic        pcsrcE_i, 
    input  logic        alusrcE_i,
    input  logic        regwriteW_i,
    input  logic [1:0 ] immsrcD_i,
    input  logic [2:0 ] alucontrolE_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] readdata_i,
    
    //Entradas provenientes del control
    
    //Entradas provenientes del hazard unit
    input  logic        stallF_i,
    input  logic        stallD_i,
    input  logic        flushE_i,
    input  logic [1:0]  forwardAE_i,
    input  logic [1:0]  forwardBE_i,
  
    output logic        zeroE_o,
    output logic [31:0] pc_o,

    output logic [31:0] instrD_o,
    output logic [ 4:0] rs1D_o,
    output logic [ 4:0] rs2D_o,
    output logic [ 4:0] rdM_o,
    output logic [ 4:0] rdW_o,
    output logic [ 4:0] rs2E_o,
    output logic [ 4:0] rs1E_o,
    output logic [ 4:0] rdE_o,
    
    //EX_MEM_register_variables
    output logic [31:0] aluresultM_o,
    output logic [31:0] writedataM_o

);
    logic [31:0] pcnext, pcplus4, pctarget;
    logic [31:0] immext;
    logic [31:0] srca, srcb;
    logic [31:0] resultw;
    logic [31:0] srca_e;
    logic [31:0] srcb_e;
    logic [31:0] in_mux_srcb;
    logic [31:0] alu_result_e;
    logic [31:0] pcplus4M;
    logic [31:0] writedata;
    logic [ 4:0] rdD;
    //EX_MEM_register_variables

    
    
    //Fetch stage//////////////////////////////////////
    
    
    mux2 #(.WIDTH(32)) pcmux(
        .d0_i   (pcplus4),
        .d1_i   (pctarget),
        .s_i    (pcsrcE_i),
        .y_o    (pcnext)
    );
    
    flopr #(.WIDTH(32)) pcreg(
        .clk_i      (clk_i), 
        .reset_i    (reset_i),
        .d_i        (pcnext),
        .stallF_i   (stallF_i),
        .q_o        (pc_o)
    );
    
    adder pcadd4(
        .a      (pc_o), 
        .b      (32'd4),
        .y      (pcplus4)
    );
    
    //IF_ID_reg/////////////////////////////////////////
    
    logic [31:0] pcD;
    logic [31:0] pcplus4D;

    
    IF_ID_stage_reg IF_ID_register(
        .clk_i         (clk_i),
        .rst_i         (reset_i),
                       
        .stallD_i      (stallD_i),
        .pcF_i         (pc_o),
        .pcplus4F_i    (pcplus4),
        .rD_i          (instr_i),
                       
        .pcD_o         (pcD),
        .pcplus4D_o    (pcplus4D),
        .instrD_o      (instrD_o)
    
    );
    ////////////////////////////////////////////////////
    
    
    //Decode stage//////////////////////////////////////
    
    module_banco_de_registros #(    
        .N(32),
        .W(32)
        ) br
        (  
        //Entradas
        .addr_rs1       (instrD_o[19:15]),
        .addr_rs2       (instrD_o[24:20]),
        .addr_rd        (rdW_o),
        .clk            (clk_i),
        .we             (regwriteW_i),
        .rst            (reset_i),
        .data_in        (resultw),
        
        //Salidas
        .rs1            (srca),
        .rs2            (writedata)
        );
        
    extend ext(
        .instr_i        (instrD_o[31:7]),
        .immsrc_i       (immsrcD_i),
        .immext_o       (immext)
    );


   
    //ID_EXE_reg/////////////////////////////////////////
    logic [31:0] rd1E;   
    logic [31:0] rd2E;    
    logic [31:0] pcE;          
    logic [31:0] immextE;
    logic [31:0] pcplus4E;
    logic [31:0] aluresultW_o;
    logic [31:0] readdataW;    
    
    
    assign rs1D_o =  instrD_o[19:15] ;
    assign rs2D_o =  instrD_o[24:20] ;
    assign rdD    =  instrD_o[11:7]  ;


    ID_EX_stage_reg ID_EX_register(

        .clk_i          (clk_i),
        .rst_i          (reset_i),
                        
        .rd1_i          (srca),
        .rd2_i          (writedata),
        .pcD_i          (pcD),
        .rs1D_i         (instrD_o[19:15]),
        .rs2D_i         (instrD_o[24:20]),
        .rdD_i          (instrD_o[11:7]),
        .immextD_i      (immext),
        .pcplus4D_i     (pcplus4D),
                        
        .rd1E_o         (rd1E),
        .rd2E_o         (rd2E),
        .pcE_o          (pcE),
        .rs1E_o         (rs1E_o),
        .rs2E_o         (rs2E_o),
        .rdE_o          (rdE_o),
        .immextE_o      (immextE),
        .pcplus4E_o     (pcplus4E)
    );
    /////////////////////////////////////////////////////
    
    //Execution stage////////////////////////////////////
    
    mux3 #(.WIDTH(32)) muxrd1
    (
        .d0_i       (rd1E), 
        .d1_i       (resultw),
        .d2_i       (aluresultM_o),
        .s_i        (forwardAE_i),
              
        .y_o        (srca_e)
    );
    
    mux3 #(.WIDTH(32)) muxrd2
    (
        .d0_i       (rd2E), 
        .d1_i       (resultw),
        .d2_i       (aluresultM_o),
        .s_i        (forwardBE_i),
              
        .y_o        (in_mux_srcb)
    );

    ALU   #(.N(32)) alu_result  (
        .sel_i  (alucontrolE_i), 
        .a_i    (srca_e), 
        .b_i    (srcb_e), 
        .s_o    (alu_result_e), 
        .z_o    (zeroE_o) 
    
    );
    
    adder pcaddbranch(
        .a      (pcE), 
        .b      (immextE),
        .y      (pctarget)
    );
    
    mux2 #(.WIDTH(32)) srcbmux(
        .d0_i   (in_mux_srcb),
        .d1_i   (immextE),
        .s_i    (alusrcE_i),
        .y_o    (srcb_e)
        
    );
    
    
    //EX/MEM register/////////////////////////////////////
    EX_MEM_stage_reg EX_MEM(
        .clk_i          (clk_i),
        .rst_i          (reset_i),
                       
        .aluresultE_i   (alu_result_e),
        .writedataE_i   (in_mux_srcb),
        .rdE_i          (rdE_o),
        .pcplus4E_i     (pcplus4E),
                       
        .aluresultM_o   (aluresultM_o),
        .writedataM_o   (writedataM_o),
        .rdM_o          (rdM_o),
        .pcplus4M_o     (pcplus4M)
   
    );
    //////////////////////////////////////////////////////
    
    
    
    
    
    //Memory write stage//////////////////////////////////
    
    //En esta etapa va la ram pero se encuentra en el top, por lo que solo se declararan las variables 
    
    logic [31:0] pcplus4W;
   
    //MEM/WB registesr////////////////////////////////////
    MEM_WB_stage_reg MEM_WB(
        .clk_i         (clk_i),
        .rst_i         (reset_i),
                         
        .aluresultM_i  (aluresultM_o),
        .readdataM_i   (readdata_i),
        .rdM_i         (rdM_o),
        .pcplus4M_i    (pcplus4M),
                         
        .aluresultW_o  (aluresultW_o),
        .readdataW_o   (readdataW),
        .rdW_o         (rdW_o),
        .pcplus4W_o    (pcplus4W)
    );

    /////////////////////////////////////////////////////
    
  
    //Write back stage///////////////////////////////////
    
    mux3 #(.WIDTH(32)) resultmux(
        .d0_i       (aluresultW_o), 
        .d1_i       (readdataW),
        .d2_i       (pcplus4W),
        .s_i        (resultsrcW_i),
        .y_o        (resultw)
    );
    
    
endmodule
