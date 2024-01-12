/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al scoreboard. Este alamcena todos las transacciones realizadas. .
////// Además, será el encargado de calcular la ruta que cada paquete segurá, así como de realizar los reportes de 
////// de las transacciones realizadas, tiempo promedio, y ancho de banda.
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class score_board #(    parameter ROWS = 4, 
                        parameter COLUMNS = 4,
                        parameter PAKG_SIZE = 32,
                        parameter FIFO_DEPTH = 16);

    // Definición de la variable virtual
    virtual mesh_if #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) vif;

    // Colas donde se guaradaran las transacciones realizadas
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) enviado_agente [$]; // Las realizadas por el agente;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) recibido_monitor [$]; // Las realizadas por el monitor;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) recibido_monitor_interno [$]; // Las realizadas por el monitor interno;
    trans_sb #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) verificadas [$];  // Las revisadas y realizadas correctamente

    // Mailbox donde se van a comunicar con el agente y el chkr
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) agnt_sb_mbx;
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) chkr_sb_solicitud;
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) chkr_sb_solicitud_interna;
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) sc_ckr_encontrado;
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) sc_ckr_encontrado2;

    trans_sb_mbx #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) chkr_sb_verificado;
    test_sb_mbx  test_sb_mailbox;

    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_agente; // Las realizadas por el agente;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_monitor; // Las realizadas por el monitor;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_monitor2; // Las realizadas por el monitor
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_monitor_interno; // Las realizadas por el agente;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_comparar; // Las realizadas por el monitor;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_viejo; // Las realizadas por el monitor;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) dato_viejo2; // Las realizadas por el monitor;

    trans_sb #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) dato_verificado;
    trans_sb #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) transaccion_auxiliar;  // Las revisadas y realizadas correctamente

    instrucciones_test_sb transaccion_test;

    int paquetes_encontrados;
    int paquetes_encontrados2;
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

        $display("Scoreboard run\n");
        bw = 0;
        tpromedio = 0;

        forever begin
            
        #1;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Logica para el reporte
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        while (test_sb_mailbox.num() > 0) begin
            
            //$display("Se recibio una transaccion de reporte desde el test");

            test_sb_mailbox.get(transaccion_test);

            if (transaccion_test == reporte) begin
                
                //$display("Se imprimirá el reporte");
                tiempo = 0;
                linea = "";
                linea_agregar = "";
                informacion = {};
                for (int i=0; i < verificadas.size(); ++i) begin
                            
                            
                    transaccion_auxiliar = new();
                    transaccion_auxiliar = verificadas[i];
                    tiempo = tiempo + transaccion_auxiliar.latencia;
                            
                    $sformat(linea_agregar, "%h,%g,%g,%g,%g,%g,%g\n", 
                           
                        transaccion_auxiliar.pckg,
                        transaccion_auxiliar.tiempo_envio,
                        transaccion_auxiliar.tiempo_recibido,
                        transaccion_auxiliar.terminal_envio,
                        transaccion_auxiliar.terminal_recibido,
                        transaccion_auxiliar.latencia,
                        FIFO_DEPTH   
                                    
                    );

                    informacion.push_back(linea_agregar);
            
                end

                archivo_1 = $fopen("Reporte_transacciones.csv", "a" );
                        
                for (int i=0; i<informacion.size(); ++i) begin

                    $fwrite(archivo_1, "%s", informacion[i]);
                            
                end
                        
                $fclose(archivo_1);

                tpromedio = tiempo / verificadas.size();

                bw =  PAKG_SIZE * 10e9 / (tpromedio);  

                archivo_2 = $fopen("Reporte_Anchos_de_banda_Tiempo_promedio.csv", "a" );

                $sformat (linea, "\n%g,%g,%g,%g,%g,%g", ROWS, COLUMNS, FIFO_DEPTH, PAKG_SIZE, tpromedio, bw);
                            
                $fwrite(archivo_2, "%s", linea);

                $fclose(archivo_2);

                $display("Se imprimió el reporte");

            end else begin

               $display("Solicutud del test al scoreboard desconocido");

            end

        end
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Para la solicitudes
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
        while (agnt_sb_mbx.num() > 0) begin
            
            //$display("Mae si me estan llegando transacciones datos del agente");
            dato_agente = new();
            agnt_sb_mbx.get(dato_agente);
            dato_agente.fun_ruta();
            enviado_agente.push_back(dato_agente);

        end  

        while (chkr_sb_solicitud.num() > 0) begin

            paquetes_encontrados = 0;
            dato_monitor = new();
            chkr_sb_solicitud.get(dato_monitor);
            //$display("Mae si me estan llegando transacciones del checker solicitadas, terminal recibido: %h", dato_monitor.terminal_recibido);
                                            
            for (int i=0; i < enviado_agente.size(); ++i) begin
                        
                if(enviado_agente[i].pckg[PAKG_SIZE-18:0] == dato_monitor.pckg[PAKG_SIZE-18:0])begin

                    if(enviado_agente[i].tiempo_envio < dato_monitor.tiempo_recibido)begin
                                    
                        dato_viejo = new();
                        dato_viejo = enviado_agente[i];
                        //$display("Se encontró una concidencia");
                        sc_ckr_encontrado.put(dato_viejo);
                    
                        this.paquetes_encontrados = this.paquetes_encontrados + 1;

                    end
                end

                end     
           
        end

        while (chkr_sb_solicitud_interna.num() > 0) begin

            //$display("Mae si me estan llegando transacciones del checker solicitades 2");
            this.paquetes_encontrados2 = 0;
            dato_monitor2 = new();
            chkr_sb_solicitud_interna.get(dato_monitor2);

                                
                    
            for (int i=0; i < enviado_agente.size(); ++i) begin
                        
                if(enviado_agente[i].pckg[PAKG_SIZE-18:0] == dato_monitor2.pckg[PAKG_SIZE-18:0])begin

                                    
                        dato_viejo2 = new();
                        dato_viejo2 = enviado_agente[i];
                                    
                        //dato_viejo2.fun_ruta();
                        sc_ckr_encontrado2.put(dato_viejo2);
                    
                        this.paquetes_encontrados2 = this.paquetes_encontrados2 + 1;

                end

            end
                            
                    
        end

        while (chkr_sb_verificado.num() > 0) begin

            //$display("Se recibio transaccion verificada");
            dato_verificado = new();
            chkr_sb_verificado.get(dato_verificado);
            verificadas.push_back(dato_verificado);
            //dato_verificado.print();

        end        

        end
    endtask 
    
endclass