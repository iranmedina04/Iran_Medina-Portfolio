`timescale 1ns / 1ps

module fsm_send (
    input logic   clk_i,
    input logic   rst_i,
    input logic   data_ctrl_i,  
    input logic   tx_rdy,

    output logic  data_ctrl_o,  //bit de send
    output logic  tx_start,
    output logic  we_ctrl_o
);

  typedef enum logic [2:0] {
    espera_send,
    genera_tx_start,
    espera_tx_rdy,
    desactiva_send
  } estados_t;

  estados_t estado_actual, estado_siguiente;

  always_ff @(posedge clk_i) begin
    if (!rst_i) begin
      estado_actual <= espera_send;
    end else begin
      estado_actual <= estado_siguiente;
    end
  end

  always_comb begin
    case (estado_actual)
      espera_send: begin
        if (data_ctrl_i == 1) begin
          estado_siguiente = genera_tx_start;
        end else begin
          estado_siguiente = espera_send;
        end
      end
      genera_tx_start: begin
        estado_siguiente = espera_tx_rdy;
      end
      espera_tx_rdy: begin
        if (tx_rdy == 1) begin 
          estado_siguiente = desactiva_send;
        end else begin
          estado_siguiente = espera_tx_rdy;
        end
      end
      desactiva_send: begin
        estado_siguiente = espera_send;
      end
      default: estado_siguiente = espera_send;
    endcase
  end

  always_comb begin
    case (estado_actual)
      genera_tx_start: begin
        tx_start = 1;
        data_ctrl_o = 1;
        we_ctrl_o = 1;
      end
      espera_tx_rdy: begin
        tx_start = 0;
        data_ctrl_o = 1;
        we_ctrl_o = 0;
      end
      desactiva_send: begin
        data_ctrl_o = 0;
        tx_start = 0;
        we_ctrl_o = 1;
      end
     default: begin
        tx_start = 0;
        data_ctrl_o = 0;
        we_ctrl_o = 0;
     end
    endcase
  end
endmodule
