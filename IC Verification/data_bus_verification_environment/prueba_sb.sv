`timescale 10ns/1ps
`include "interfaces_transacciones.sv"
`include "scoreboard.sv"
`default_nettype none

module prueba_sb();

    reg clk = 0;
    parameter bits = 1;
    parameter drivers = 2;
    parameter width = 32;
    parameter broadcast = {8{1'b1}};
    parameter profundidad = 16;

    bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) _if (.clk_i(clk));
    always #5 clk = ~clk;

    score_board #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast), .profundidad(profundidad)) sb;
 
    trans_bus_mbx agnt_sb_mbx;
    trans_bus_mbx chkr_sb_solicitud;
    trans_bus_mbx sc_ckr_encontrado;
    trans_sb_mbx chkr_sb_verificado;
    test_sb_mbx test_sb_mailbox;

    trans_bus dato_agente;
    trans_bus dato_monitor;
    trans_bus dato_encontrado;
    trans_sb dato_verificado;

    instrucciones_test_sb instruccion_sb;

    initial begin

        sb = new();
        agnt_sb_mbx = new();
        chkr_sb_solicitud = new();
        sc_ckr_encontrado = new();
        chkr_sb_verificado = new();
        test_sb_mailbox = new();


        dato_agente = new();
        dato_monitor = new();
        dato_verificado = new();

        sb.vif = _if;
        sb.agnt_sb_mbx = agnt_sb_mbx;
        sb.chkr_sb_solicitud = chkr_sb_solicitud;
        sb.sc_ckr_encontrado = sc_ckr_encontrado;
        sb.chkr_sb_verificado = chkr_sb_verificado;
        sb.test_sb_mailbox = test_sb_mailbox;
        
        fork
            begin
                
                
                sb.run();

            end
            begin

                repeat(5) begin
                   
                    @(posedge _if.clk_i);
                
                end
                dato_agente = new();                
                dato_agente.dato_enviado = 32'h02000001;
                dato_agente.t_envio = $time;
                agnt_sb_mbx.put(dato_agente);
                
                repeat(5) begin
                   
                    @(posedge _if.clk_i);
                
                end
                repeat(5) begin
                   
                    @(posedge _if.clk_i);
                
                end

                dato_agente = new();
                dato_agente.dato_enviado = 32'h02000002;
                dato_agente.t_envio = $time;
                agnt_sb_mbx.put(dato_agente);
                
                repeat(5) begin
                   
                    @(posedge _if.clk_i);
                
                end

                dato_agente = new();
                dato_monitor.dato_recibido = 32'h02000001;
                dato_monitor.t_recibido = $time;

                chkr_sb_solicitud.put(dato_monitor);

                sc_ckr_encontrado.get(dato_encontrado);
                dato_encontrado.print();
                

                dato_verificado.t_envio = 1;
                dato_verificado.t_recibido = 2;
                dato_verificado.latencia = 3; 
                chkr_sb_verificado.put(dato_verificado);
                
                dato_verificado.t_envio = 1;
                dato_verificado.t_recibido = 3; 
                dato_verificado.latencia = 4;
                chkr_sb_verificado.put(dato_verificado);


                @(posedge _if.clk_i);
                
                instruccion_sb = reporte;
                test_sb_mailbox.put(instruccion_sb);
              
            
                

                
            end
            
        join_none
    end

endmodule