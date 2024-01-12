`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2023 11:38:25 PM
// Design Name: 
// Module Name: 7s_register
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


module s_register(
    input logic        clk_i,
    input logic        reset_i,
    input logic        we_i,
    input logic [15:0] data_i,
    
    output logic [6:0] seg_o,
    output logic [3:0] en_o
    );
    
    logic [15:0] data_o;
    
    register_n_bits rnb (
        .clk_i      (clk_i), 
        .rst_i      (reset_i), 
        .we_i       (we_i),
        .data_i     (data_i),
        .data_o     (data_o)
    );
    
    dec_hex_to_sevseg dhts(
    .clk_pi     (clk_i),
    .rst_pi     (reset_i),
    .data_pi    (data_o),
    .en_po      (en_o),
    .seg_po     (seg_o)
    
    
   );
endmodule
