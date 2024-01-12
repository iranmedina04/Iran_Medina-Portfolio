`timescale 1ns / 1ps

module module_datapath(

    input logic [3:0] teclado_i,
    
    input logic       clk,
    input logic       reset,
    input logic       mux_sel,
    input logic [4:0] addr_rs1,
    input logic [4:0] addr_rs2,
    input logic [4:0] addr_rd,
    input logic       we_banco,
    input logic       WE,
    input logic [3:0] op_alu,
    
    output logic [6:0] seg_o,
    output logic [3:0] en_o
    );

logic [15:0] operando1;
logic [15:0] operando2;
logic [15:0] mux_out;
logic [15:0] Y;

    
module_mux_2_1 #(.BUS_WIDTH(16)) mux(
    .a_i        ({12'd0,teclado_i}),
    .b_i        (Y),
    .sel_i      (mux_sel),
    .out_o      (mux_out)

);

module_ALU alu(
    .ALUA       (operando1),
    .ALUB       (operando2),
    .ALUControl (op_alu),
    .ALUResult  (Y)


);

module_banco_de_registros banco(
    .addr_rs1        (addr_rs1),
    .addr_rs2        (addr_rs2),
    .addr_rd         (addr_rd),
    .clk            (clk),
    .rst            (reset),
    .data_in       (mux_out),
    .we            (we_banco),
    .rs1           (operando1),
    .rs2           (operando2)
);
    
s_register(
    .clk_i      (clk),
    .reset_i    (reset),
    .we_i       (WE),
    .data_i     (operando2),
    
    .seg_o      (seg_o),
    .en_o       (en_o)
    );
 
endmodule
