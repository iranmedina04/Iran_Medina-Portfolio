`timescale 1ns / 1ps

module ripple_carry_adder 
    #(
    
    parameter ANCHO = 64             //Parametro del ancho
    
    )
    (
    
    //Definici�n de entradas
    
    input logic [ANCHO - 1 : 0] a_i, 
    input logic [ANCHO - 1 :0 ] b_i,
    input logic                 ci_i,
    
    //Definici�n de salidas
    
    output logic [ANCHO - 1 :0] sum_o,
    output logic [ANCHO :0] co_o 
    
    );

    assign co_o[0] = ci_i;                      //Define el primer carry
    
    genvar i;
    
    generate                                   // Iteraci�n para un sumador por bit
    
    for (i = 0; i < ANCHO; i= i + 1)begin
        
        one_bit_full_adder_sv sumador (        //Llama a la funci�n de del sumador de un bit
        
        .a_i(a_i[i]),
        .b_i(b_i[i]),
        .ci_i(co_o[i]),
        .sum_o(sum_o[i]),
        .co_o(co_o[i+1])
        );
    
        end    
    endgenerate

endmodule