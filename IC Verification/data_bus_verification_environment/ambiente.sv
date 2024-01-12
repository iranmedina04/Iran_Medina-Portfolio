class ambiente #(

    parameter bits = 1, 
    parameter drivers = 16,
    parameter width = 32,
    parameter broadcast = {8{1'b1}}, 
    parameter profundidad = 16

);
    
    // Interfaz Virtual

    virtual bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) vif;

    //Intancia para el driver

    drv_mon #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast),.profundidad(profundidad)) driv_mon_inst [drivers - 1 : 0];

    trans_bus_mbx #(.width(width), .drivers(drivers)) agent_to_drivers_mbx [drivers - 1 : 0];

    trans_bus_mbx #(.width(width), .drivers(drivers)) mons_to_chckr_mbx;

    //Instancia para el checker


    chkr #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast), .profundidad(profundidad)) chkr_inst;

    trans_bus_mbx #(.width(width), .drivers(drivers)) sc_ckr_solicitud;
    trans_bus_mbx #(.width(width), .drivers(drivers)) sc_ckr_encontrado;
    trans_sb_mbx #(.bits(bits), .drivers(drivers), .width(width), .profundidad(profundidad))  chkr_sb_verificado;

    //Instancia para scoreboard

    score_board #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast), .profundidad(profundidad)) sb_inst;
    trans_bus_mbx #(.width(width), .drivers(drivers)) agnt_sb_mbx;


    //Instancia para el agente 
    agente #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast), .profundidad(profundidad)) agente_inst;

    test_sb_mbx test_sb_mailbox;    
    test_agente_mbx test_agnt_mbx;

    task  run(); //Task para correr el ambiente

        //Inicialización  del checker

        chkr_inst = new();
        mons_to_chckr_mbx = new();
        sc_ckr_encontrado = new();
        sc_ckr_solicitud = new();
        chkr_sb_verificado = new();
        agnt_sb_mbx = new();


        for (int i=0; i < drivers; ++i) begin

            agent_to_drivers_mbx[i] = new();

        end

        chkr_inst.mon_ckcr_mbx = mons_to_chckr_mbx;
        chkr_inst.sc_ckr_encontrado = sc_ckr_encontrado;
        chkr_inst.sc_ckr_solicitud = sc_ckr_solicitud;
        chkr_inst.chkr_sb_verificado = chkr_sb_verificado;

        // Inicialización  del driver

        for (int i=0; i < drivers; ++i) begin

            driv_mon_inst[i] = new(.id(i)); 
            driv_mon_inst[i].agnt_drv_mbx = agent_to_drivers_mbx[i];
            driv_mon_inst[i].mon_ckcr_mbx = mons_to_chckr_mbx;
            driv_mon_inst[i].vif = vif;
        end

        // Inicialización del agente
        agente_inst = new();
        agente_inst.agente_sb_mbx = agnt_sb_mbx;
        agente_inst.test_agente_mbx = test_agnt_mbx;
        agente_inst.vif = vif;
        for (int i=0; i < drivers; ++i)begin
            agente_inst.agente_drv_mbx[i] = agent_to_drivers_mbx[i];
        end


        //Inicialización del Scoreboard

        sb_inst = new();
        sb_inst.vif = vif;
        sb_inst.agnt_sb_mbx = agnt_sb_mbx;
        sb_inst.chkr_sb_solicitud = sc_ckr_solicitud;
        sb_inst.sc_ckr_encontrado = sc_ckr_encontrado;
        sb_inst.chkr_sb_verificado = chkr_sb_verificado;
        sb_inst.test_sb_mailbox = test_sb_mailbox;


        for (int i=0; i < drivers; ++i) begin

            
            fork

            automatic int terminales = i;

             begin

                 driv_mon_inst[terminales].run(); 

             end

            join_none

            
        end

        //Inicialización del Checker, Scoreboard y agente

        fork 
            begin
        
                chkr_inst.run();
           

            end
            begin

                sb_inst.run();

            end
            begin

                agente_inst.run();

            end    

        join_none

        $display("Se inicializaron correctamente");


        //Corridas

        
    endtask 
    

endclass 