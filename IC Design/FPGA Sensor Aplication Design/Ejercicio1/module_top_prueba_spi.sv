`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 01:37:11 PM
// Design Name: 
// Module Name: module_top_prueba_spi
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


module module_top_prueba_spi(
    input logic             miso_i,
    input logic             wr_i,
    input logic             clck_i,
    input logic             reg_sel_i,
    input logic   [2 : 0]   seleccion_generador,
    input logic   [ 4 : 0]  addr_in_i,
    
    output logic [ 3 : 0]   en_o,
    output logic [ 6 : 0]   seg_o,
    //output logic            mosi_o,
    output logic            sclk_o,
    output logic            cs_o
    
    );
    
    logic  mosi_o;
    //-----------------------------------------------------
    logic  [31 : 0]   salida_i;
    logic            wr_o;
    logic            reg_sel_o;
    logic [31 : 0]   entrada_o;
    logic [ 4 : 0]   addr_in_o;


    logic locked;
    logic clk2;
    clock clock
   (
    
        .clk_o      (clk2),
        .locked     (locked), 
        .clk_in     (clck_i)
    
    );      // input clk_in
    
    
    top_interfaz_spi top_spi(
        .clck_i         (clk2),
        .rst_i          (~locked),


        .wr_i           (wr_o) ,
        .reg_sel_i      (reg_sel_o),
        .addr_in_i      (addr_in_o),
        .entrada_i      (entrada_o),
        .miso_i         (miso_i),


        .salida_o       (salida_i),
        .mosi_o         (mosi_o),
        .sclk_o         (sclk_o),
        .cs_o           (cs_o)

    );
    
    generador_y_control_datos (
    
        .wr_i               (wr_i),
        .clck_i             (clk2),
        .rst_clck_i         (locked),
        .reg_sel_i          (reg_sel_i),
        .seleccion_generador(seleccion_generador),
        .addr_in_i          (addr_in_i),
        .salida_i           (salida_i),
    
        .wr_o               (wr_o),
        .reg_sel_o          (reg_sel_o),
        .entrada_o          (entrada_o),
        .addr_in_o          (addr_in_o),
        .en_o               (en_o),
        .seg_o              (seg_o)
    );
    
endmodule
