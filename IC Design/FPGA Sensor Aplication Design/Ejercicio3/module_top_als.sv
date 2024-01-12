module top_als (

    //Tiempo

    input logic            clck_i,
    input logic            rst_i,
    input logic            rx,

    //Spi


    input  logic           miso_i,
    output logic           sclk_o,
    output logic           mosi_o,
    output logic           cs_o,
    //output logic [ 15 : 0] data_bcd_o,
    output logic           tx_o,
    output logic [3:0]     en_o,
    output logic [6:0]     seg_o
);


    logic [31 : 0]  entrada_spi_i;

    logic           end_bcd_i;
    logic           entrada_uart_i;
    logic           wr_spi_o;
    logic           reg_sel_spi_o;
    logic [31 : 0]  entrada_spi_o;
    logic [ 4 : 0]  addr_spi_o;
    logic           wr_depurador_de_datos_o;
    logic           begin_bcd;
    logic [ 15 : 0] data_bcd_o;
    logic [ 1 : 0]  sel_ascci_o;
    logic           wr_guardado_o;
    logic           wr_enviar_o;
    logic [ 7 : 0]  data_depurados_o;
    
    logic [31 : 0]  ascii;
    logic [31 : 0]  ascii_1;
    logic [31 : 0]  ascii_2;
    logic [31 : 0]  ascii_3;
    
    
    logic clear;
    logic read;
    logic sw_read;
    //logic rx;
    logic [7:0] leds_o;
    
    
    logic clk2;
    logic locked;
    clk_wiz_0 instance_name
   (
   
        .clk_out1     (clk2),
        .locked       (locked),
        .clk_in1      (clck_i)
        
    );  
    
    
    fsm_control fsmc (

    // Entradas

    .clck_i                     (clk2),
    .rst_i                      (locked),
    .entrada_spi_i              (entrada_spi_i),
    .end_bcd_i                  (end_bcd_i),
    .entrada_uart_i             (entrada_uart_i),

    //Salidas spi

    .wr_spi_o                   (wr_spi_o),
    .reg_sel_spi_o              (reg_sel_spi_o),
    .entrada_spi_o              (entrada_spi_o),
    .addr_spi_o                 (addr_spi_o),
    .wr_depurador_de_datos_o    (wr_depurador_de_datos_o),
    .begin_bcd                  (begin_bcd),
    .sel_ascci_o                (sel_ascci_o),

    //Salida para el uart

    .wr_guardado_o              (wr_guardado_o),
    .wr_enviar_o                (wr_enviar_o)

    );


    top_interfaz_spi top_spi (

    //Entrada

    .clck_i     (clk2),
    .rst_i      (~locked),
    .wr_i       (wr_spi_o),
    .reg_sel_i  (reg_sel_spi_o),
    .addr_in_i  (addr_spi_o),
    .entrada_i  (entrada_spi_o),
    .miso_i     (miso_i),
    
    //Salida

    .salida_o   (entrada_spi_i),
    .mosi_o     (mosi_o),
    .sclk_o     (sclk_o),
    .cs_o       (cs_o)
    
    );

    depurador_de_datos depdat (

        .clck_i     (clk2), 
        .rst_clck_i (locked),
        .wr_i       (wr_depurador_de_datos_o),
        .addr_in_i  (addr_spi_o),
        .data_i     (entrada_spi_i),
        .data_o     (data_depurados_o)

    );

    convetidor_binario_BCD cbbcd (

        .clck_i         (clk2),
        .rst_clck_i     (locked),
        .begin_i        (begin_bcd),
        .data_i         (data_depurados_o),
        .data_o         (data_bcd_o),
        .end_o          (end_bcd_i)
    );    
    
    
    top_UART tuart(
    
        .clk_pi         (clk2),
        .btn_send_pi    (wr_enviar_o),      
        .btn_clear_pi   (clear),     
        .btn_write_pi   (wr_guardado_o),     
        .btn_read_pi    (read),      
        .switch_read_pi (sw_read),   
        .data_in_pi     (ascii[7:0]),
        .rx             (rx),         
        .rst_pi         (locked),
        
        .leds_po        (leds_o),
        .tx             (tx_o),
        .tx_ready       (entrada_uart_i)
    
    );
    
    conversor_bcd_ascii cbcdascii (

        .data_i     (data_bcd_o),
        .ascii_1_o  (ascii_1),
        .ascii_2_o  (ascii_2),
        .ascii_3_o  (ascii_3)
    );

    module_mux_4_1 #( .BUS_WIDTH(8)) mux41
    (
        .a_i        (ascii_1[7:0]),
        .b_i        (ascii_2[7:0]),
        .c_i        (ascii_3[7:0]),
        .d_i        (8'h0D),
        .sel_i      (sel_ascci_o),
        //Salidas
        .out_o      (ascii[7:0])
    );

    dec_hex_to_sevseg sevseg(
        .clk_pi     (clk2),
        .rst_pi     (locked),
        .data_pi    (data_bcd_o),
        .en_po      (en_o),
        .seg_po     (seg_o)
        
       );

endmodule