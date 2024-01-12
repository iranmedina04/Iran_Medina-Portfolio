`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2023 09:55:55 AM
// Design Name: 
// Module Name: hazard_unit
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


module hazard(
    input  logic [4:0] Rs1D, 
    input  logic [4:0] Rs2D, 
    input  logic [4:0] Rs1E, 
    input  logic [4:0] Rs2E, 
    input  logic [4:0] RdE, 
    input  logic [4:0] RdM, 
    input  logic [4:0] RdW,
    
    input  logic       PCSrcE, 
    input  logic       ResultSrcEb0,
    input  logic       RegWriteM, 
    input  logic       RegWriteW,
    
    output logic [1:0] ForwardAE, 
    output logic [1:0] ForwardBE,
    output logic       StallF, 
    output logic       StallD, 
    output logic       FlushD, 
    output logic       FlushE
    );
    
    logic lwStallD;
    
    // forwarding logic
    always_comb begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        
        if (Rs1E != 5'b0)
            if ((Rs1E == RdM) & RegWriteM) 
                ForwardAE = 2'b10;
            else if ((Rs1E == RdW) & RegWriteW) 
                ForwardAE = 2'b01;
            if (Rs2E != 5'b0)
            if ((Rs2E == RdM) & RegWriteM) ForwardBE = 2'b10;
        else if ((Rs2E == RdW) & RegWriteW) ForwardBE = 2'b01;
    end
    
    
    // stalls and flushes
    assign lwStallD = ResultSrcEb0 & ((Rs1D == RdE) | (Rs2D == RdE));
    assign StallD = lwStallD;
    assign StallF = lwStallD;
    assign FlushD = PCSrcE;
    assign FlushE = lwStallD | PCSrcE;
endmodule
