module key_deteccion (
    
    input  logic  [3 : 0] filas_i,
    input  logic          clck_i,
    input  logic          locked,
    output logic         deteccion_o
    
);
    
    logic [3 : 0] deteccion;
    logic [3 : 0] n_filas;
    assign n_filas = ~filas_i;
    
    top_antirebotes antirebotes_1 (
        
        .clck_i(clck_i),        
        .btn_i(n_filas[3]),
        .rst_i(locked),
        .btn_signal_o(deteccion[3])
    
    );
    
    top_antirebotes antirebotes_2 (
        
        .clck_i(clck_i),        
        .btn_i(n_filas[2]),
        .rst_i(locked),
        .btn_signal_o(deteccion[2])
    
    );
    
    top_antirebotes antirebotes_3 (
        
        .clck_i(clck_i),        
        .btn_i(n_filas[1]),
        .rst_i(locked),
        .btn_signal_o(deteccion[1])
    
    );
    
    top_antirebotes antirebotes_4 (
        
        .clck_i(clck_i),        
        .btn_i(n_filas[0]),
        .rst_i(locked),
        .btn_signal_o(deteccion[0])
    
    );
    
    assign deteccion_o = ^deteccion; 

endmodule