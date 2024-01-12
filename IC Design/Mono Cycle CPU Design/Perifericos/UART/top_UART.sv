`timescale 1ns / 1ps

/// TOP INTERFAZ UART //////    
module top_UART (
    input logic         clk_pi, 
    input logic         rst,    
    input logic         we_i,     
    input logic [1:0]   addr_i,   //reg sel = addr[0], addr_regdatos = addr[1]      
    input logic [31:0]  data_i,
    input logic         rx,         

    output logic [31:0]  data_o,
    output logic         tx
    
);

logic wr2_send;
//Se?ales para el Registro de contol
logic wr1_control;                      // WR1 del mux
logic wr2_control;                      // WR2 de la fsm
logic in_control;                       // IN2 entrada de la fsm1 
logic in2_control;                      // IN2 entrada de la fsm2
logic [31:0] out_control;               // OUT 

// Se?ales para el Registro de datos
logic wr1_datos;                        // WR1 del mux
logic wr2_datos;                        // WR2 de la fsm
logic [7:0] in_datos;                   // IN1 entrada de los switches
logic [31:0] out_datos1;                // OUT1 para el mux 
logic [31:0] out_datos2;                // OUT2 para la fsm

/// Se?ales para el modulo de Pruebas
logic [31:0] out_mux_addr;             // Salida del mux para la lectura de datos
logic addr;
//logic [31:0] data_i;
logic [7:0] leds_out;                  // Leds en la FPGA

// Se?ales para el UART
logic rx_pulse;
logic tx_pulse;
logic tx_ready;

logic [31:0] out_mux_reg;
assign data_o = out_mux_reg;  ///out mux reg


// Mux para la salida de la interfaz
mux_2_a_1 mux1(
    .a_i    (out_control),
    .b_i    (out_mux_addr),
    .sel_i  (addr_i[0]), // reg_sel
    
    .out_o  (out_mux_reg)
);


// Mux para la salidas de los registros 
mux_2_a_1 mux2(
    .a_i    (out_datos1),
    .b_i    (out_datos2),
    .sel_i  (addr_i[1]), //addr_reg_datos
    
    .out_o  (out_mux_addr)
);

//Demux para el write enable
demux_2_a_1 demux(
    .in_i       (we_i),
    .sel_i      (addr_i[0]), //reg_sel
    
    .out1_o     (wr1_control),
    .out2_o     (wr1_datos)
);

// Registro de control
reg_control reg0(
    .clk_i      (clk_pi),          
    .rst_i      (rst),   
    .wr1_i      (wr1_control),
    .wr2_send_i (wr2_send),
    .wr2_new_i  (wr2_control),
    .data1_i    (data_i),
    .data2_i    ({30'd0,in2_control,in_control}),
 
    .out_o      (out_control)
);

// Registro de datos
reg_datos reg1(
    .clk_i       (clk_pi),
    .rst_i       (rst),
    .wr1_i      (wr1_datos),
    .wr2_i      (wr2_datos),
    .data1_i    (data_i),
    .data2_i    ({24'd0,in_datos}),
   
    .out1_o     (out_datos1),
    .out2_o     (out_datos2)
);

// FSM para la recepcion de datos
fsm_reception fsm2(
    .clk_i          (clk_pi),
    .rst_i          (rst),
    .rx_pulse_i     (rx_pulse),    //estaba rx_pulse

    .wr2_datos_o    (wr2_datos),
    .wr2_ctrl_o     (wr2_control), 
    .new_rx_o       (in2_control)
);

// FSM para el envio de datos
fsm_send fsm1( 
    .clk_i          (clk_pi),
    .rst_i          (rst),  
    .data_ctrl_i    (out_control[0]), 
    .tx_rdy         (tx_ready),
      
    .data_ctrl_o    (in_control),
    .tx_start       (tx_pulse),
    .we_ctrl_o      (wr2_send)
);

UART uart(
       .clk             (clk_pi),           
       .reset           (~rst),
       .tx_start        (tx_pulse),
       
       .tx_rdy         (tx_ready),
       .rx_data_rdy    (rx_pulse),
       
       .data_in        (out_datos1[7:0]), 
       .data_out       (in_datos), 

       .rx             (rx),
       .tx             (tx)
);

endmodule