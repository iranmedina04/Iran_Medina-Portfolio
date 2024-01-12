`timescale 1ns / 1ps

module top_banco_de_registros(
    //Entradas al módulo
    input logic [3:0] data_in,
    input logic [4:0] addr_rd,
    input logic [4:0] addr_rs1,
    input logic [4:0] addr_rs2,
    input logic we,
    input logic clk,
    
    //Salidas del módulo
    output logic [3:0] rs1,
    output logic [3:0] rs2
    );
    
    //Parámetros
    localparam N = 8;
    localparam W = 4;
    
    logic clk2;
    logic rst;
    
    clk_wiz_0 cwclock
   (
    .clk_out1(clk2),
    .locked(rst),
    .clk_in1(clk));
    
    module_banco_de_registros #(.N(N),.W(W)) register_file(
    .addr_rs1  (addr_rs1),
    .addr_rs2  (addr_rs2),
    .addr_rd   (addr_rd),
    .we        (we),
    .data_in   (data_in),
    .clk       (clk2),
    .rs1       (rs1),
    .rs2       (rs2),
    .rst       (rst)
    );
endmodule
