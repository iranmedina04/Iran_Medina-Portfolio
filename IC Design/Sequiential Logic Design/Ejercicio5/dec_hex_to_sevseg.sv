`timescale 1ns / 1ps

module dec_hex_to_sevseg(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [15:0] data_i,
    output logic [3:0]  en_o,
    output logic [6:0]  seg_o
   );
    
    //Variables del contador
    logic [1:0]  sel;
    
    //Variables del clkdiv
    logic       clkdiv;
    
    clock_divider (

        .clck_i         (clk_i),
        .rst_i          (rst_i),
        .clck_divided_o (clkdiv)

    );
    
    contador_2_bits (
    
        .clck_i     (clkdiv),
        .enable_i   (1),
        .hold_i     (0),
        .rst_i      (rst_i),
        .state_o    (sel)
    
    );
   
    top_segsev(
    
        .s_i        (data_i),
        .b_i        (sel),
        .s_o        (seg_o) 

    );
    
    en_anode(
        .sel_i      (sel),
        .en_o       (en_o)
    );
    
    
    
    
    
endmodule