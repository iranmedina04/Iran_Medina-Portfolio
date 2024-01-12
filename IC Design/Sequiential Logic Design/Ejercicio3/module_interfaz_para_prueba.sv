module interfaz_para_prueba (

    input logic clk_i,
    input logic  [3 : 0] filas_i,
    input logic  [1 : 0] filas_codificadas_i,  
    output logic [1 : 0] salidas_contador_o,
    output logic [7 : 0] numero_o,
    output logic [3 : 0] enable_o,
    output logic led_o
);
    logic [3 : 0] numero_4_bits;
    
     top_interfaz interfaz (
      
        .clk_i(clk_i),
        .filas_i(filas_i),
        .filas_codificadas_i(filas_codificadas_i),
        .salidas_contador_o(salidas_contador_o),
        .numero_o(numero_4_bits),
        .led_o(led_o)
      );     
        
     module_sevseg(
        .d_i(numero_4_bits),
        .s_o(numero_o),
        .en(enable_o) 
        );

endmodule