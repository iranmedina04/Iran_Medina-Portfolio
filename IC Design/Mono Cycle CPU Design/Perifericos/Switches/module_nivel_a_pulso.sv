module nivel_a_pulso (

    input logic clck_i,
    input logic boton_i,
    input logic rst_i,
    output logic nivel_o
    

);

logic [1:0] estado;
logic [1:0] espera_boton = 2'b00;
logic [1:0] espera_soltar_boton = 2'b01;
logic [1:0] genera_pulso = 2'b10;

always_ff @(posedge clck_i)

    begin
        
        if(!rst_i)
        
            estado <= espera_boton;
        else
            
        begin
        
            case (estado)
            
                espera_boton: 
                    
                    begin
                       
                        nivel_o <= 0; 
                        if (boton_i)
                        
                            estado <= espera_soltar_boton;       
                        
                        else
                            
                            estado <= estado;
                    end
                    
                espera_soltar_boton: 
                    
                    begin
                       
                        nivel_o <= 0;
                        if (boton_i)
                        
                            estado <= espera_soltar_boton;       
                        
                        else
                            
                            estado <= genera_pulso;   
                                 
                    end 
                
                genera_pulso: 
                    
                    begin
                        
                        nivel_o <= 1;
                        estado <= espera_boton;
                                 
                    end
                
            endcase
        
        end
    end


endmodule