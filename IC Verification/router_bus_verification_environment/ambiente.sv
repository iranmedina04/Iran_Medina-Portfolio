/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al ambiente. En este se reaaliza la unión del driver, el monitor, el monitor interno, 
////// el checker, el agente, y el scoreboard
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ambiente #(

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

    // Modulos que se utilizarán en el ambiente

    driver #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) my_drivers [15 :0];

    monitor #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH) ) my_monitors [15 :0];

    monitor_interno #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH) ) my_monitor_intern;

    chcker #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) my_chcker;

    agente #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) my_agente;

    score_board #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) my_sb;

    // Mailboxes de agentes a drivers

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) agent_to_drivers_mbx [15 : 0];

    // Mailboxes de monitor al chcker

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) monitor_to_checker_mbx; //

    // Mailboxes monitor interno 

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) transaccion_monitor_interno_mbx; //

    // Checker

    // Mailboxes de la solicitud del chcker
    
    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_final_mbx; //
    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_interna_mbx; //

    // Mailboxes de la respuesta del chker

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_final_respuesta_final_mbx; //
    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_sb_slocitud_interna_respuesta_mbx; //

    // Mailboces de la transaccion completada del chcker

    trans_sb_mbx #(.ROWS(ROWS), .COLUMS(COLUMNS), .pckg_sz(PAKG_SIZE), .fifo_depth(FIFO_DEPTH), .bdcst({8{1'b1}})) trans_sb_mbx;

    //Agente

    test_agente_mbx test_agente_mbx;

    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) agente_sb_mbx;

    // Scoreboard 

    test_sb_mbx  test_sb_mailbox;
    test_sb_mbx  test_sb_mailbox2;

    instrucciones_test_sb instr_test_sb;

    // Funcion new donde se inicializan las cosas y se conectan los mailboxes

    function new();
        
        monitor_to_checker_mbx = new(); //
        transaccion_monitor_interno_mbx = new(); //
        mon_sb_slocitud_final_mbx = new(); //
        mon_sb_slocitud_interna_mbx = new(); //
        mon_sb_slocitud_final_respuesta_final_mbx = new(); //
        mon_sb_slocitud_interna_respuesta_mbx = new(); //
        trans_sb_mbx = new();
        agente_sb_mbx = new();


        for (int i=0; i<16; ++i) begin
            
            agent_to_drivers_mbx[i] = new();

        end

        my_monitor_intern = new();
        my_chcker = new();
        my_agente = new();
        my_sb = new();

        for (int i=0; i<16; ++i) begin
            
            my_drivers[i] = new(.id(i));
            my_monitors[i] = new(.id(i));

        end

        // Conexiones del driver y monitor 

        for (int i=0; i<16; ++i) begin
            
            my_drivers[i].agnt_drv_mbx = agent_to_drivers_mbx[i];
            my_monitors[i].mon_chckr_mbx =  monitor_to_checker_mbx;
            my_drivers[i].vif = vif;
            my_monitors[i].vif = vif;

        end

        test_sb_mailbox2 = new();


        // Conexiones del checker

        my_chcker.mon_chckr_mbx = monitor_to_checker_mbx;
        my_chcker.transaccion_monitor_interno_mbx = transaccion_monitor_interno_mbx;
        my_chcker.mon_sb_slocitud_final_mbx = mon_sb_slocitud_final_mbx;
        my_chcker.mon_sb_slocitud_interna_mbx = mon_sb_slocitud_interna_mbx ;
        my_chcker.mon_sb_slocitud_final_respuesta_final_mbx = mon_sb_slocitud_final_respuesta_final_mbx;
        my_chcker.mon_sb_slocitud_interna_respuesta_mbx = mon_sb_slocitud_interna_respuesta_mbx;
        my_chcker.trans_sb_mbx = trans_sb_mbx;


        // Conexion de Scoreboard

        my_sb.agnt_sb_mbx = agente_sb_mbx;
        my_sb.chkr_sb_solicitud = mon_sb_slocitud_final_mbx ;
        my_sb.chkr_sb_solicitud_interna = mon_sb_slocitud_interna_mbx;
        my_sb.sc_ckr_encontrado = mon_sb_slocitud_final_respuesta_final_mbx;
        my_sb.sc_ckr_encontrado2 = mon_sb_slocitud_interna_respuesta_mbx;
        my_sb.chkr_sb_verificado = trans_sb_mbx;


        // Conexion de agente

        my_agente.agente_drv_mbx = agent_to_drivers_mbx;
        my_agente.agente_sb_mbx = agente_sb_mbx;

        

        // Conexion monitor interno

        my_monitor_intern.transaccion_monitor_interno_mbx = transaccion_monitor_interno_mbx;
        

    endfunction

    function  virtualc ();

        my_monitor_intern.vif = vif;
        my_agente.vif = vif;
        my_chcker.vif = vif;

        for (int i=0; i<16; ++i) begin
            
            my_drivers[i].vif = vif;
            my_monitors[i].vif = vif;

        end
        
    endfunction

    task  run();

        test_sb_mailbox = new();
        my_agente.test_agente_mbx = test_agente_mbx;
        my_sb.test_sb_mailbox = test_sb_mailbox;

        for (int i=0; i < 16; ++i) begin

            fork

                automatic int terminales = i;

                begin

                    my_drivers[terminales].run();


                end  

                begin

                    my_monitors[terminales].run();

                end
  
            join_none
        end

       fork

            my_monitor_intern.run();
            my_chcker.run();
            my_sb.run();
            my_agente.run();
            
        join_none
        forever begin
            
            #1;

           
        if(test_sb_mailbox2.num() > 0) begin
                
                $display("Se cumplio el tiempo maximo de la prueba");
                test_sb_mailbox2.get(instr_test_sb);
                test_sb_mailbox.put(instr_test_sb);
                @(posedge vif.clk_i);

            end

        end
        
    endtask


endclass