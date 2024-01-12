`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 10:49:40 PM
// Design Name: 
// Module Name: top
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

module top(
    input  logic            clk_i,
    input  logic            rst_i,
    
    input logic  [ 3 : 0]   botones_i,
    input logic  [15 : 0]   switches_i, 
    
    input  logic            rx_a,
    
    output logic            tx_a,
    input  logic            rx_b,
    
    output logic            tx_b,
    input  logic            rx_c,
    
    output logic            tx_c,
    output logic [15 :0]    leds_o,
    output logic [6 : 0]    siete_segmento_o,
    output logic [3 : 0]    enable_o
    
);

logic [31:0] writedata_o;
logic [31:0] dataadr_o;
logic        memwrite_o;

//Variables bus//////////////////////////////////////////////////////////////////////

// Entradas que vienen del microprecesaor

    logic [31 : 0] addr_mp_i;
    logic          we_mp_i;
    logic [31 : 0] data_mp_i;

// Dato de salida que envia el microprocesador
    logic [31 : 0] data_mp_o;

//Entradas del dato leido de los perifericos

    logic [31 : 0] read_ram_i;
    logic [31 : 0] read_swithces_i;
    logic [31 : 0] read_uart_a_i;
    logic [31 : 0] read_uart_b_i;
    logic [31 : 0] read_uart_c_i;
    logic [31 : 0] read_siente_segmento_i;
    logic [31 : 0] read_led_i;

// Salidas de los wr enable para cada periférico
    
    logic we_ram_o;
    logic we_uart_a_o;
    logic we_uart_b_o;
    logic we_uart_c_o;
    logic we_switches_o;
    logic we_led_o;
    logic we_siete_segmentos_o;

// Salida dato que viene del procesador 

    logic [31 : 0] dato_pr_o;

// Salida para controlar los UART

    logic regg_sel_o;
    logic adddr_o;

// Salida para controlar las lineas del ram

    logic [7 :0] addr_ram_o;

////////////////////////////////////////////////////////////////////////////

//Variables Procesador
logic [31:0] pc;
logic [31:0] instr;
logic [31:0] readdata;

// Variables clock
logic clk2;
logic locked;
clock reloj
   (
    .clk_o      (clk2),   
    .reset      (rst_i), 
    .locked     (locked),
    .clk_i      (clk_i)
    );
    
    
riscvsingle rvsingle(
    .clk_i          (clk2),
    .reset_i        (!locked), 
    .instr_i        (instr),  //ProgIn
    .readdata_i     (readdata), //DataIn
    
    .pc_o           (pc),  //ProgAddress
    .memwrite_o     (memwrite_o),//we_o
    .aluresult_o    (dataadr_o), //DataAddress
    .writedata_o    (writedata_o) //DataOut

);
    
RAM ram (
    .a      (addr_ram_o),      // input wire [7 : 0] a
    .d      (data_mp_o),      // input wire [31 : 0] d
    .clk    (clk2),  // input wire clk
    .we     (we_ram_o),    // input wire we
    .spo    (read_ram_i)  // output wire [31 : 0] spo
);

ROM rom (
    .a      (pc[10:2]),      // input wire [8 : 0] a
    .spo    (instr)  // output wire [31 : 0] spo
);

bus_addr bus(

// Entradas que vienen del microprecesaor
    .addr_mp_i                  (dataadr_o),
    .we_mp_i                    (memwrite_o),
    .data_mp_i                  (writedata_o),

// Dato de salida que envia el microprocesador
    .data_mp_o                  (data_mp_o),  //Basicamente es el dato de salida del procesador pero lanzado a esa salida

//Entradas del dato leido de los perifericos

    .read_ram_i                 (read_ram_i),
    .read_swithces_i            (read_swithces_i),
    .read_uart_a_i              (read_uart_a_i),
    .read_uart_b_i              (read_uart_b_i),
    .read_uart_c_i              (read_uart_c_i),
    .read_siente_segmento_i     (read_siente_segmento_i),
    .read_led_i                 (leds_o),

// Salidas de los wr enable para cada periferico
    
    .we_ram_o                   (we_ram_o),
    .we_uart_a_o                (we_uart_a_o),
    .we_uart_b_o                (we_uart_b_o),
    .we_uart_c_o                (we_uart_c_o),
    .we_switches_o              (),
    .we_led_o                   (we_led_o),
    .we_siete_segmentos_o       (we_siete_segmentos_o),

// Salida dato que viene del procesador 

    .dato_pr_o                  (readdata), //supongo que es el dato de entrada al procesador 

// Salida para controlar los UART

    .regg_sel_o                 (regg_sel_o),
    .adddr_o                    (adddr_o),

// Salida para controlar las lineas del ram

    .addr_ram_o                 (addr_ram_o)

);


top_UART uart_a(
    .clk_pi     (clk2), 
    .rst        (locked),    
    .we_i       (we_uart_a_o),     
    .addr_i     ({adddr_o,regg_sel_o} ),   //reg sel = addr[0], addr_regdatos = addr[1]      
    .data_i     (data_mp_o),
    .rx         (rx_a),         
    .data_o     (read_uart_a_i),
    .tx         (tx_a)
    
);
    
top_UART uartb(
    .clk_pi     (clk2), 
    .rst        (locked),    
    .we_i       (we_uart_b_o),     
    .addr_i     ({adddr_o,regg_sel_o} ),   //reg sel = addr[0], addr_regdatos = addr[1]      
    .data_i     (data_mp_o),
    .rx         (rx_b),         
    .data_o     (read_uart_b_i),
    .tx         (tx_b)
    
);

top_UART uartc(
    .clk_pi     (clk2), 
    .rst        (locked),    
    .we_i       (we_uart_c_o),     
    .addr_i     ({adddr_o,regg_sel_o} ),   //reg sel = addr[0], addr_regdatos = addr[1]      
    .data_i     (data_mp_o),
    .rx         (rx_c),         
    .data_o     (read_uart_c_i),
    .tx         (tx_c)
    
);

registro_switches rswitches (

    .clck_i             (clk2)             ,
    .rst_i              (locked)           ,
    
    .switches_i         (switches_i)       ,
    .botones_i          (botones_i)        ,  
    
    .registro_switches_o (read_swithces_i)

);

logic [31 : 0] leds;

assign leds_o = leds[15 : 0]; 

registro_leds rleds (

  .clck_i      (clk2)       ,
  .rst_i       (locked)     ,
  .data_i      (data_mp_o)  ,
  .we_i        (we_led_o)   ,
  .reg_leds_o  (leds)

);

s_register seven_segments (
   .clk_i      (clk2)   ,
   .reset_i    (locked)   ,
   .we_i       (we_siete_segmentos_o)   ,
   .data_i     (data_mp_o[15:0])   ,
   .seg_o      (siete_segmento_o)   ,
   .en_o       (enable_o)
    );






endmodule
