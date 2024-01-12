`timescale 1ns / 1ps

module top_mini_calculo(
    //input logic       led_tecla_i,
    input logic       clk_pi,
    input logic       switch_pi,
    //input logic [3:0] teclado,
    input logic [3:0] filas_i,
    input logic [1:0] filas_codificadas_i,
    
    output logic [1:0] salidas_contador_o,
    output logic       led_error_po,
    output logic       led_op_po,
    
    output logic [3:0] en_po,
    output logic [6:0] seg_po,
    output logic       led_o
    );

logic clk2;
logic reset;

clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk2),     // output clk_out1
    // Status and control signals
    .locked(reset),       // output locked
   // Clock in ports
    .clk_in1(clk_pi));      // input clk_in1

//logic       led_tecla_i;
logic       we; 
logic [3:0] op_alu;
logic [3:0] operando1;
logic [3:0] operando2;
logic       mux_sel;
logic [3:0] mux_out;
logic [3:0] Y;
logic [4:0] addr_rd;
logic [4:0] addr_rs1;
logic [4:0] addr_rs2;
logic       we_reg;
logic [3:0] teclado;

module_control crtl( 
    .led_tecla_i      (led_o),
    .switch           (switch_pi),
    .teclado          (teclado),
    .clk              (clk2),
    .rst              (reset),
    .led_operacion    (led_op_po),
    .led_error        (led_error_po),
    .WE               (we),
    .we_banco         (we_reg),
    .OP               (op_alu),
    .addr_rs1         (addr_rs1),
    .addr_rs2         (addr_rs2),
    .addr_rd          (addr_rd),
    .mux_sel          (mux_sel)
);

module_datapath md(

    .teclado_i      (teclado),
    
    .clk            (clk2),
    .reset          (reset),
    .mux_sel        (mux_sel),
    .WE             (we),
    .addr_rs1       (addr_rs1),
    .addr_rs2       (addr_rs2),
    .addr_rd        (addr_rd),
    .we_banco       (we_reg),
    .op_alu         (op_alu),
    
    .seg_o          (seg_po),
    .en_o           (en_po)
    );

top_interfaz(

    .clck_i                  (clk2),
    .locked                  (reset),
    .filas_i                 (filas_i),
    .filas_codificadas_i     (filas_codificadas_i),  
    .salidas_contador_o      (salidas_contador_o),
    .numero_o                (teclado),
    .led_o                   (led_o)
);



endmodule