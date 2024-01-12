`timescale 10ns/1ps

module depurador_de_datos (

    input logic clck_i,
    input logic rst_clck_i,

    input  logic wr_i,
    input  logic [4:0]    addr_in_i,
    input  logic [31 : 0] data_i,    //Datos del pmod

    output logic [7 : 0] data_o

);

logic [7 : 0] data;

assign data_o = data;

always_ff @(posedge clck_i)

    if (!rst_clck_i)

        data <= '0;
    else 

        if(wr_i)
            begin

                if(addr_in_i[0])
                    begin
                        
                        data [2:0] <= data_i[7:5];

                    end
                
                else 
                    begin
                        
                        data [7:3] <= data_i[4:0];

                    end
            end
        else
            begin
                
                data <= data;
            
            end
endmodule