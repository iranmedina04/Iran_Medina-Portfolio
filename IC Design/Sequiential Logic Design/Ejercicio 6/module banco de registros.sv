`timescale 1ns / 1ps

module module_banco_de_registros
    #(
        parameter N = 32,
        parameter W = 8
     )
     (  //Entradas
        input logic [$clog2(N)-1:0] addr_rs1,
        input logic [$clog2(N)-1:0] addr_rs2,
        input logic [$clog2(N)-1:0] addr_rd,
        input logic clk,
        input logic we,
        input logic rst,
        input logic [W-1:0] data_in,
        //Salidas
        output logic [W-1:0] rs1,
        output logic [W-1:0] rs2
       );
       //Definición del registro
       logic   [W-1:0] [N-1:0] registro;
       logic   [W-1:0] vector_ceros = '0;
       
       always_ff @(posedge clk)
            //Reinicio del banco de registros
            if (!rst)
                registro <= 0;
            //Asignación de cero siempre a la posición cero del registro
            else if(addr_rd == 0)
                registro [addr_rd] <= vector_ceros;
            //Asignación de un valor en cierta posición del registro
            else if (we)
                registro [addr_rd] <= data_in;
       
       //Asignación de la dirección del registro a leer 
       assign rs1 = registro [addr_rs1];
       assign rs2 = registro [addr_rs2];
                  

    
endmodule
