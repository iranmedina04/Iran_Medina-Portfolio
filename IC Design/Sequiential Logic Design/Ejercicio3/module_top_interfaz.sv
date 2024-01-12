module top_interfaz (
    
    input logic clck_i,
    input logic locked,
    input logic  [3 : 0] filas_i,
    input logic  [1 : 0] filas_codificadas_i,  
    output logic [1 : 0] salidas_contador_o,
    output logic [3 : 0] numero_o,
    output logic led_o
    
    
);

    
    logic clck_divided;
    logic anti_rebote;
    logic salida_d1;
    logic salida_d2;
    logic salida_d3;
    logic salida_d4;
    logic n_anti_rebote;
    
    
    
    clock_divider clck_divider (
                   
                                .clck_i(clck_i), 
                                .rst_i(locked),
                                .clck_divided_o(clck_divided)
                               );
    
    contador_2_bits contador (  
                                
                              .clck_i(clck_i),
                              .enable_i(clck_divided),
                              .hold_i(anti_rebote),
                              .rst_i(locked),  
                              .state_o(salidas_contador_o) 
                                );
    key_deteccion detector (
    
        .filas_i(filas_i),
        .clck_i(clck_i),
        .locked(locked),
        .deteccion_o(anti_rebote)
    
    );
                               
    assign n_anti_rebote = ~anti_rebote;
    
    d_flip_flop d_0 (
    
                      .enable_i(clck_i),
                      .d_i(n_anti_rebote),
                      .q_o(led_o)  
    
                     );
    
    d_flip_flop d_1 (
    
                      .enable_i(anti_rebote),
                      .d_i(salidas_contador_o[1]),
                      .q_o(salida_d1)  
    
                     );
    
    d_flip_flop d_2 (
    
                      .enable_i(anti_rebote),
                      .d_i(salidas_contador_o[0]),
                      .q_o(salida_d2)  
    
                     );
                     
    d_flip_flop d_3 (
    
                      .enable_i(anti_rebote),
                      .d_i(filas_codificadas_i[1]),
                      .q_o(salida_d3)  
    
                     );
    
    d_flip_flop d_4 (
    
                      .enable_i(anti_rebote),
                      .d_i(filas_codificadas_i[0]),
                      .q_o(salida_d4)  
    
                     );      
    
    key_encoding codificador_tecla (
    
        .columna1_i(salida_d1),    
        .columna0_i(salida_d2),
        .fila1_i(salida_d3),
        .fila0_i(salida_d4),
        .num_o(numero_o)
    
    );                         
                                

endmodule             
                               