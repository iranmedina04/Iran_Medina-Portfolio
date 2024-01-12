module top_antirebotes (
    
    input  logic clck_i,
    input  logic btn_i,
    input  logic rst_i,

    output logic btn_signal_o
);

    logic conexion;
   
    
    anti_rebote anti_rebote (
        
        .clk_i(clck_i),
        .rst_i(rst_i),
        .bn_i(btn_i),
        .p_o(conexion)
    
    );
    
    sincronizador s(

    .clck_i     (clck_i),
    .d_i        (conexion),
    .q_o        (btn_signal_o)

    );

endmodule