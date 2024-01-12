`timescale 10ns/1ps
`define FIFOS
`include "fifo.sv"
`include "Library.sv"
`define LIB
`include "Router_library.sv"
`include "clases_interface.sv"
`include "sim_fifo.sv"
`include "driver.sv"
`include "monitor.sv"
`include "monitor_interno.sv"
`include "checker.sv"
`include "scoreboard.sv"
`include "agente_generador.sv"
`include "ambiente.sv"
`include "cobertura.sv"
`include "test.sv"
`include "my_package.sv"
`default_nettype none

module testbench();

    reg clk_i = 0;

    import my_package::*;

    parameter ROWS = 4;
    parameter COLUMNS = 4;  
    parameter PAKG_SIZE = 32;
    parameter FIFO_DEPTH = 16;

    mesh_if #(.ROWS(my_package::ROWS), .COLUMNS(my_package::COLUMNS), .PAKG_SIZE(my_package::PAKG_SIZE), .FIFO_DEPTH(my_package::FIFO_DEPTH)) _if (.clk_i(clk_i));

    test #(.ROWS(my_package::ROWS), .COLUMNS(my_package::COLUMNS), .PAKG_SIZE(my_package::PAKG_SIZE), .FIFO_DEPTH(my_package::FIFO_DEPTH)) my_test;

    mesh_gnrtr #(.ROWS(my_package::ROWS), .COLUMS(my_package::COLUMNS), .pckg_sz(my_package::PAKG_SIZE), .fifo_depth(my_package::FIFO_DEPTH), .bdcst({8{1'b1}})) DUT 
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

     
    always #5 clk_i = ~clk_i;

    initial begin

        
        my_test = new();
        my_test.vif = _if;

        fork
            
            my_test.run();
            

        join_none

        
    end

    
endmodule
