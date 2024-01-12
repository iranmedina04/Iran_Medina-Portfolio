`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2023 07:31:22
// Design Name: 
// Module Name: module_ALU
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


module module_ALU
     #( parameter N=4
     )
     ( input  logic  [N-1:0] ALUA,
       input  logic  [N-1:0] ALUB,
       input  logic          ALUFlagIn,
       input  logic  [3:0]   ALUControl,
       output logic  [N-1:0] ALUResult,
       output logic          ALUFlags,
       output logic          Cero
      );
      localparam op_and           = 'h0,
                 op_or            = 'h1,
                 op_suma          = 'h2,
                 op_incrementar   = 'h3,
                 op_decrementar   = 'h4,
                 op_not           = 'h5,
                 op_resta         = 'h6,
                 op_xor           = 'h7,
                 op_corrimiento_i = 'h8,
                 op_corrimiento_d = 'h9;
                 
      logic [N-1:0] vector_unos  = '1;
      logic [N-1:0] vector_ceros = '0;
      
      always_comb begin
        case(ALUControl)
            op_and           : begin                                   // Operación lógica AND
                                   Cero = 0;
                                   ALUResult = ALUA & ALUB;
                                   if (ALUResult == vector_ceros) begin
                                       Cero = 1;
                                   end 
                               end
            op_or            : begin                                   // Operación lógica OR
                                   Cero = 0;
                                   ALUResult = ALUA | ALUB;
                                   if (ALUResult == vector_ceros) begin
                                       Cero = 1;
                                   end 
                               end
            op_suma          : begin                                   // Operación aritmética SUMA                   
                                   Cero = 0;
                                   ALUResult = ALUA + ALUB + ALUFlagIn;
                                   if (ALUResult == vector_ceros) begin
                                       Cero = 1;
                                   end 
                               end
            op_incrementar   : begin                                   // Operación aritmética DE INCREMENTAR EN 1
                                   if (ALUFlagIn=='0)                         
                                       begin 
                                           ALUResult = ALUA+1;
                                       end
                                   else
                                       begin
                                           ALUResult = ALUB+1;
                                       end
                                end                
            op_decrementar   : begin                                   // Operación aritmética DECREMENTAR EN 1
                                   if (ALUFlagIn=='0)                       
                                       begin
                                           Cero = 0; 
                                           ALUResult = ALUA-1;
                                           if (ALUResult == vector_ceros) begin
                                               Cero = 1;
                                           end 
                                    end
                                   else
                                       begin
                                           Cero = 0;
                                           ALUResult = ALUB-1;
                                           if (ALUResult == vector_ceros) begin
                                               Cero = 1;
                                           end 
                                       end
                                end
            op_not           : begin                                   // Operación lógica NOT
                                   if (ALUFlagIn=='0)                      
                                       begin 
                                           Cero = 0;
                                           ALUResult = ~ALUA;
                                           if (ALUResult == vector_ceros) begin
                                               Cero = 1;
                                           end 
                                      end
                                   else
                                       begin
                                           Cero = 0;
                                           ALUResult = ~ALUB;
                                           if (ALUResult == vector_ceros) begin
                                               Cero = 1;
                                           end 
                                       end
                                end
            op_resta         : begin                                   // Operación aritmética RESTA  
                                   Cero = 0;
                                   //ALUResult = (ALUA + (ALUB*-1)) + (ALUFlagIn*-1);
                                   ALUResult = ALUA - ALUB;
                                   if (ALUResult == vector_ceros) begin
                                      Cero = 1;
                                   end 
                               end
                                   
            op_xor           : begin                                   // Operación lógica XOR
                                   Cero = 0;
                                   ALUResult = ALUA ^ ALUB;
                                   if (ALUResult == vector_ceros) begin
                                       Cero = 1;
                                   end
                               end 
            op_corrimiento_i :  begin                                  // Operación corrimiento a la izquierda
                                    Cero = 0;
                                    if (ALUFlagIn=='0)                                     
                                        begin 
                                            ALUFlags = ALUA [N-ALUB] ;
                                            ALUResult = ALUA << ALUB;
                                            if (ALUResult == vector_ceros) begin
                                                Cero = 1;
                                            end 
                                        end
                                   else if (ALUFlagIn=='1)
                                        begin   
                                            ALUFlags = ALUA [N-ALUB] ;
                                            ALUResult = ALUA << ALUB;
                                            vector_unos = vector_unos >> (N-ALUB);
                                            ALUResult = ALUResult + vector_unos;
                                            if (ALUResult == vector_ceros) begin
                                                Cero = 1;
                                            end 
                                        end
                                end
                                         
            op_corrimiento_d :  begin                                 // Operación corrimiento a la izquierda
                                    Cero = 0;
                                    if (ALUFlagIn=='0)                                
                                        begin 
                                            ALUFlags  = ALUA [ALUB-1];
                                            ALUResult = ALUA >> ALUB;
                                            if (ALUResult == vector_ceros) begin
                                                Cero = 1;
                                            end 
                                        end
                                    else if (ALUFlagIn=='1)
                                        begin
                                            ALUFlags  = ALUA [ALUB-1];
                                            ALUResult = ALUA >> ALUB; 
                                            vector_unos = vector_unos << (N-ALUB);
                                            ALUResult = ALUResult + vector_unos;
                                            if (ALUResult == vector_ceros) begin
                                                Cero = 1;
                                            end 
                                        end
                                end
            default: begin
                        ALUResult = '0;
                        Cero = 1;
                     end                                    
          endcase

       end
                 
endmodule
