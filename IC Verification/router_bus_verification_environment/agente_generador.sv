/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo posee el agente donde se pueden encontrar las transacciones de uso común del dispositivo  
////// al igual que la implementación de los casos de esquina las cuales serán enviadas al driver
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class agente #(     parameter ROWS = 4, 
                    parameter COLUMNS = 4,
                    parameter PAKG_SIZE = 32,
                    parameter FIFO_DEPTH = 16);

    // Definición de la variable virtual


    // Mailboxes  
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) agente_drv_mbx[15:0];
    trans_mbx  #(.PAKG_SIZE(PAKG_SIZE)) agente_sb_mbx;
    test_agente_mbx test_agente_mbx;
    virtual mesh_if #(.ROWS(ROWS), .COLUMNS(COLUMNS), .PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) vif;


    //Transacción 
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion;
    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_copia;

    
    int num_transacciones; //Número de transacciones a realizar
    int espera; //Espera para cumplir con el retardo
    logic [3:0] ROW;
    logic [3:0] COLUMN;
    
    //Instrucción
    instrucciones_agente instruccion;
    

    task run;
      $display("Agente run \n");
     
      @(posedge vif.clk_i);
      @(posedge vif.clk_i);
      
        forever begin
            #1
            if (test_agente_mbx.num() > 0)begin //Verifica si hay algo en el mailbox del test al agente
                //$display("[%g] El agente fue inicializado",$time);
                test_agente_mbx.get(instruccion); //Se obtiene la instrucción del mailbox del test al agente
                case (instruccion)
                   
                    un_paquete: begin //Caso en el que se envía un solo paquete aleatorio desde cualquier dispositivo hacia cualquier otro dispositivo
                            
                            //$display("Un paquete");
                            espera = 0;
                            transaccion = new();
                            transaccion.randomize(); //Vuelve aleatorios los valores de la transacción
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin //Hace el retardo antes del envío
                              @(posedge vif.clk_i)
                                espera = espera + 1;
                            end
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al mailbox del agente al driver en la posición de la terminal de envío
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia); //Envía la transacción al mailbox del agente al scoreboard
                        
                    end
                 
                    varios_dispositivos_envio_recibido: begin //Caso en el que se envían varios paquetes aleatorios desde cualquier dispositivo hacia cualquier otro dispositivo
                      
                      num_transacciones = $urandom_range(1, 32); //Define un número aleatorio de transacciones 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new();
                            transaccion.randomize();
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                    end

                    llenado_fifos: begin //Caso en el que se llenan las FIFOS de todos los drivers disponibles
                        
                        for(int i = 0; i < 16 ; i++)begin //For para recorrer todas las filas disponibles
                            for (int j = 0; j < FIFO_DEPTH; j++)begin//For para llenar una por una las FIFOS
                              transaccion = new();
                              transaccion.randomize(); //Vuelve aleatorios los valores de la transacción
                              transaccion.fun_pckg;
                              transaccion.tiempo_envio  = $time;
                              agente_drv_mbx[i].put(transaccion); //Envía la transacción al mailbox del agente al driver en la posición de la terminal de envío
                              transaccion_copia = new();
                              transaccion_copia = transaccion;
                              agente_sb_mbx.put(transaccion_copia);
                            end
                        end
                    end

                    envio_fuera_de_rango: begin //Caso de esquina en el que se envían transacciones a una dirección fuera del rango de terminales existentes
                      num_transacciones = $urandom_range(1,FIFO_DEPTH); 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            transaccion.row = $urandom_range(ROWS+1,ROWS +20) ;
                            transaccion.colum = $urandom_range(COLUMNS + 1, COLUMNS +20);
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                    end

                    reset_inicio: begin //Caso de esquina en el que se realiza un reset antes de que se envíe alguna transacción
                      //$display("Si estoy en reset inicio");
                      vif.rst_i = '1;
                      @(posedge vif.clk_i);
                      vif.rst_i = '0;
                      num_transacciones = $urandom_range(1, 32); //Define un número aleatorio de transacciones 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new();
                            transaccion.randomize();
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                    end

                    reset_mitad: begin //Caso de esquina en el que se realiza un reset a la mitad del envío de las transacciones
                      num_transacciones = $urandom_range(1,FIFO_DEPTH); 
                        for(int i = 0; i< num_transacciones/2; i++)begin
                            espera = 0;
                            transaccion = new();
                            transaccion.randomize();
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                        vif.rst_i = '1;
                        @(posedge vif.clk_i);
                        vif.rst_i = '0;
                        
                        for(int i = 0; i< num_transacciones/2; i++)begin
                            espera = 0;
                            transaccion = new();
                            transaccion.randomize();
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end
                    end

                    reset_final: begin  //Caso de esquina en el que se realiza un reset anteal final de que se envían las transacciones
                      
                      num_transacciones = $urandom_range(1,FIFO_DEPTH); 
                        for(int i = 0; i< num_transacciones/2; i++)begin
                            espera = 0;
                            transaccion = new();
                            transaccion.randomize();
                            transaccion.fun_pckg;
                            while (espera < transaccion.tiempo_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            
                            transaccion.tiempo_envio  = $time;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end
                      vif.rst_i = '1;
                      @(posedge vif.clk_i);
                      vif.rst_i = '0;
                    end

                endcase
        end
    end
    endtask
endclass