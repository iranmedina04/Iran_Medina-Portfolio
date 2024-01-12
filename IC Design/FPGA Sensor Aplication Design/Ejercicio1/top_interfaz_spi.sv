`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2023 12:24:37 AM
// Design Name: 
// Module Name: top_interfaz_spi
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
module top_interfaz_spi(



    // Variables de entrada del tiempo 

    input logic clck_i,
    input logic rst_i,


    //Variables al modulo spi 

    input logic          wr_i ,
    input logic          reg_sel_i,
    input logic [ 4 : 0] addr_in_i,
    input logic [31 : 0] entrada_i,
    input logic          miso_i,

    //Variables de salida del modulo spi

    output logic [31 : 0] salida_o,
    output logic          mosi_o,
    output logic          sclk_o,
    output logic          cs_o


    );

    // Logic para conectar entre modulos

    logic               wr1_ctrl;
    logic   [31 : 0]    in1_ctrl;
    logic               wr1_data;
    logic   [31 : 0]    in1_data;
    logic               wr2_ctrl;
    logic   [31 : 0]    in2_ctrl;
    logic               wr2_data;
    logic   [31 : 0]    in2_data;
    logic   [ 4 : 0]    addr2_data;
    logic               hold_ctrl;
    logic   [31 : 0]    out_ctrl;
    logic   [31 : 0]    out_br;

    top_fsm_spi SPI(

        .clck_i         (clck_i),
        .rst_i          (rst_i),
        .inst_i         (out_ctrl),
        .reg_i          (out_br),
        .miso_i         (miso_i),
        
        .ss_o           (cs_o),
        .mosi_o         (mosi_o),
        .wr1_o          (wr2_ctrl),
        .in1_o          (in2_ctrl),
        .wr2_o          (wr2_data),
        .addr2_o        (addr2_data),
        .hold_ctrl_o    (hold_ctrl),
        .sclk_o         (sclk_o),
        .in2_o          (in2_data)

        
    );
    
    banco_registros_spi registro(
    
        .addr1_i        (addr_in_i),
        .addr2_i        (addr2_data),
        .clk_i          (clck_i),
        .rst_i          (rst_i),
        .hold_ctrl_i    (hold_ctrl),
        .wr1_i          (wr1_data),
        .wr2_i          (wr2_data),
        .data1_i        (entrada_i),
        .data2_i        (in2_data),
        
        .data_o         (out_br)
    );
       
    reg_control control(
        .clk_i          (clck_i),
        .rst_i          (rst_i),
        .wr1_i          (wr1_ctrl),
        .wr2_i          (wr2_ctrl),
        .hold_ctrl_i    (hold_ctrl),
        
        .data1_i        (entrada_i),
        .data2_i        (in2_ctrl),
        
        .out_o          (out_ctrl)

    );

    demux_2_a_1 demux(
        .in_i        (wr_i),    
        .sel_i       (reg_sel_i),
        
        .out2_o      (wr1_data),
        .out1_o      (wr1_ctrl)
    );
    
    mux_2_a_1 mux(
        .a_i      (out_ctrl),  
        .b_i      (out_br),
        .sel_i      (reg_sel_i),
        
        .out_o      (salida_o)
    );

endmodule
