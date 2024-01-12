`timescale 10ns/1ps

`include "interfaces_transacciones.sv"
`include "drv_mon.sv"
`include "checker.sv"
`include "scoreboard.sv"
`include "Library.sv"
`include "agente_generador.sv"
`include "ambiente.sv"
`include "test.sv"
`include "my_package.sv"
`default_nettype none

module test_bench();

    reg clk = 0;

    import my_package::*;

    bus_if #(.bits(my_package::bits), .drivers(my_package::drivers), .width(my_package::width), .broadcast(my_package::broadcast)) _if (.clk_i(clk));
    always #5 clk = ~clk;

     

    test #(.bits(my_package::bits), .drivers(my_package::drivers), .width(my_package::width), .broadcast(my_package::broadcast), .profundidad(my_package::profundidad)) test_inst;
    
    


    bs_gnrtr_n_rbtr #(.bits(my_package::bits), .drvrs(my_package::drivers), .pckg_sz(my_package::width), .broadcast(my_package::broadcast)) DUT (

        .clk(_if.clk_i),
        .reset(_if.rst_i),
        .pndng(_if.pndng_i),
        .push(_if.push_o),
        .pop(_if.pop_o),
        .D_pop(_if.d_pop_i),
        .D_push(_if.d_push_o)

    );

    initial begin
       
        
        test_inst = new(); 
        test_inst.vif = _if;
        test_inst.ambiente_inst.vif = _if;
        test_inst.run();
       
    end

    
endmodule