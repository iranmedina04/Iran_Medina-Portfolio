`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2023 10:11:49 AM
// Design Name: 
// Module Name: module_top
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


module module_top(
    input  logic [15:0] s_pi,
    input  logic [3:0]  en_pi,
    output logic [15:0] leds_po
    );
    
    module_SBL led_a 
    (
        .s_i( s_pi[3:0] ), 
        .en_i( en_pi[0] ), 
        .led_o( leds_po[3:0] )
    );
   
    module_SBL led_b 
    (
        .s_i( s_pi[7:4] ), 
        .en_i( en_pi[1] ), 
        .led_o( leds_po[7:4] )
    );
    
    module_SBL led_c 
    (
        .s_i( s_pi[11:8] ), 
        .en_i( en_pi[2] ), 
        .led_o( leds_po[11:8] )
    );
    
    module_SBL led_d 
    (
        .s_i( s_pi[15:12] ), 
        .en_i( en_pi[3] ), 
        .led_o( leds_po[15:12] )
    );
    
endmodule
