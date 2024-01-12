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
  
//    logic [1:0] state;
//    logic [1:0] state_next;
    
    typedef enum logic [1:0] {s1, 
                              s2, 
                              s3, 
                              s4
    } state_t;
    
    state_t state, state_next;
    
    
    logic [3:0] cont;
    logic [3:0] conta_inc;
    localparam [3:0] cuenta = 'ha;
    
    always_ff@(posedge clk_i)begin
        if(!rst_i) begin
            state <= s1;
            cont  <= cuenta;
            end
            
        else begin
            state <= state_next;
            cont  <= conta_inc;
            end
    end
   
    always_comb begin
        case (state)
        
            s1: begin
               
                if (bn_i) 
                    begin
                        p_o        = 0;
                        conta_inc  = cuenta;
                        state_next = s2;
                    end 
                else 
                    begin
                        p_o        = 0;
                        conta_inc  = cuenta;
                        state_next = s1;
                    end
               
            end
            
            s2:
                if (bn_i)
                   
                    if (cont == 0)
                        begin
                            p_o        = 1;
                            conta_inc  = cuenta;
                            state_next = s3;
                        end
                    else
                        begin
                            p_o        = 0;
                            conta_inc  = cont - 1;
                            state_next = s2;
                        end
                    
                    
                else 
                    begin
                        p_o        = 0;
                        conta_inc  = cuenta;
                        state_next = s1;
                    end
                    
        
            s3:
                if (bn_i)
                    begin
                        p_o        = 1;
                        conta_inc  = cuenta;
                        state_next = s3;
                    end 
                else
                    begin
                        p_o        = 1;
                        conta_inc  = cuenta;
                        state_next = s4;
                    end
            s4:
                if (bn_i == 0)
                    if (cont == 0)
                        begin
                            p_o        = 0;
                            conta_inc  = cuenta;
                            state_next = s1;
                        end
                    else
                        begin
                            p_o        = 1;
                            conta_inc  = cont - 1;
                            state_next = s4;
                        end
                    
                else
                    begin
                        p_o        = 1;
                        conta_inc  = cuenta;
                        state_next = s3;
                    end
                    
            default:
                begin
                    p_o        = 0;
                    conta_inc  = cuenta;
                    state_next = s1;
                end 
               
        endcase
    end
    
    
  
        
  
    
                
endmodule
