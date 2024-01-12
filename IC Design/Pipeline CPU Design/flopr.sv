`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 10:27:30 PM
// Design Name: 
// Module Name: flopr
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

module flopr #(
parameter WIDTH = 8
)
(
    input  logic             clk_i, 
    input  logic             reset_i,
    input  logic             stallF_i,
    input  logic [WIDTH-1:0] d_i,
    
    output logic [WIDTH-1:0] q_o
);
always_ff @(posedge clk_i)begin

    if (!reset_i)begin
        q_o <= 0;
        end
    else begin
    
        if (stallF_i == 0)begin
            q_o <= d_i;
            end
            
        else begin
            q_o <= q_o;
            end
            
        end

end 

endmodule