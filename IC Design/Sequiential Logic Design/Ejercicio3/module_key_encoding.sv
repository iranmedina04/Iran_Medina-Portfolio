module key_encoding (

    input logic  columna1_i,
    input logic  columna0_i,
    
    input logic  fila1_i,
    input logic  fila0_i,
    
    output logic [ 3 : 0] num_o

    );
    
    logic [1 : 0] fila_i; 
    logic [1 : 0] columna_i;
    
    assign fila_i = {fila1_i, fila0_i};
    assign columna_i = {columna1_i, columna0_i}; 
    
    always_comb
    
        begin
        
            case (columna_i)
            
                ~2'b00:
                
                    case (fila_i)
                        
                           2'b00: num_o = 4'b1110;
                           
                           2'b01: num_o = 4'b0111; 
                           
                           2'b10: num_o = 4'b0100;
                           
                           2'b11: num_o = 4'b0001;
                           
                    endcase
                ~2'b01:
                
                    case (fila_i)
                        
                           2'b00: num_o = 4'b0000;
                           
                           2'b01: num_o = 4'b1000; 
                           
                           2'b10: num_o = 4'b0101;
                           
                           2'b11: num_o = 4'b0010;
                           
                    endcase
                
                ~2'b10:
                
                    case (fila_i)
                        
                           2'b00: num_o = 4'b1111;
                           
                           2'b01: num_o = 4'b1001; 
                           
                           2'b10: num_o = 4'b0110;
                           
                           2'b11: num_o = 4'b0011;
                           
                    endcase
                ~2'b11:
                
                    case (fila_i)
                        
                           2'b00: num_o = 4'b1101;
                           
                           2'b01: num_o = 4'b1100; 
                           
                           2'b10: num_o = 4'b1011;
                           
                           2'b11: num_o = 4'b1010;
                           
                    endcase
            endcase
        
        end
    
    
endmodule