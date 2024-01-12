//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo posee el test donde este se encarga de enviar cada una de las transacciones al agente  y
////// además aquí se realiza la instancia del ambiente, donde este recibe la instrucción para iniciar desde el testbench
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class test #(       parameter ROWS = 4, 
                    parameter COLUMNS = 4,
                    parameter PAKG_SIZE = 32,
                    parameter FIFO_DEPTH = 16);

    ambiente #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) my_ambiente;

    coverage #(.PAKG_SIZE(PAKG_SIZE)) cobertura;

    instrucciones_agente instrucciones_agente;

    virtual mesh_if #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) vif;

    test_agente_mbx test_agente_mbx;
    test_sb_mbx  test_sb_mailbox2;
    instrucciones_test_sb instr_al_sb;

    task run();

      
        my_ambiente = new();
        my_ambiente.vif = vif;
        test_agente_mbx = new();
        cobertura = new();
        my_ambiente.test_agente_mbx = test_agente_mbx;
        my_ambiente.virtualc();
        test_sb_mailbox2 = new();
        $display("Corriendo prueba de un paquete");
        fork
            
            my_ambiente.run();
            cobertura.run();

        join_none

        repeat (10) begin
        
            @(posedge vif.clk_i);
        
        end

        instrucciones_agente = un_paquete;
        test_agente_mbx.put(instrucciones_agente);

        repeat (10000) begin
        
            @(posedge vif.clk_i);
        
        end

        my_ambiente.test_sb_mailbox2 = test_sb_mailbox2;
        instr_al_sb = reporte;
        test_sb_mailbox2.put(instr_al_sb);

        disable fork;
        $display("Corriendo prueba de un varios paquetes");
        
        fork
            
            my_ambiente.run();
            cobertura.run();

        join_none

        repeat (10) begin
        
            @(posedge vif.clk_i);
        
        end
        

        instrucciones_agente = varios_dispositivos_envio_recibido;
        test_agente_mbx.put(instrucciones_agente);

        repeat (10000) begin
        
            @(posedge vif.clk_i);
        
        end

        my_ambiente.test_sb_mailbox2 = test_sb_mailbox2;
        instr_al_sb = reporte;
        test_sb_mailbox2.put(instr_al_sb);

        disable fork;
        #10;

        $display("Corriendo prueba de un varios Llenado fifos");

        fork
            
            my_ambiente.run();
            cobertura.run();

        join_none

        repeat (10) begin
        
            @(posedge vif.clk_i);
        
        end

        instrucciones_agente = varios_dispositivos_envio_recibido;
        test_agente_mbx.put(instrucciones_agente);

        repeat (10000) begin
        
            @(posedge vif.clk_i);
        
        end

        my_ambiente.test_sb_mailbox2 = test_sb_mailbox2;
        instr_al_sb = reporte;
        test_sb_mailbox2.put(instr_al_sb);

        disable fork;
        #10;
        $display("Corriendo prueba de un varios Reset inicio");
        fork
            
            my_ambiente.run();
            cobertura.run();

        join_none

        repeat (10) begin
        
            @(posedge vif.clk_i);
        
        end

        instrucciones_agente = varios_dispositivos_envio_recibido;
        test_agente_mbx.put(instrucciones_agente);

        repeat (10000) begin
        
            @(posedge vif.clk_i);
        
        end

        my_ambiente.test_sb_mailbox2 = test_sb_mailbox2;
        instr_al_sb = reporte;
        test_sb_mailbox2.put(instr_al_sb);

        disable fork;
        #10;

        $display("Corriendo prueba de Reset en medio");

        fork
            
            my_ambiente.run();
            cobertura.run();

        join_none

        repeat (10) begin
        
            @(posedge vif.clk_i);
        
        end

        instrucciones_agente = varios_dispositivos_envio_recibido;
        test_agente_mbx.put(instrucciones_agente);

        repeat (10000) begin
        
            @(posedge vif.clk_i);
        
        end

        my_ambiente.test_sb_mailbox2 = test_sb_mailbox2;
        instr_al_sb = reporte;
        test_sb_mailbox2.put(instr_al_sb);

        disable fork;
        #10;
        $display("Corriendo prueba de Reset final");
        fork
            
            my_ambiente.run();
            cobertura.run();

        join_none

        repeat (10) begin
        
            @(posedge vif.clk_i);
        
        end



        instrucciones_agente = varios_dispositivos_envio_recibido;
        test_agente_mbx.put(instrucciones_agente);

        repeat (10000) begin
        
            @(posedge vif.clk_i);
        
        end

        my_ambiente.test_sb_mailbox2 = test_sb_mailbox2;
        instr_al_sb = reporte;
        test_sb_mailbox2.put(instr_al_sb);

        disable fork;
        #10;
    
        cobertura.print_cobertura();
        $finish;


    endtask




endclass