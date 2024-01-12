`include "my_package.sv"
`define ROWS  4
`define COLUMNS 4
`define broadcast {8{1'b1}}
`define FIFOS
`include "fifo.sv"
`include "Library.sv"
`define LIB
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "Router_library.sv"
`include "interface.sv"
`include "sequence_item.sv"
`include "secuencia.sv"
`include "sim_fifo.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "ambiente.sv"
`include "prueba.sv"


module tb;

reg clk_i;
always #5 clk_i = ~clk_i;

mesh_if _if (clk_i);

//Instancia del DUT
mesh_gnrtr  #(.ROWS(`ROWS), .COLUMS(`COLUMNS), .pckg_sz(`PAKG_SIZE), .fifo_depth(`FIFO_DEPTH), .bdcst(`broadcast)) DUT
    (
        .pndng(_if.pndng),
        .data_out(_if.data_out),
        .popin(_if.popin),
        .pop(_if.pop),
        .data_out_i_in(_if.dato_out_i_in),
        .pndng_i_in(_if.pdng_i_in),
        .clk(_if.clk_i),
        .reset(_if.rst_i)
    );

initial begin

    clk_i <= 0;
    uvm_config_db#(virtual mesh_if)::set(null,"uvm_test_top","mesh_vif",_if);
    run_test("un_paquete"); //Corrida de la prueba
end    

endmodule
