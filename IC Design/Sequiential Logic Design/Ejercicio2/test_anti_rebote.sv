`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2023 12:54:14 AM
// Design Name: 
// Module Name: test_anti_rebote
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


module test_anti_rebote(
    input logic         bn_i, 
    input logic         clk_i,
    
    output logic [15:0] led_o,
    output logic [6:0]  seg_o,
    output logic [3:0]  en_o
    
    );
    
    logic        clk2;
    logic        rst;
    logic        p;
    
     clk_wiz_0 cwtb
   (
        .clk_out1   (clk2),
        .locked     (rst),
        .clk_in1    (clk_i)
    );
    
    top_antirebotes tar (
    
        .clck_i     (clk2),
        .btn_i      (bn_i),
        .rst_i      (rst),

        .btn_signal_o(p)
    );
    
    contador_prueba c1(
        .clk        (clk2), 
        .rst_n_i    (rst), 
        .en_i       (bn_i), 
        .conta_o    (led_o[7:0])
    );
    
    contador_prueba c2(
        .clk        (clk2), 
        .rst_n_i    (rst), 
        .en_i       (p), 
        .conta_o    (led_o[15:8])
    );
    
    
    dec_hex_to_sevseg dhts(
        .clk_pi     (clk2),
        .rst_pi     (rst),
        .data_pi    (led_o),
        .en_po      (en_o),
        .seg_po     (seg_o)
   );
    
   
    
endmodule
