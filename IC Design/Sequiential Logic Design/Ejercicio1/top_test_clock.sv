`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 11:06:08 PM
// Design Name: 
// Module Name: top_test_clock
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


module top_test_clock(
    input  logic        clk_pi, rst,
    output logic [7:0]  leds1_po,
    output logic [7:0]  leds2_po
    );
    
 
    logic clk2;
    logic [15:0] cont;
    logic        en;
    
  
            
     clk_wiz_0 cwtb
   (
        .clk_out1(clk2),
        .locked(),
        .clk_in1(clk_pi)
    );
    
    test_clock tc2 (
        .clk_i      (clk2),
        .rst_i      (rst),
        .cuenta_o   (leds1_po)
    );
    
    
    test_clock tc1 (
        .clk_i      (clk_pi),
        .rst_i      (rst),
        .cuenta_o   (leds2_po)
    );
    
endmodule
