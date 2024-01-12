`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2023 09:48:30 AM
// Design Name: 
// Module Name: module_SBL
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


module module_SBL(
    input  logic [3:0] s_i,
    input  logic       en_i,
    output logic [3:0] led_o
    );
    
    assign led_o[0] = s_i[0] && (! en_i);
    assign led_o[1] = s_i[1] && (! en_i);
    assign led_o[2] = s_i[2] && (! en_i);
    assign led_o[3] = s_i[3] && (! en_i);
    
    
endmodule
