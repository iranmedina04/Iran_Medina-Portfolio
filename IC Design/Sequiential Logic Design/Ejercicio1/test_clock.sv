`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2023 02:11:18 PM
// Design Name: 
// Module Name: test_clock
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

module test_clock(
    
    input logic         clk_i,
    input logic         rst_i,
    output logic [7:0]  cuenta_o
    );
    
    logic [31:0] cont;
    localparam ciclos = 1000000;
    
    always_ff@(posedge clk_i)
        if (rst_i)
            begin
                cont     <= 0;
                cuenta_o <= 0;
            end
            
        else 
            if (cont < ciclos)
                cont <= cont + 1;
                
        else 
            if (cont == ciclos)
                begin
                    cuenta_o <= cuenta_o + 1;
                    cont     <= 0;
                end
     
                
    
    
endmodule
