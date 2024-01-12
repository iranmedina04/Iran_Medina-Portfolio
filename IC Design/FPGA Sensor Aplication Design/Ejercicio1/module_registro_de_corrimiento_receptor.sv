module registro_de_corrimiento_receptor(
    
    input  logic            clck_i,
    input  logic            psclk_i,
    input  logic            nsclk_i,
    input  logic            miso_i, 
    output logic  [31 : 0]  dato_guardado_o

);

    logic [7 : 0] registro;
    
    always_ff @( posedge clck_i)begin
        begin
           
           if (psclk_i == 1 && nsclk_i == 0 )
                begin
                   registro <= registro << 1;
                 end
                 
           else if (psclk_i == 0 && nsclk_i == 1 )
               begin
                   registro [0] <=  miso_i;
               end
    
        end
    end
    
    assign dato_guardado_o = registro;
        
    
        

endmodule