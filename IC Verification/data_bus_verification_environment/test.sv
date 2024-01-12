class test #(       parameter bits = 1, 
                    parameter drivers = 16,
                    parameter width = 32,
                    parameter broadcast = {8{1'b1}},
                    parameter profundidad = 16
                    );
                    

//Definición de los mailboxes
test_agente_mbx test_agnt_mbx;
test_sb_mbx test_sb_mbx;

//Definición de instrucciones
instrucciones_agente instr_agnt;
instrucciones_test_sb instr_test_sb;


//Definición del ambiente de prueba
ambiente #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast), .profundidad(profundidad)) ambiente_inst;

// Definición de la variable virtual
virtual bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) vif;

//Definición de las condiciones iniciales para el test
function new();

//Creación de los mailboxes
test_agnt_mbx = new();
test_sb_mbx = new();

//Creación del ambiente yy conexión de este
ambiente_inst = new();
ambiente_inst.vif = vif;
ambiente_inst.test_sb_mailbox = test_sb_mbx;
ambiente_inst.test_agnt_mbx= test_agnt_mbx;

endfunction

task run();

    $display("[%g] El Test fue inicializado",$time);

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = un_paquete; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente envío de un paquete \n");
    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;    
    

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = un_dispositivo_recibido; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de un_dispositivo_recibido \n");
    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = un_dispositivo_envio; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\n Test: Se envió la primera instrucción al agente de un dispositivo envio\n ");
    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;
      
    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = varios_dispositivos_envio_recibido; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de varios paquetes\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = llenado_fifos; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de llenado_fifos\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = envio_fuera_de_rango; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de envio fuera de rango\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = reset_inicio; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de envio reset inicio\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = reset_mitad; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de envio reset mitad\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;

    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = reset_final; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de envio reset final\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;
    
    disable fork;

    fork begin
        ambiente_inst.run();
    end
    join_none

    #1000;

    instr_agnt = autoenvio; //Envío de la primera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("\nTest: Se envió la primera instrucción al agente de envio autoenvio\n");
    
    
    repeat(10000)begin

        @(posedge vif.clk_i);

    end

    instr_test_sb = reporte; //Asignación de la instrucción al scoreboard
    test_sb_mbx.put(instr_test_sb); //Envío de la instrucción al mailbox del test al scoreboard
    #10;





    $finish;
   
    /*
    instr_agnt = un_dispositivo_recibido; //Envío de la tercera instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la tercera instrucción al agente un solo dispositivo recibe");
    
    repeat(1000)begin

        @(posedge vif.clk_i);

    end
   
    instr_agnt = varios_dispositivos_envio_recibido; //Envío de la cuarta instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la cuarta instrucción al agente varios dispositivos envían y reciben");
   
    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_agnt = llenado_fifos; //Envío de la quinta instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la quinta instrucción al agente llenado de fifos");
    
    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_agnt = envio_fuera_de_rango; //Envío de la sexta instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la sexta instrucción al agente envío fuera de rango");

    repeat(1000)begin

        @(posedge vif.clk_i);

    end
    
    instr_agnt = reset_inicio; //Envío de la séptima instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la séptima instrucción al agente reset al inicio");

    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_agnt = reset_mitad; //Envío de la octava instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la octava instrucción al agente reset a la mitad");

    repeat(1000)begin

        @(posedge vif.clk_i);

    end

    instr_agnt = reset_final; //Envío de la novena instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la novena instrucción al agente reset al final");

    repeat(1000)begin

        @(posedge vif.clk_i);

    end


    instr_agnt = autoenvio; //Envío de la undécima instrucción
    test_agnt_mbx.put(instr_agnt);
    $display("Test: Se envió la undécima instrucción al agente autoenvío");
    
    repeat(1000)begin

        @(posedge vif.clk_i);

    end
    */

 


endtask


endclass
