`timescale 1ns / 1ps

module carry_lookahead_adder (

    input logic [7:0] a_i,
    input logic [7:0] b_i,
    input logic       ci_i, 
    
    output logic [7:0] sum_o,
    output logic [7:0] co_o

);
    logic [7:0] p;
    logic [7:0] g;
    
    one_bit_full_adder_cla sumador_1 
    
    (

        .a_i(a_i[0]), 
        .b_i(b_i[0]), 
        .ci_i(ci_i), 
        .sum_o(sum_o[0]), 
        .p_o(p[0]), 
        .g_o(g[0])
        
    );
    
    one_bit_full_adder_cla sumador_2 
    
    (

        .a_i(a_i[1]), 
        .b_i(b_i[1]), 
        .ci_i(co_o[0]), 
        .sum_o(sum_o[1]), 
        .p_o(p[1]), 
        .g_o(g[1])
        
    );
    
    one_bit_full_adder_cla sumador_3 
    
    (

        .a_i(a_i[2]), 
        .b_i(b_i[2]), 
        .ci_i(co_o[1]), 
        .sum_o(sum_o[2]), 
        .p_o(p[2]), 
        .g_o(g[2])
        
    );
    
    one_bit_full_adder_cla sumador_4 
    
    (

        .a_i(a_i[3]), 
        .b_i(b_i[3]), 
        .ci_i(co_o[2]), 
        .sum_o(sum_o[3]), 
        .p_o(p[3]), 
        .g_o(g[3])
        
    );
    
    one_bit_full_adder_cla sumador_5 
    
    (

        .a_i(a_i[4]), 
        .b_i(b_i[4]), 
        .ci_i(co_o[3]), 
        .sum_o(sum_o[4]), 
        .p_o(p[4]), 
        .g_o(g[4])
        
    );
    
    one_bit_full_adder_cla sumador_6 
    
    (

        .a_i(a_i[5]), 
        .b_i(b_i[5]), 
        .ci_i(co_o[4]), 
        .sum_o(sum_o[5]), 
        .p_o(p[5]), 
        .g_o(g[5])
        
    );
    
    one_bit_full_adder_cla sumador_7 
    
    (

        .a_i(a_i[6]), 
        .b_i(b_i[6]), 
        .ci_i(co_o[5]), 
        .sum_o(sum_o[6]), 
        .p_o(p[6]), 
        .g_o(g[6])
        
    );
    
    one_bit_full_adder_cla sumador_8 
    
    (

        .a_i(a_i[7]), 
        .b_i(b_i[7]), 
        .ci_i(co_o[6]), 
        .sum_o(sum_o[7]), 
        .p_o(p[7]), 
        .g_o(g[7])
        
    );
    
    carry_lookahead calculador_de_carrys_1 
    (
        
        .ci_i(ci_i),
        .p0_i(p[0]),
        .p1_i(p[1]),
        .p2_i(p[2]),
        .p3_i(p[3]),
        .g0_i(g[0]),
        .g1_i(g[1]),
        .g2_i(g[2]),
        .g3_i(g[3]),
        .co1_o(co_o[0]),
        .co2_o(co_o[1]), 
        .co3_o(co_o[2]),
        .co4_o(co_o[3])
    );
    
    carry_lookahead calculador_de_carrys_2 
    (
        
        .ci_i(co_o[3]),
        .p0_i(p[4]),
        .p1_i(p[5]),
        .p2_i(p[6]),
        .p3_i(p[7]),
        .g0_i(g[4]),
        .g1_i(g[5]),
        .g2_i(g[6]),
        .g3_i(g[7]),
        .co1_o(co_o[4]),
        .co2_o(co_o[5]), 
        .co3_o(co_o[6]),
        .co4_o(co_o[7])
    );
    
endmodule