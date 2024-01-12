`timescale 1ns / 1ps

module module_banco_de_registros
    #(
        parameter N = 32,
        parameter W = 32
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
       //Definici�n del registro
       logic   [W-1:0] [N-1:0] registro;
       logic   [W-1:0] vector_ceros = 0;
       
       always_ff @(negedge clk, negedge rst)begin
            //Reinicio del banco de registros
            if (!rst)
                begin
                    registro <= 0;
                end 
            //Asignaci�n de cero siempre a la posici�n cero del registro
            else if(addr_rd == 0)begin
                registro [addr_rd] <= vector_ceros;
                end
            //Asignaci�n de un valor en cierta posici�n del registro
            else if (we)begin
                registro [addr_rd] <= data_in;
                end
            
            //Cambio: antes estaba aufuera del always con assign, ahora esta dentro.
            rs1 = registro [addr_rs1];
            rs2 = registro [addr_rs2];
            
       end
       
       //DUDA: solo basta con ponerlo en negedge ?
       
    
endmodule
