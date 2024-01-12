`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 10:42:01 PM
// Design Name: 
// Module Name: ALU
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

module ALU
    #(parameter N = 4)
    (
    input logic  [2:0]   sel_i,
    input logic  [N-1:0] a_i, b_i,
    
    output logic [N-1:0] s_o,
    output logic         z_o
    );
        
    always_comb begin
        case (sel_i)
        
            3'b000://ADD
                begin
                    s_o = a_i + b_i;
                    z_o = 0;
                end
            3'b001://subtract
                begin
                    s_o = a_i - b_i;
                    
                    if(s_o == 0)
                        z_o = 1;
                    else
                        z_o = 0;
                end 
                
            3'b010://AND
                begin
                    s_o = a_i & b_i;
                    z_o = 0;
                end 
            3'b011://OR
                begin
                    s_o = a_i | b_i;
                    z_o = 0;
                end
            3'b101:
                begin 
                    z_o = 0;
                    if(a_i < b_i)
                        s_o = 1;
                        
                    else 
                        s_o = 0;
                end
                
            3'b110: //shift left
                begin 
                    z_o = 0;
                    s_o = a_i << b_i;
                end 
                
            3'b111: //shift right 
                begin
                    z_o = 0;
                    s_o = a_i >> b_i;
                end
                
            default:
                begin
                    s_o = 0;
                    z_o = 0;
                end
        endcase
    end
    
endmodule