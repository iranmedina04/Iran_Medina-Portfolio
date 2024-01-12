`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 09:54:04 AM
// Design Name: 
// Module Name: test_hex_to_segsev
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


module test_hex_to_segsev(
    input  logic        clk_pi,
    
    output logic [3:0]  en_po,
    output logic [6:0]  seg_po,
    output logic [15:0] led
   );
   
   
    //Variables del clock
    logic rst;
    logic clk2;
    
    //Variables del registro
    logic [15:0] data_r; //Dato de salida del registro
    
    //Variables del contador
    logic [1:0]  sel;
    
    //Variables del clkdiv
    logic       clkdiv;
    
    //Variable de habilitacion cada dos segundos
    logic       en_two_seg;
    
    //Variable aleatoria
    logic [15:0] rdata;
    
    clk_wiz_0 cwclock
   (
    .clk_out1       (clk2),
    .locked         (rst), 
    .clk_in1        (clk_pi)
    
    );
   
    en_per_seg eps(
        .clk_i      (clk2),
        .rst_i      (rst),
        .seg_i      (), //Nota: modificar este modulo para funcionamiento en fpga 2 para fpga
                         //Para testbench modificar y poner 1.
        
        .en_o       (en_two_seg)
    );
    
    LFSR #(.NUM_BITS(16)) random1 
  (
       .i_clk       (clk2),
       .i_rst       (rst),
       .i_enable    (1),
       .i_seed_data (0),
       .o_lfsr_data (rdata),
       .o_lfsr_done ()
   );
    
  
    register_n_bits #(.N(16)) rnb(
        .clk_i      (clk2), 
        .rst_i      (rst), 
        .we_i       (en_two_seg),
        .data_i     (rdata),
        .data_o     (led)
    );
    
    dec_hex_to_sevseg dhts(
        .clk_pi     (clk2),
        .rst_pi     (rst),
        .data_pi    (led),
        .en_po      (en_po),
        .seg_po     (seg_po)
   );
   
   
    
    
   
endmodule
