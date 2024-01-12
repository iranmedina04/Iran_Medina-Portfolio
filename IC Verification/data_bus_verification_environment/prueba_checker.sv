`timescale 10ns/1ps
`include "interfaces_transacciones.sv"
`include "checker.sv"
`default_nettype none

module prueba_driver();

    reg clk = 0;
    parameter bits = 1;
    parameter drivers = 2;
    parameter width = 32;
    parameter broadcast = {8{1'b1}};
    parameter profundidad = 16;
    
    bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) _if(.clk_i(clk)) _if;
    always #5 clk = ~clk;

    chkr #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) chcker;

    trans_bus   transaccion_monitor;
    trans_bus   transaccion_encontrada;
    trans_sb    transaccion_verificada;
    trans_bus_mbx mon_ckcr_mbx;
    trans_bus_mbx sc_ckr_solicitud;
    trans_bus_mbx sc_ckr_encontrado;
    trans_sb_mbx chkr_sb_verificado;

    

    initial begin
        
        transaccion_monitor = new();
        transaccion_encontrada = new();
        transaccion_verificada = new();
        mon_ckcr_mbx = new();
        sc_ckr_encontrado = new();
        sc_ckr_solicitud = new();
        chkr_sb_verificado = new();
        chcker = new();

        chcker.mon_ckcr_mbx = mon_ckcr_mbx;
        chcker.sc_ckr_encontrado = sc_ckr_encontrado;
        chcker.sc_ckr_solicitud = sc_ckr_solicitud;
        chcker.chkr_sb_verificado = chkr_sb_verificado;
        
        fork
        
            begin
                chcker.run();
            end
            begin

                @(posedge _if.clk_i);
                transaccion_monitor.dato_recibido = 32'd2;
                transaccion_monitor.t_recibido = $time;
                transaccion_monitor.terminal_recibido = 1;
                mon_ckcr_mbx.put(transaccion_monitor);

                @(posedge _if.clk_i);
                transaccion_encontrada.terminal_envio = 0;
                transaccion_encontrada.t_envio = $time;
                transaccion_encontrada.dato_enviado = 32'd1;
                sc_ckr_encontrado.put(transaccion_encontrada);

                transaccion_encontrada.terminal_envio = 0;
                transaccion_encontrada.t_envio = $time;
                transaccion_encontrada.dato_enviado = 32'd2;
                sc_ckr_encontrado.put(transaccion_encontrada);

                @(posedge _if.clk_i);
                chkr_sb_verificado.get(transaccion_verificada);
                transaccion_verificada.print();
                

            end

        join_none

    end


endmodule