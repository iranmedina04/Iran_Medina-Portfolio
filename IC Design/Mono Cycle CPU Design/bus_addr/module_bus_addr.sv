module bus_addr (

// Entradas que vienen del microprecesaor
    input logic [31 : 0] addr_mp_i,
    input logic          we_mp_i,
    input logic [31 : 0] data_mp_i,

// Dato de salida que envia el microprocesador
    output logic [31 : 0] data_mp_o,

//Entradas del dato leido de los perifericos

    input logic [31 : 0] read_ram_i,
    input logic [31 : 0] read_swithces_i,
    input logic [31 : 0] read_uart_a_i,
    input logic [31 : 0] read_uart_b_i,
    input logic [31 : 0] read_uart_c_i,
    input logic [31 : 0] read_siente_segmento_i,
    input logic [31 : 0] read_led_i,

// Salidas de los wr enable para cada periférico
    
    output logic we_ram_o,
    output logic we_uart_a_o,
    output logic we_uart_b_o,
    output logic we_uart_c_o,
    output logic we_switches_o,
    output logic we_led_o,
    output logic we_siete_segmentos_o,

// Salida dato que viene del procesador 

    output logic [31 : 0] dato_pr_o,

// Salida para controlar los UART

    output logic regg_sel_o,
    output logic adddr_o,

// Salida para controlar las lineas del ram

    output logic [7 :0] addr_ram_o

);

always_comb
    begin

        regg_sel_o  = addr_mp_i[3];
        adddr_o     = addr_mp_i[2];
        addr_ram_o  = addr_mp_i [9 : 2];
        data_mp_o   =  data_mp_i;

    end

mux_procesador mux (
    .mux_sel_i      (addr_mp_i),
    .ram_i          (read_ram_i),
    .uart_a_i       (read_uart_a_i),
    .uart_b_i       (read_uart_b_i),
    .uart_c_i       (read_uart_c_i),
    .switches_i     (read_swithces_i),
    .led_i          (read_led_i),
    .siete_segmentos(read_siente_segmento_i),  
    .mux_o          (dato_pr_o)  

);

demux_procesador demux (

    .dmux_sel_i             (addr_mp_i),
    .we_i                   (we_mp_i),
    .we_ram_o               (we_ram_o),
    .we_uart_a_o            (we_uart_a_o),
    .we_uart_b_o            (we_uart_b_o),
    .we_uart_c_o            (we_uart_c_o),
    .we_switches_o          (we_switches_o),
    .we_led_o               (we_led_o),
    .we_siete_segmentos_o   (we_siete_segmentos_o)

);



endmodule