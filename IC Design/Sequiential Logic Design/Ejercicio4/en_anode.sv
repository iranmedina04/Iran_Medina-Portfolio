`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2023 02:28:48 PM
// Design Name: 
// Module Name: en_anode
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


module en_anode(
    input  logic [1:0] sel_i,
    output logic [3:0] en_o
    );
    
    always_comb begin
        case (sel_i)
            2'b00:
                en_o = 4'b1110;
                
            2'b01:  
                en_o = 4'b1101;
            
            2'b10:
                en_o = 4'b1011;
                
            2'b11:
                en_o = 4'b0111;
            
//            default:
//                en_o = 4'b0000;
        endcase
    end
    
endmodule
