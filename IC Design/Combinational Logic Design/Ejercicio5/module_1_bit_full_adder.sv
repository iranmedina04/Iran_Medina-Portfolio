`timescale 1ns / 1ps
module one_bit_full_adder_sv 
        (

        input logic a_i, b_i, ci_i,                            //Entradas
        output logic sum_o, co_o                               //Salidas
        
        );
        
        logic n_a, n_b, n_ci;                                  //Definición de compuertas not
        logic and_1, and_2, and_3, and_4, and_5, and_6, and_7; //Definición salidas compuertas and
        
        not not_1 (n_a, a_i);                                  //Uso de compuertas not
        not not_2 (n_b, b_i);
        not not_3 (n_ci,ci_i);
        
        and and1 (and_1, n_a, n_b, ci_i);                    //Uso de compuertas and para la suma
        and and2 (and_2, n_a, b_i, n_ci);
        and and3 (and_3, a_i, n_b, n_ci);
        and and4 (and_4, a_i, b_i, ci_i);
        
        and and5 (and_5, b_i, ci_i);                       //Uso de compuertas and para el carry
        and and6 (and_6, a_i, ci_i);
        and and7 (and_7, a_i, b_i);
        
        or sum    (sum_o, and_1, and_2, and_3, and_4);     //Or del sumador
        or c_out  (co_o, and_5, and_6, and_7);             //Or del c_out
        
endmodule