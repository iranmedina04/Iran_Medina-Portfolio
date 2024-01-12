`timescale 1ns / 1ps

module reg_datos_uart #(
    parameter N = 2,
    parameter W = 32
) (
    input logic          clk_i,
    input logic          rst_i,
    input logic          wr1_i, // Para reg[0]
    input logic          wr2_i, // Para reg[1]
    input logic [W-1:0]  data1_i, // Para reg[0]
    input logic [W-1:0]  data2_i, // Para reg[1]
    
    output logic [W-1:0] out1_o, //Salida de reg[0]
    output logic [W-1:0] out2_o  //Salida de reg[1]
);

  logic [N-1:0][W-1:0] registro;

  always_ff @(posedge clk_i) begin

    if (!rst_i) begin
      registro[0] <= 0;
      registro[1] <= 0;
    end else begin
      if (wr1_i == 1) begin     //Envío
        registro[0] <= data1_i;
      end  
      if (wr2_i == 1) begin
        registro[1] <= data2_i;  // Recepción
      end
    end
  end
  
assign out1_o = registro[0];
assign out2_o = registro[1];

endmodule
