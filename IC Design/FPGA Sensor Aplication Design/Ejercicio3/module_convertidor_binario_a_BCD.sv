`timescale 10ns/1ps

module convetidor_binario_BCD (

    input logic             clck_i,
    input logic             rst_clck_i,

    input logic             begin_i,
    input logic  [ 7 : 0]   data_i,
    

    output logic [15: 0]    data_o,
    output logic            end_o

);

typedef enum logic [2:0] {
estado_espera, 
                          estado_escribe, 
                          estado_corrimiento, 
                          estado_revisa_1, 
                          estado_revisa_2, 
                          estado_revisa_3, 
                          estado_fin
                            
                          } estado_t;

estado_t                estado_actual;
estado_t                estado_siguiente;
logic       [ 2 : 0]    contador;
logic       [23 : 0]    registro;
assign data_o         =  registro [23 : 8];


always_ff @(posedge clck_i)
    begin

        if(!rst_clck_i)
        begin
            estado_actual <= estado_espera;
            contador <= '0;
            registro <= '0;
            end_o    <= '0;
        end
        else 
            begin
            
                case(estado_actual)

            estado_espera: 
                begin
                    
                    if(begin_i)
                    
                        begin
                            registro [23 : 8] <= 0;
                            registro [7 : 0] <= data_i;
                            estado_actual <= estado_escribe; 
                        
                        end
                    else    
                        
                        estado_actual <= estado_espera;

                end

            estado_escribe: 
                begin
                    
                    end_o <= 0;
                    estado_actual <= estado_corrimiento;

                end
            estado_corrimiento: 
                begin

                    registro <= registro << 1;
                    contador <= contador + 1;


                    if(contador < 7)
                    
                        estado_actual <= estado_revisa_1;

                    else

                        estado_actual <= estado_fin;

                end
            estado_revisa_1:
                begin

                    contador         <= contador;
                    estado_actual <= estado_revisa_2;

                    if (registro[11 : 8] >= 5)
                        begin
                            
                            registro [11 : 8] <= registro [11 : 8] + 3;
                        
                        end
                    else
                        begin

                            registro [11 : 8] <= registro [11 : 8];

                        end

                end
            estado_revisa_2:
                begin

                    contador         <= contador;
                    estado_actual <= estado_revisa_3;
                    
                    if (registro[15 : 12] >= 5)
                        begin
                            
                            registro [15 : 12] <= registro [15 : 12] + 3;
                        
                        end
                    else
                        begin

                            registro [15 : 12] <= registro[15 : 12];

                        end

                end
            
            estado_revisa_3:
                begin

                    contador         <= contador;
                    estado_actual <= estado_corrimiento;
                    
                    if (registro[19 : 16] >= 5)
                        begin
                            
                            registro [19 : 16] <= registro [19 : 16] + 3;
                        
                        end
                    else
                        begin

                            registro [19 : 16] <= registro [19 : 16];

                        end

                end
            estado_fin:
                begin

                    estado_actual <= estado_espera;
                    end_o <= 1;

                end
            default :
                
                estado_actual <= estado_actual;

        endcase
            
            
            end
    end

endmodule