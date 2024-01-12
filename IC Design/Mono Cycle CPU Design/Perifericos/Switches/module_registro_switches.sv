module registro_switches (

input logic           clck_i,
input logic           rst_i,

input  logic [15 : 0] switches_i,
input  logic [ 3 : 0] botones_i,
output logic [31 : 0] registro_switches_o 

);

logic boton_uno;
logic boton_dos;
logic boton_tres;
logic boton_cuatro; 

top_antirebotes b1 (

    .clck_i       (clck_i)  ,
    .btn_i        (botones_i[0])  ,
    .rst_i        (rst_i),
    .btn_signal_o (boton_uno)

);

top_antirebotes b2 (

    .clck_i       (clck_i)  ,
    .btn_i        (botones_i[1])  ,
    .rst_i        (rst_i),
    .btn_signal_o (boton_dos)

);

top_antirebotes b3 (

    .clck_i       (clck_i)  ,
    .btn_i        (botones_i[2])  ,
    .rst_i        (rst_i),
    .btn_signal_o (boton_tres)

);

top_antirebotes b4 (

    .clck_i       (clck_i)  ,
    .btn_i        (botones_i[3])  ,
    .rst_i        (rst_i),
    .btn_signal_o (boton_cuatro)

);

always_ff @(posedge clck_i)
    begin
    
    registro_switches_o[15 : 0]  <= switches_i;
    registro_switches_o[16]      <= boton_uno;
    registro_switches_o[17]      <= boton_dos;
    registro_switches_o[18]      <= boton_tres;
    registro_switches_o[19]      <= boton_cuatro;
    registro_switches_o[31 : 20] <= '0;
    
    end

endmodule