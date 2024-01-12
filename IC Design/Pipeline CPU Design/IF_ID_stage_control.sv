`timescale 1ns / 1ps

module IF_ID_stage_control(

    input  logic        clk_i,
    input  logic        rst_i,
    
    input  logic [31:0] rD_i,
    
    output logic [31:0] instrD_o
  
    );
    
    
    always_ff @(posedge clk_i, negedge rst_i) begin
        if (!rst_i)begin
        
            instrD_o    <= '0;
            
            end
            
        else begin
        
            instrD_o    <= rD_i;
            
            end
        
    end

endmodule
