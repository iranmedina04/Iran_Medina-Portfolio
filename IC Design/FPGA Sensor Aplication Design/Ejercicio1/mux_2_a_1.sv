`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2023 12:11:43 AM
// Design Name: 
// Module Name: mux_2_a_1
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


module mux_2_a_1(
    input   logic [31:0]  a_i,  
    input   logic [31:0]  b_i,
    input   logic         sel_i,
    
    
    output  logic [31:0]  out_o
    

);

    always_comb begin
        case (sel_i)
            1'b0:    out_o = a_i;
            
            1'b1:    out_o = b_i;
            
            default: out_o = '0;
           
        endcase
    end

endmodule