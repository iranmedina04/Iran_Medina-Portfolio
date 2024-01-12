`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 11:19:10 PM
// Design Name: 
// Module Name: banco_registros_spi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module banco_registros_spi#(
        parameter N = 32,
        parameter W = 32
     )
     (  //Entradas
        input  logic [$clog2(N)-1:0] addr1_i,
        input  logic [$clog2(N)-1:0] addr2_i,
        input  logic                 clk_i,
        input  logic                 rst_i,
        input  logic                 hold_ctrl_i,
        input  logic                 wr1_i,
        input  logic                 wr2_i,
        input  logic [W-1:0]         data1_i,
        input  logic [W-1:0]         data2_i,
        
        //Salidas
        output logic [W-1:0]         data_o
       );
       
       //Definición del registro
       logic   [W-1:0] [N-1:0] registro;
       logic   [W-1:0] vector_ceros = 0;
       
       always_ff @(posedge clk_i)begin
            //Reinicio del banco de registros
            if (rst_i)
                registro <= 0;
            
            //Asignación de un valor en cierta posición del registro
            else if (wr1_i ==  1 & hold_ctrl_i == 0 )
                registro [addr1_i] <= data1_i;
            
            else if (wr2_i == 1)
                registro [addr2_i] <= data2_i;
                
            else 
                registro           <= registro;
                
       end
       
       always_ff @(posedge clk_i) begin 
            if (rst_i)
                data_o <= 0;
            
            else if (hold_ctrl_i)
                data_o = registro[addr2_i];
                
            else 
                data_o = registro[addr1_i];
       end 
    
endmodule