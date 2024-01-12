module top_fsm_spi(

    input  logic          clck_i,
    input  logic          rst_i,
    input  logic [31 : 0] inst_i,
    input  logic [31 : 0] reg_i,
    input  logic          miso_i,
    
    output logic          ss_o,
    output logic          mosi_o,
    output logic          sclk_o,
    output logic          wr1_o,
    output logic [31 : 0] in1_o,
    output logic          wr2_o,
    output logic [4 : 0]  addr2_o,
    output logic          hold_ctrl_o,
    output logic [31 : 0] in2_o


);

logic reg_data_i;
logic en_dat_i;
logic psclk;
logic nsclk;

FSM_SPI fsm_spi (

    .clk_i      (clck_i),
    .rst_i      (rst_i),
    .inst_i     (inst_i),
    .reg_dat_i  (reg_data_i),//recordar que es bit por  bit
    
    .ss_o       (ss_o),
    .mosi_o     (mosi_o),
    .sclk_o     (sclk_o),
    .wr1_o      (wr1_o),
    .in1_o      (in1_o),
    .wr2_o      (wr2_o),
    .addr2_o    (addr2_o),
    .hold_ctrl_o(hold_ctrl_o),
    .en_dat_i   (en_dat_i),
    .psclk_o    (psclk),
    .nsclk_o    (nsclk)
);

registro_de_corrimiento_envio emisor (

    .clck_i         (clck_i),
    .enable_i       (en_dat_i), 
    .datos_envio_i  (reg_i),
    .psclk_i        (psclk),
    .bit_enviado_o  (reg_data_i)

);

registro_de_corrimiento_receptor receptor(
    .clck_i          (clck_i),
    .psclk_i         (psclk),
    .nsclk_i         (nsclk),
    .miso_i          (miso_i),
    .dato_guardado_o (in2_o)

);  

endmodule