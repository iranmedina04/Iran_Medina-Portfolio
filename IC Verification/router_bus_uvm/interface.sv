/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente módulo corresponde a la interface virtual, la cual perimite la conexión entre módulos
////// 
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
interface mesh_if (

    input logic clk_i

);

// Entradas

    logic rst_i;
    logic pop [`ROWS * 2 + `COLUMNS * 2] ;
    logic [`PAKG_SIZE - 1 : 0] dato_out_i_in [`ROWS * 2 + `COLUMNS * 2];
    logic pdng_i_in [`ROWS * 2 + `COLUMNS * 2];

// Salidas

    logic pndng  [`ROWS * 2 + `COLUMNS * 2];
    logic [`PAKG_SIZE - 1 : 0] data_out [`ROWS * 2 + `COLUMNS * 2];
    logic popin [`ROWS * 2 + `COLUMNS * 2];

endinterface