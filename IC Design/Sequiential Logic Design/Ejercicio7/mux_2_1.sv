`timescale 1ns / 1ps

module module_mux_2_1 #(
    parameter BUS_WIDTH = 4  //Parametro para el ancho de los datos de entrada y salida
)(
    //Entradas
    input logic [BUS_WIDTH - 1:0]   a_i,    
    input logic [BUS_WIDTH - 1:0]   b_i,
    input logic                    sel_i,
    //Salidas
    output logic [BUS_WIDTH - 1:0]  out_o
);

    //Casos para la entrada de seleccion
    always_comb begin
        case (sel_i)
            'b0: out_o = a_i;
            'b1: out_o = b_i;
            default: out_o = '0;
        endcase
    end

endmodule
