class chkr #(   parameter bits = 1, 
                parameter drivers = 16,
                parameter width = 32,
                parameter broadcast = {8{1'b1}}, 
                parameter profundidad = 16 );

    trans_bus #(.width(width), .drivers(drivers)) transaccion_monitor;
    trans_bus #(.width(width), .drivers(drivers)) transaccion_monitori;
    trans_bus #(.width(width), .drivers(drivers)) transaccion_encontrada; 
    trans_sb #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) transaccion_verificada;
    trans_bus_mbx #(.width(width), .drivers(drivers)) mon_ckcr_mbx;
    trans_bus_mbx #(.width(width), .drivers(drivers)) sc_ckr_solicitud;
    trans_bus_mbx #(.width(width), .drivers(drivers)) sc_ckr_encontrado;
    trans_sb_mbx #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) chkr_sb_verificado;
    int contador;

    task run();
        

        $display("Se inicializó el chcker");

        forever begin
            
            #1;
            if (mon_ckcr_mbx.num() > 0) 
                begin

                //$display("Si me llegaron transacciones del monitor");

                mon_ckcr_mbx.get(transaccion_monitor);
                transaccion_monitori = new();
                transaccion_monitori = transaccion_monitor;
                sc_ckr_solicitud.put(transaccion_monitori);
                
                #1;

                if(sc_ckr_encontrado.num() > 0)begin
                
                    //$display("Si me llegaron transacciones encontradas");
                    while ( 0 < sc_ckr_encontrado.num()) begin

                        //$display("Revision transaccion");
                        transaccion_encontrada = new();
                        //$display("Transaccion encontrada llegada al checker antes del get [%g]", $time);
                        sc_ckr_encontrado.get(transaccion_encontrada);
                        //$display("Transaccion monitor");
                        //transaccion_monitor.print();
    
                        if (transaccion_monitor.dato_recibido == transaccion_encontrada.dato_enviado) begin
                            if (transaccion_monitor.t_recibido > transaccion_encontrada.t_envio) begin
                                
                            //$display("Mae hubo un match");
                            transaccion_verificada = new();
                            transaccion_verificada.pckg = transaccion_monitor.dato_recibido;
                            transaccion_verificada.t_envio = transaccion_encontrada.t_envio;
                            transaccion_verificada.t_recibido = transaccion_monitor.t_recibido;
                            transaccion_verificada.terminal_envio = transaccion_encontrada.terminal_envio;
                            transaccion_verificada.terminal_recibido = transaccion_monitor.terminal_recibido;
                            transaccion_verificada.cal_latencia();
                            chkr_sb_verificado.put(transaccion_verificada);

                            end

                        end
                        
                        
                    end 

                end
            end
        end
       
        
    endtask
  


    
endclass