`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2023 08:04:32 PM
// Design Name: 
// Module Name: top_segsev
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


module top_segsev(
    input logic  [15:0] s_i,
    input logic  [1:0]  b_i,
    output logic [6:0]  s_o,
    output logic [7:0]  en 
    );

    localparam       N     = 4;
    logic      [3:0] rmux;                   //Salida del multiplexor
     
    module_mux_4_1 #(.BUS_WIDTH(N)) mux (    
        .a_i        (s_i[3:0]),    
        .b_i        (s_i[7:4]),
        .c_i        (s_i[11:8]),
        .d_i        (s_i[15:12]),
        .sel_i      (b_i),
        .out_o      (rmux)
    );
    
    module_sevseg segsev(
        .d_i        (rmux),
        .s_o        (s_o),
        .en         (en)
    );
    
endmodule
