class score_board #(
                parameter bits = 1, 
                parameter drivers = 16,
                parameter width = 32,
                parameter broadcast = {8{1'b1}}, 
                parameter profundidad = 16 
);
    
    // Colas donde se guaradaran las transacciones realizadas

    trans_bus #(.width(width), .drivers(drivers)) enviado_agente [$]; // Las realizadas por el agente;
    trans_bus #(.width(width), .drivers(drivers)) recibido_monitor [$]; // Las realizadas por el monitor;
    trans_sb #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) verificadas [$];  // Las revisadas y realizadas correctamente;
    trans_bus #(.width(width), .drivers(drivers)) datos_viejos [$];

    virtual bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) vif;

    // Mailbox donde se van a comunicar con el agente y el chkr

    trans_bus_mbx #(.width(width), .drivers(drivers)) agnt_sb_mbx;
    trans_bus_mbx #(.width(width), .drivers(drivers)) chkr_sb_solicitud;
    trans_bus_mbx #(.width(width), .drivers(drivers)) sc_ckr_encontrado;
    trans_sb_mbx  #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) chkr_sb_verificado;
    test_sb_mbx  test_sb_mailbox;

    trans_bus #(.width(width), .drivers(drivers)) dato_agente;
    trans_bus #(.width(width), .drivers(drivers)) dato_monitor;
    trans_bus #(.width(width), .drivers(drivers)) dato_comparar;
    trans_bus #(.width(width), .drivers(drivers)) dato_viejo;
    

 
    trans_sb #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) dato_verificado;
    trans_sb #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad)) transaccion_auxiliar;

    instrucciones_test_sb transaccion_test;

    int paquetes_encontrados;
    int tiempo;
    int tpromedio;
    int bw;
    string filename;
    string linea;
    string linea_agregar;
    integer archivo_1;
    integer archivo_2;
    string informacion [$];
    int j;



    task run ();

        $display("Se inicializó el scoreboard");
        

        forever begin
            
            // Inicializa los datos 
           #1;
            
            bw = 0; 
            if(test_sb_mailbox.num() > 0)begin

                test_sb_mailbox.get(transaccion_test);
                
                case (transaccion_test)
                    
                    reporte: begin
                        //$display("Mae si era una transacciones de reporte");
                        tiempo = 0;
                        linea = "";
                        linea_agregar = "";
                        informacion = {};
                        

                        for (int i=0; i < verificadas.size(); ++i) begin
                            
                            //$display("[%i]", i );
                            transaccion_auxiliar = new();
                            transaccion_auxiliar = verificadas[i];
                            tiempo = tiempo + transaccion_auxiliar.latencia;
                            /*$display("\n%h,%g,%g,%g,%g,%g,%g,%g", 
                            
                            transaccion_auxiliar.pckg,
                            transaccion_auxiliar.t_envio,
                            transaccion_auxiliar.t_recibido,
                            transaccion_auxiliar.terminal_envio,
                            transaccion_auxiliar.terminal_recibido,
                            transaccion_auxiliar.latencia,
                            transaccion_auxiliar.prof, 
                            transaccion_auxiliar.drv);*/

                            $sformat(linea_agregar, "%h,%g,%g,%g,%g,%g,%g,%g\n", 
                            
                            transaccion_auxiliar.pckg,
                            transaccion_auxiliar.t_envio,
                            transaccion_auxiliar.t_recibido,
                            transaccion_auxiliar.terminal_envio,
                            transaccion_auxiliar.terminal_recibido,
                            transaccion_auxiliar.latencia,
                            transaccion_auxiliar.prof, 
                            transaccion_auxiliar.drv
                                                
                            );

                            informacion.push_back(linea_agregar);

                            

                        end

                        archivo_1 = $fopen("Reporte_transacciones.csv", "a" );
                        
                        for (int i=0; i<informacion.size(); ++i) begin

                            $fwrite(archivo_1, "%s", informacion[i]);
                            
                        end
                        
                        $fclose(archivo_1);

                        tpromedio = tiempo / verificadas.size();

                        bw = width * 10e9 / (tpromedio);                       
                        

                        $display("Para una prueba con Terminales: [%g], Profundidad: [%g], Ancho de palabra: [%g], Tiempo promedio: [%g], Ancho de banda: [%g] \n Se imprimió el reporte", drivers, profundidad, width, tpromedio, bw );

                        archivo_2 = $fopen("Reporte_Anchos_de_banda_Tiempo_promedio.csv", "a" );

                        $sformat (linea, "\n%g,%g,%g,%g,%g", drivers, profundidad, width, tpromedio, bw);
                        
                        $fwrite(archivo_2, "%s", linea);

                        $fclose(archivo_2);

                    
                    end

                    default: begin
                       
                        $display("No se recibio ninguna instrucción de reporte valida desde el test");

                    end
                endcase


            end
            else
            begin
            if (agnt_sb_mbx.num() > 0) begin

                 dato_agente = new();
                 agnt_sb_mbx.get(dato_agente);
                 enviado_agente.push_back(dato_agente);

            end
            if (chkr_sb_solicitud.num() > 0) begin

                this.paquetes_encontrados = 0;
                dato_monitor = new();
                chkr_sb_solicitud.get(dato_monitor);
                //$display("Para el dato recibido [%g]", $time);
                //dato_monitor.print();              
                
                for (int i=0; i < enviado_agente.size(); ++i) begin
                    
                    if(enviado_agente[i].dato_enviado == dato_monitor.dato_recibido)begin
                        if (enviado_agente[i].dato_enviado[width - 1: width - 8] == dato_monitor.terminal_recibido) begin
                            if(enviado_agente[i].t_envio < dato_monitor.t_recibido)begin
                                
                                //$display("Dato encontrado en el scoreboard [%g]", $time);
                                dato_viejo = new();
                                dato_viejo = enviado_agente[i];
                                //dato_viejo.print();

                                sc_ckr_encontrado.put(dato_viejo);
                                //$display("Dato que encontre: ");
                                //dato_viejo.print();
                                this.paquetes_encontrados = this.paquetes_encontrados + 1;

                            end
                    end
                end
                end
                         
                
                if (paquetes_encontrados == 0) begin
                    
                    $display("Error: No encontre ninguna transaccion anterior con ese valor");
                    dato_monitor.print();
                    $finish;

                end
                
            end
            if (chkr_sb_verificado.num() > 0) begin

                dato_verificado = new();
                chkr_sb_verificado.get(dato_verificado);
                verificadas.push_back(dato_verificado);

            end
            
            end
        end   
    endtask 
endclass