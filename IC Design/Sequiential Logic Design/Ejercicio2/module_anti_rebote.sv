`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 12:23:23 PM
// Design Name: 
// Module Name: anti_rebote
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


module anti_rebote(
        input logic clk_i, 
        input logic rst_i, 
        input logic bn_i,
        
        output logic p_o
    );
    logic [3:0] cont;
    logic [3:0] conta_inc;
    logic [1:0] state;
    logic [1:0] state_next;
    
    localparam  s1 = 0, 
                s2 = 1, 
                s3 = 2, 
                s4 = 3;
                
    always_ff@(posedge clk_i, posedge rst_i)begin
        if(!rst_i)
            state <= s1;
        else
            state <= state_next;
    end
    
    always_ff@(posedge clk_i, posedge rst_i)begin
        if(!rst_i)
            cont  <= 0;
        else
            cont <= conta_inc;
    end
    
    always_comb begin
        case (state)
            s1:
                if (bn_i) 
                    begin
                        p_o        = 0;
                        conta_inc  = 0;
                        state_next = s2;
                    end 
                else 
                    begin
                        p_o        = 0;
                        conta_inc  = 0;
                        state_next = s1;
                    end

            s2:
                if (bn_i)
                   
                    if (cont == 10)
                        begin
                            p_o        = 1;
                            conta_inc  = 0;
                            state_next = s3;
                        end
                    else
                        begin
                            p_o        = 0;
                            conta_inc  = cont + 1;
                            state_next = s2;
                        end
                    
                    
                else 
                    begin
                        p_o        = 0;
                        conta_inc  = 0;
                        state_next = s1;
                    end
                    
        
            s3:
                if (bn_i)
                    begin
                        p_o        = 1;
                        conta_inc  = 0;
                        state_next = s3;
                    end 
                else
                    begin
                        p_o        = 1;
                        conta_inc  = 0;
                        state_next = s4;
                    end
            s4:
                if (bn_i == 0)
                
                    if (cont == 4'ha)
                        begin
                            p_o        = 0;
                            conta_inc  = 0;
                            state_next = s1;
                        end
                    else
                        begin
                            p_o        = 1;
                            conta_inc  = cont + 1;
                            state_next = s4;
                        end
                    
                else if (bn_i)
                    begin
                        p_o        = 1;
                        conta_inc  = 0;
                        state_next = s3;
                    end
                    
                
                    
            
        endcase
    end
    
    
  
        
  
    
                
endmodule
