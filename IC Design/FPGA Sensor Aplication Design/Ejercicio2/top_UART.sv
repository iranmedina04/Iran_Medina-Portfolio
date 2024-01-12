`timescale 1ns / 1ps

module top_UART (
    input logic         clk_pi,
    input logic         btn_send_pi,      
    input logic         btn_clear_pi,     
    input logic         btn_write_pi,     
    input logic         btn_read_pi,      
    input logic         switch_read_pi,   
    input logic [7:0]   data_in_pi,
    input logic         rx,         

    output logic [7:0]  leds_po,
    output logic        tx
    
);

//Señales para el Registro de contol
logic wr1_control;                      // WR1 del mux
logic wr2_control;                      // WR2 de la fsm
logic in_control;                       // IN2 entrada de la fsm1 
logic in2_control;                      // IN2 entrada de la fsm2
logic [31:0] out_control;               // OUT 

// Señales para el Registro de datos
logic wr1_datos;                        // WR1 del mux
logic wr2_datos;                        // WR2 de la fsm
logic [7:0] in_datos;                   // IN1 entrada de los switches  ////*******///
logic [31:0] out_datos1;                // OUT1 para el mux /////*****/////
logic [31:0] out_datos2;                // OUT2 para la fsm

/// Señales para el modulo de Pruebas
logic [31:0] out_mux_addr;             // Salida del mux para la lectura de datos
logic wr;                               
logic reg_sel;
logic addr;
logic [31:0] data_i;
logic [7:0] leds_out;                  // Leds en la FPGA

// Señales para el UART
logic rx_pulse;
logic tx_pulse;
logic tx_ready;

logic rst_uart;

assign leds_po = leds_out;

logic clk2;   /// Clock de 10 MHz
logic rst;    /// Locked


// Clocking wizard
clk_wiz_0 clk_wiz (
  .clk_out1         (clk2),    
  
  .locked           (rst),
  .clk_in1          (clk_pi)
 );

// Pruebas
control_pruebas pruebas(
    .clk_i          (clk2),
    .rst_i          (rst),
    .btn_send_i     (btn_send_pi),     
    .btn_clear_i    (btn_clear_pi),    
    .btn_write_i    (btn_write_pi),    
    .btn_read_i     (btn_read_pi),     
    .switch_read_i  (switch_read_pi),    
    .data_in_i      ({24'd0,data_in_pi}), 
    .mux_i          (out_mux_addr),       

    .wr_o           (wr),
    .reg_sel_o      (reg_sel),
    .data_out_o     (data_i),
    .addr_o         (addr),
    .leds_o         (leds_out)

    );

// Mux para la salidas de los registros 
mux_2_a_1 mux2(
    .a_i    (out_datos1),
    .b_i    (out_datos2),
    .sel_i  (addr),
    
    .out_o  (out_mux_addr)
);

//Demux para el write enable
demux_2_a_1 demux(
    .in_i       (wr),
    .sel_i      (reg_sel),
    
    .out1_o     (wr1_control),
    .out2_o     (wr1_datos)
);

// Registro de control
reg_control reg0(
    .clk_i      (clk2),          
    .rst_i      (rst),   
    .wr1_i      (wr1_control),
    .wr2_i      (wr2_control),
    .data1_i    (data_i),
    .data2_i    ({30'd0,in2_control,in_control}),
 
    .out_o      (out_control)
);

// Registro de datos
reg_datos reg1(
    .clk_i       (clk2),
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
    .clk_i          (clk2),
    .rst_i          (rst),
    .rx_pulse_i     (rx_pulse),

    .wr2_datos_o    (wr2_datos),
    .wr2_ctrl_o     (wr2_control), 
    .new_rx_o       (in2_control)
);

// FSM para el envio de datos
fsm_send fsm1( 
    .clk_i          (clk2),
    .rst_i          (rst),  
    .data_ctrl_i    (out_control[0]), 
    .tx_rdy         (tx_ready),
      
    .data_ctrl_o    (in_control),
    .tx_start       (tx_pulse)
);

UART uart(
       .clk             (clk2),           
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