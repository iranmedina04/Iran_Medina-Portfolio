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
            op_and           : begin                                   // Operaci�n l�gica AND                                   
                                   ALUResult = ALUA & ALUB;
                               end
            op_or            : begin                                   //Operaci�n l�gica OR
                                   ALUResult = ALUA | ALUB;            
                               end
            op_suma          : begin                                   //Operaci�n aritm�tica suma
                                   ALUResult = ALUA + ALUB;            
                               end
          
            op_resta         : begin                                   // Operaci�n aritm�tica RESTA  
                                 
                                   ALUResult = ALUA - ALUB;
                               end
                                   
            op_corrimiento_i :  begin                                  // Operaci�n corrimiento a la izquierda
                                    ALUResult = ALUA << ALUB;  
                                end

            default: begin
                        ALUResult = '0;
                     end                                    
          endcase

       end
                 
endmodule
