module carry_lookahead (

// Se definen la entrada del carry inicial

    input logic ci_i,
    
//  Se definen las entradas del carry propagado

    input logic p0_i,
    input logic p1_i,
    input logic p2_i,
    input logic p3_i,

// Se definen las entradas del carry generado
    
    input logic g0_i,
    input logic g1_i,
    input logic g2_i,
    input logic g3_i,
    
// Se definen los carrys de salida
    
    output logic co1_o,
    output logic co2_o,
    output logic co3_o,
    output logic co4_o
);

//  Asigna a cada salida el valor correspondiente basado en las ecuacione del planteamento
 
    assign co1_o = g0_i || (p0_i && ci_i);
    assign co2_o = g1_i || (p1_i && g0_i) || (p1_i && p0_i && ci_i);
    assign co3_o = g2_i || (p2_i && g1_i) || (p2_i && p1_i && g0_i) || (p2_i && p1_i && p0_i && ci_i);
    assign co4_o = g3_i || (p3_i && g2_i) || (p3_i && p2_i && g1_i) || (p3_i && p2_i && p1_i && g0_i) || (p3_i && p2_i && p1_i && p0_i && ci_i);

endmodule