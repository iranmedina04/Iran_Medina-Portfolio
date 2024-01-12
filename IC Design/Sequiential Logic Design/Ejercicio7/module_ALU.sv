`timescale 1ns / 1ps

module module_ALU

     ( input  logic  [15:0] ALUA,
       input  logic  [15:0] ALUB,
       input  logic  [3:0]  ALUControl,
       output logic  [15:0] ALUResult
      );
      localparam op_and           = 'hd,
                 op_or            = 'he,
                 op_suma          = 'hb,
                 op_resta         = 'hc,
                 op_corrimiento_i = 'hf;
                
      always_comb begin
        case(ALUControl)
            op_and           : begin                                   // Operación lógica AND                                   
                                   ALUResult = ALUA & ALUB;
                               end
            op_or            : begin                                   //Operación lógica OR
                                   ALUResult = ALUA | ALUB;            
                               end
            op_suma          : begin                                   //Operación aritmética suma
                                   ALUResult = ALUA + ALUB;            
                               end
          
            op_resta         : begin                                   // Operación aritmética RESTA  
                                 
                                   ALUResult = ALUA - ALUB;
                               end
                                   
            op_corrimiento_i :  begin                                  // Operación corrimiento a la izquierda
                                    ALUResult = ALUA << ALUB;  
                                end

            default: begin
                        ALUResult = '0;
                     end                                    
          endcase

       end
                 
endmodule
