/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al checker. Este comprueba que lo que recibe desde el monitor y lo que llega desde
////// el scoreboard coincida.
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class chcker #(

    parameter ROWS = 4,
    parameter COLUMNS = 4,  
    parameter PAKG_SIZE = 32,
    parameter FIFO_DEPTH = 16

);

    virtual mesh_if #(

        .ROWS(ROWS),
        .COLUMNS(COLUMNS),
        .PAKG_SIZE(PAKG_SIZE),
        .FIFO_DEPTH(FIFO_DEPTH) 
    
    ) vif;

    int match;

    // Mailbox para las transacciones que vinen de los monitores

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_chckr_mbx;
    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) transaccion_monitor_interno_mbx;

    // Mailboxes para solicitudes 

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_final_mbx;
    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_interna_mbx;

    // Mailboxes para respuestas

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_final_respuesta_final_mbx;
    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_interna_respuesta_mbx;

    
    trans_sb_mbx #(.ROWS(ROWS), .COLUMS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) trans_sb_mbx;

    // Transacciones monitores al checker

    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_mon_chckr_final;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_mon_chckr_intermedio;

    // Transacciones solicitudes

    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_mon_sb_slocitud_final;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_mon_sb_slocitud_interna;

    // Transaccion respuesta

    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_mon_sb_slocitud_final_respuesta_final;
    trans_mesh#(.PAKG_SIZE(PAKG_SIZE)) transaccion_mon_sb_slocitud_interna_respuesta;

    // Transaccion al Scoreboard

    trans_sb #(.ROWS(ROWS), .COLUMS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) trans_sb;

    task run ();
        
        forever begin
            
            #1;

            while (transaccion_monitor_interno_mbx.num() > 0) begin
                
                match = 0;
                transaccion_mon_chckr_intermedio = new();
                transaccion_monitor_interno_mbx.get(transaccion_mon_chckr_intermedio);
                //$display("Transaccion recibida desde el monitor interno");
                //transaccion_mon_chckr_intermedio.print();
                mon_sb_slocitud_interna_mbx.put(transaccion_mon_chckr_intermedio); // Salicita un valor al Scoreboard

                while ( mon_sb_slocitud_interna_respuesta_mbx.num() > 0) begin

                    transaccion_mon_sb_slocitud_interna_respuesta = new();
                    mon_sb_slocitud_interna_respuesta_mbx.get(transaccion_mon_sb_slocitud_interna_respuesta); // Espera la respuestas del Scoreboard
                    
                    // Compara los valores necesarios para saber si es parte del ruta, entonces

                    if (transaccion_mon_sb_slocitud_interna_respuesta.pckg[PAKG_SIZE - 18 : 0] == transaccion_mon_chckr_intermedio.pckg[PAKG_SIZE - 18 : 0] ) begin

                        //$display("Estoy comparando \n");
                        //transaccion_mon_chckr_intermedio.print();
                        //$display("y \n");
                        //transaccion_mon_sb_slocitud_interna_respuesta.print();

                        //$display("");

                        for (int i=0; i< transaccion_mon_sb_slocitud_interna_respuesta.ruta.size(); ++i) begin
                                
                                if( transaccion_mon_sb_slocitud_interna_respuesta.ruta[i] == transaccion_mon_chckr_intermedio.terminal_recibido) begin
                                    
                                    match = match + 1;

                                end 

                            end

                        if(match < 1)
                        begin
                            
                            $display("Error con el paquete: %h, este no debe pasar por la terminal: %h", transaccion_mon_chckr_intermedio.pckg, transaccion_mon_chckr_intermedio.terminal_recibido);
                            transaccion_mon_sb_slocitud_interna_respuesta.print();
                            transaccion_mon_chckr_intermedio.print();

                            $finish; 

                        end
                    
                    end
                end
                
            end

            while (mon_chckr_mbx.num() > 0) begin

                //$display("Mae si recibe una transacción del monitor");
                match = 0;
                transaccion_mon_chckr_final = new();
                mon_chckr_mbx.get(transaccion_mon_chckr_final);
                mon_sb_slocitud_final_mbx.put(transaccion_mon_chckr_final);

                while(mon_sb_slocitud_final_respuesta_final_mbx.num() > 0); begin
                    //$display("Espera la respuest del scoreboard");
                    transaccion_mon_sb_slocitud_final_respuesta_final = new();
                    mon_sb_slocitud_final_respuesta_final_mbx.get(transaccion_mon_sb_slocitud_final_respuesta_final);
                    //transaccion_mon_sb_slocitud_final_respuesta_final.print();
                    if (transaccion_mon_sb_slocitud_final_respuesta_final.pckg[PAKG_SIZE - 18 : 0] == transaccion_mon_chckr_final.pckg[PAKG_SIZE - 18 : 0]) begin
                        if (transaccion_mon_sb_slocitud_final_respuesta_final.tiempo_envio <= transaccion_mon_chckr_final.tiempo_recibido) begin
                            
                            match = match + 1;
                            trans_sb = new();
                            trans_sb.pckg = transaccion_mon_sb_slocitud_final_respuesta_final.pckg;
                            trans_sb.terminal_envio = transaccion_mon_sb_slocitud_final_respuesta_final.terminal_envio;
                            trans_sb.terminal_recibido = transaccion_mon_chckr_final.terminal_recibido;
                            trans_sb.tiempo_envio = transaccion_mon_sb_slocitud_final_respuesta_final.tiempo_envio;
                            trans_sb.tiempo_recibido = transaccion_mon_chckr_final.tiempo_recibido;
                            trans_sb.cal_latencia();
                            trans_sb_mbx.put(trans_sb);

                        end

                    end


                end

                if(match < 1)
                        begin
                            
                            $display("Error con el paquete: %h, este no debe llegar a la terminal: %h", transaccion_mon_chckr_final.pckg, transaccion_mon_chckr_final.terminal_recibido);
                            $finish; 

                        end

            end




        end

    endtask

endclass