`timescale 1ns / 1ps

module IF_ID_stage_reg(
    input  logic        clk_i,
    input  logic        rst_i,
    
    input  logic        stallD_i,
    input  logic [31:0] pcF_i,
    input  logic [31:0] pcplus4F_i,
    input  logic [31:0] rD_i,
   
    output logic [31:0] pcD_o,
    output logic [31:0] pcplus4D_o,
    output logic [31:0] instrD_o
    
    );
    
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
        
            pcD_o          <= '0;      
            pcplus4D_o     <= '0;
            instrD_o       <= '0;
            end
            
        else if (stallD_i == 0) begin 
            pcD_o          <= pcF_i;      
            pcplus4D_o     <= pcplus4F_i ;
            instrD_o       <= rD_i;
            end
            
        else begin 
            pcD_o          <= pcD_o;      
            pcplus4D_o     <= pcplus4D_o ;
            instrD_o       <= instrD_o;
            end
             
    end
    
endmodule
