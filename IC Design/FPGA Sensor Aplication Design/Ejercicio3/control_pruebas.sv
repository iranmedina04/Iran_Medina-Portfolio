`timescale 1ns / 1ps

module control_pruebas (
    input logic         clk_i,
    input logic         rst_i,
    input logic         btn_send_i,     // Enviar dato
    input logic         btn_clear_i,    // Borrar bit new_rx
    input logic         btn_write_i,    // Escribir datos al registro
    input logic         btn_read_i,     // Leer registros
    input logic         switch_read_i,  // Switch para elegir que registro leer
    input logic [7:0]  data_in_i,
    input logic [7:0]  mux_i,

    output logic        wr_o,
    output logic        reg_sel_o,
    output logic [31:0] data_out_o,
    output logic        addr_o,
    output logic [7:0]  leds_o

);


  typedef enum logic [3:0] {
    IDLE,
    SEND_DATA,
    CLEAR_BIT_NEW_RX,
    WRITE_DATA,
    READ_REG_0,
    READ_REG_1

  } estados_t;

  estados_t estado_actual, estado_siguiente;

  always_ff @(posedge clk_i) begin
    if (!rst_i) begin
      estado_actual <= IDLE;
    end else begin
      estado_actual <= estado_siguiente;
    end
  end

  always_comb begin
    case (estado_actual)
      IDLE: begin
        if (btn_send_i == 1) begin
          estado_siguiente = SEND_DATA;
        end else if (btn_clear_i == 1) begin
          estado_siguiente = CLEAR_BIT_NEW_RX;
        end else if (btn_write_i == 1) begin
          estado_siguiente = WRITE_DATA;
        end else if (btn_read_i == 1) begin
          if (switch_read_i == 0) begin
            estado_siguiente = READ_REG_0;
          end else begin
            estado_siguiente = READ_REG_1;
          end
        end else begin
          estado_siguiente = IDLE;
        end
      end
      SEND_DATA: begin
        estado_siguiente = IDLE;
      end
      CLEAR_BIT_NEW_RX: begin
        estado_siguiente = IDLE;
      end
      WRITE_DATA: begin
        estado_siguiente = IDLE;
      end
      READ_REG_0: begin
        if (btn_send_i == 1) begin
          estado_siguiente = SEND_DATA;
        end else if (btn_clear_i == 1) begin
          estado_siguiente = CLEAR_BIT_NEW_RX;
        end else if (btn_write_i == 1) begin
          estado_siguiente = WRITE_DATA;
        end else if (btn_read_i == 1) begin
          if (switch_read_i == 0) begin
            estado_siguiente = READ_REG_0;
          end else begin
            estado_siguiente = READ_REG_1;
          end
        end else begin
          estado_siguiente = READ_REG_0;
        end
      end
      READ_REG_1: begin
        if (btn_send_i == 1) begin
          estado_siguiente = SEND_DATA;
        end else if (btn_clear_i == 1) begin
          estado_siguiente = CLEAR_BIT_NEW_RX;
        end else if (btn_write_i == 1) begin
          estado_siguiente = WRITE_DATA;
        end else if (btn_read_i == 1) begin
          if (switch_read_i == 0) begin
            estado_siguiente = READ_REG_0;
          end else begin
            estado_siguiente = READ_REG_1;
          end
        end else begin
          estado_siguiente = READ_REG_1;
        end
      end
      default: begin
        estado_siguiente = IDLE;
      end
    endcase
  end

  always_comb begin
    case (estado_actual)
      IDLE: begin
        wr_o = 0;
        reg_sel_o = 0;
        data_out_o = 0;
        leds_o = 0;
        addr_o = 0;
      end

      SEND_DATA: begin
        wr_o = 1;
        reg_sel_o = 0;
        data_out_o = {30'd0, 2'b01};
        leds_o = 0;
        addr_o = 0;
      end

      CLEAR_BIT_NEW_RX: begin
        wr_o = 1;
        reg_sel_o = 0;
        data_out_o = {30'd0, 2'b00};
        leds_o = 0;
        addr_o = 0;
      end

      WRITE_DATA: begin
        wr_o = 1;
        reg_sel_o = 1;
        data_out_o = data_in_i;
        leds_o = 0;
        addr_o = 0;
      end

      READ_REG_0: begin
        wr_o = 0;
        reg_sel_o = 1;
        data_out_o = '0;
        leds_o = mux_i[7:0];
        addr_o = 0;
      end
      
      READ_REG_1: begin
        wr_o = 0;
        reg_sel_o = 1;
        data_out_o = '0;
        leds_o = mux_i[7:0];
        addr_o = 1;
      end
      
      default: begin
        wr_o = 0;
        reg_sel_o = 0;
        data_out_o = 0;
        leds_o = 0;
        addr_o = 0;
      end
    endcase
  end


endmodule
