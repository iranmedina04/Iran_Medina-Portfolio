`timescale 1ns / 1ps

module en_per_seg(
    input logic       clk_i,
    input logic       rst_i,
    input logic [3:0] seg_i,
    
    output logic      en_o
    );
    
    logic [31:0] one_seg;
    assign one_seg = seg_i*10000000; //Ciclos necesarios para contar un segundo con un clock de 10Mhz
    
    logic [31:0] contador;
    
    always_ff@(posedge clk_i)
        if (!rst_i)
            begin
                en_o     <= 0;
                contador <= 0;
            end
            
        else 
            if (contador == one_seg)
                begin
                    en_o     <= 1;
                    contador <= 0;
                end
            else 
                begin
                    en_o     <= 0;
                    contador <= contador + 1;
                end
            
endmodule
