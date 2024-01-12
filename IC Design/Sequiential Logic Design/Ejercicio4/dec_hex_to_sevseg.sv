`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2023 01:45:15 PM
// Design Name: 
// Module Name: dec_hex_to_sevseg
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


module dec_hex_to_sevseg(
    input  logic        clk_pi,
    input  logic        rst_pi,
    input  logic [15:0] data_pi,
    output logic [3:0]  en_po,
    output logic [6:0]  seg_po
   );
    
    //Variables del contador
    logic [1:0]  sel;
    
    //Variables del clkdiv
    logic       clkdiv;
    
    clock_divider cd (

        .clck_i         (clk_pi),
        .rst_i          (rst_pi),
        .clck_divided_o (clkdiv)

    );
    
    contador_2_bits c2 (
    
        .clck_i     (clkdiv),
        .enable_i   (1),
        .hold_i     (0),
        .rst_i      (rst_pi),
        .state_o    (sel)
    
    );
   
    top_segsev tss(
    
        .s_i        (data_pi),
        .b_i        (sel),
        .s_o        (seg_po) 

    );
    
    en_anode ena(
        .sel_i      (sel),
        .en_o       (en_po)
    );
    
    
    
    
    
endmodule
