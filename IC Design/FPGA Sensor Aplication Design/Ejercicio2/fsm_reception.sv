`timescale 1ns / 1ps

module fsm_reception (
    input logic   clk_i,
    input logic   rst_i,
    input logic   rx_pulse_i,         // Pulso de rx que llega del uart
  
    output logic  wr2_datos_o,       // WE para el reg datos
    output logic  wr2_ctrl_o,        // WE para el reg control
    output logic  new_rx_o           // bit de new_rx hacia el reg control
 
);

typedef enum logic[2:0] {  
    WAIT_RX,
    ACTIVE_WR2,
    WRITE_NEW_RX
} estados_t;

estados_t estado_actual, estado_siguiente;

always_ff@(posedge clk_i) begin
    if(!rst_i) begin
        estado_actual <= WAIT_RX;
    end
    else begin
        estado_actual <= estado_siguiente;
    end
end

always_comb begin
    case(estado_actual)
        WAIT_RX: begin
            if (rx_pulse_i == 1) begin
                estado_siguiente = ACTIVE_WR2;
            end
            else begin
                estado_siguiente = WAIT_RX;
            end
        end
        ACTIVE_WR2:begin
            estado_siguiente = WRITE_NEW_RX;
        end
        WRITE_NEW_RX: begin
            estado_siguiente = WAIT_RX;
        end
        default: estado_siguiente = WAIT_RX;
    endcase
end

always_comb begin 
    case (estado_actual)
        WAIT_RX: begin
            wr2_datos_o = 0;
            wr2_ctrl_o = 0;
            new_rx_o = 0;
        end
        ACTIVE_WR2: begin
            wr2_datos_o = 1;
            wr2_ctrl_o = 0;
            new_rx_o = 0;
        end
        WRITE_NEW_RX: begin
            wr2_ctrl_o = 1;
            wr2_datos_o = 0;
            new_rx_o = 1;
        end
        default: begin
            wr2_datos_o = 0;
            wr2_ctrl_o = 0;
            new_rx_o = 0;
        end
    endcase
end

endmodule
