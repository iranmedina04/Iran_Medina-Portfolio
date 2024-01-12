`timescale 1ns / 1ps
module one_bit_full_adder_cla 
    (
    
    // Se definen las entradas
    
    input logic a_i,
    input logic b_i,
    input logic ci_i,
    
    // Se definen las salidas
    
    output logic sum_o,
    output logic p_o,
    output logic g_o
    );
    
    // Se genera el carry propagado, el carry generado y el resultado de la suma
    
    assign p_o = a_i ^ b_i;
    assign g_o = a_i & b_i;
    assign sum_o = p_o ^ ci_i;
    
    
endmodule