`timescale 1ns / 1ps


module ID_EX_stage_control(

    input   logic       clk_i,
    input   logic       rst_i,
    
    input   logic       regwriteD_i,
    input   logic [1:0] resultsrcD_i,
    input   logic       memwriteD_i,
    input   logic       jumpD_i,
    input   logic       branchD_i,
    input   logic [2:0] alucontrolD_i,
    input   logic       alusrcD_i,
    
    output  logic       regwriteE_o,
    output  logic [1:0] resultsrcE_o,
    output  logic       memwriteE_o,
    output  logic       jumpE_o,
    output  logic       branchE_o,
    output  logic [2:0] alucontrolE_o,
    output  logic       alusrcE_o
    
    );
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
        
            regwriteE_o    <= '0;
            resultsrcE_o   <= '0;
            memwriteE_o    <= '0;
            jumpE_o        <= '0;
            branchE_o      <= '0;
            alucontrolE_o  <= '0;
            alusrcE_o      <= '0;

            end
            
        else begin
            regwriteE_o    <=  regwriteD_i;
            resultsrcE_o   <=  resultsrcD_i;
            memwriteE_o    <=  memwriteD_i;
            jumpE_o        <=  jumpD_i;
            branchE_o      <=  branchD_i;
            alucontrolE_o  <=  alucontrolD_i;
            alusrcE_o      <=  alusrcD_i;
            
            end
        
    end

endmodule
