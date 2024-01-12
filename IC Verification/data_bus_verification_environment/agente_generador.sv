class agente #(     parameter bits = 1, 
                    parameter drivers = 16,
                    parameter width = 32,
                    parameter broadcast = {8{1'b1}},
                    parameter profundidad = 16);

    // Definición de la variable virtual
    virtual bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) vif;

    // Mailboxes    
    trans_bus_mbx #(.width(width), .drivers(drivers)) agente_drv_mbx[drivers-1:0];
    trans_bus_mbx #(.width(width), .drivers(drivers)) agente_sb_mbx;
    test_agente_mbx test_agente_mbx;

    //Transacción 
    trans_bus #(.width(width), .drivers(drivers)) transaccion;
    trans_bus #(.width(width), .drivers(drivers)) transaccion_copia;
    trans_bus #(.width(width), .drivers(drivers)) transaccion_en;

    int t_retardo; //Tiempo de retardo
    int t_envio;  //Tiempo de envío
    int num_transacciones; //Número de transacciones a realizar
    rand int terminal_envio; //Terminal desde donde se envía
    int terminal_recibido;  //Terminal que recibe el dato enviado
    tipo_trans tpo_spec; //Tipo de transacción a realizar
    logic [width - 1 : 0] dato_enviado; //Dato que se va a enviar
    int espera; //Espera para cumplir con el retardo
    logic [7:0]  direccion; //Dirección del dispositivo que va a recibir el dato
    logic [3:0]  identificador; //Dirección del dispositivo que envía  
    logic [width - 13 : 0] dato; //Dato enviado 

    //Instrucción
    instrucciones_agente instruccion;
    
   

    task run;
      $display("[%g] El agente fue inicializado",$time);

        @(posedge vif.clk_i);
        @(posedge vif.clk_i);
        
        forever begin
            #1
            if (test_agente_mbx.num() > 0)begin //Verifica si hay algo en el mailbox del test al agente
                
                $display("[%g] El agente fue inicializado",$time);
                
                test_agente_mbx.get(instruccion); //Se obtiene la instrucción del mailbox del test al agengte
               
                case (instruccion)
                   
                    un_paquete: begin //Caso en el que se envía un solo paquete aleatorio desde cualquier dispositivo hacia cualquier otro dispositivo
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize(); //Vuelve aleatorios los valores de la transacción
                            direccion = $urandom_range(0,drivers-1);
                            identificador = transaccion.terminal_envio;
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};//Concatena el valor de la dirección, el dato y el identificador
                            transaccion.dato_enviado = dato_enviado;
                          
                            while (espera < transaccion.t_retardo) begin //Hace el retardo antes del envío
                              @(posedge vif.clk_i)
                                espera = espera + 1;
                            end
                           
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar; //Define el tipo específico 
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al mailbox del agente al driver en la posición de la terminal de envío
                            agente_sb_mbx.put(transaccion); //Envía la transacción al mailbox del agente al scoreboard
                        
                    end

                  un_dispositivo_envio: begin //Caso en el que se envían varios paquetes aleatorios desde un único dispositivo hacia cualquier otro dispositivo
                            identificador = $urandom_range(0,drivers-1); //Define cual dispositivo es al que va a enviar siempre
                            num_transacciones = $urandom_range( 1, profundidad); //Define un número aleatorio de transacciones 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            direccion = $urandom_range(0,drivers-1);
                            transaccion.terminal_envio = identificador; //Asigna a la terminal de envío el identificador definido anteriormente
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};
                            transaccion.dato_enviado = dato_enviado;
                            while (espera < transaccion.t_retardo) begin
                               @(posedge vif.clk_i);
                                espera = espera + 1;
                            end
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar;
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                    end 

                  un_dispositivo_recibido: begin //Caso en el que se envían varios paquetes aleatorios desde cualquier dispositivo hacia un único dispositivo
                        
                        direccion = $urandom_range(0,drivers-1); //Define a cuál dispositivo es al que siempre se le van a enviar los datos
                        num_transacciones = $urandom_range(1,profundidad); //Define un número aleatorio de transacciones 
                        
                        for(int i = 0; i< num_transacciones; i++)begin
                          espera = 0;
                          transaccion = new();
                          transaccion.randomize(); //Vuelve aleatorios los valores de la transacción
                          identificador = $urandom_range(0,drivers-1);;
                          dato = $random;
                          dato_enviado = {direccion,dato,identificador};//Concatena el valor de la dirección, el dato y el identificador
                          transaccion.dato_enviado = dato_enviado;
                          while (espera < transaccion.t_retardo) begin //Hace el retardo antes del envío
                            @(posedge vif.clk_i)
                              espera = espera + 1;
                          end
                          transaccion.t_envio  = $time;
                          tpo_spec = enviar; //Define el tipo específico 
                          transaccion.tipo = tpo_spec;
                          agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al mailbox del agente al driver en la posición de la terminal de envío
                          transaccion_copia = new();
                          transaccion_copia = transaccion;
                          agente_sb_mbx.put(transaccion_copia); //Envía la transacción al mailbox del agente al scoreboard
                      
                        end

                    end 

                    varios_dispositivos_envio_recibido: begin //Caso en el que se envían varios paquetes aleatorios desde cualquier dispositivo hacia cualquier otro dispositivo
                      
                       //Define a cuál dispositivo es al que siempre se le van a enviar los datos
                        num_transacciones = $urandom_range(0,65); //Define un número aleatorio de transacciones 
                        
                        for(int i = 0; i < num_transacciones; i++)begin
                          
                          direccion = $urandom_range(0,drivers-1);
                          espera = 0;
                          transaccion = new();
                          transaccion.randomize(); //Vuelve aleatorios los valores de la transacción
                          identificador = $urandom_range(0,drivers-1);;
                          dato = $random;
                          dato_enviado = {direccion,dato,identificador};//Concatena el valor de la dirección, el dato y el identificador
                          transaccion.dato_enviado = dato_enviado;
                          
                          while (espera < transaccion.t_retardo) begin //Hace el retardo antes del envío
                          
                            @(posedge vif.clk_i)
                              espera = espera + 1;
                          
                          end

                          transaccion.t_envio  = $time;
                          tpo_spec = enviar; //Define el tipo específico 
                          transaccion.tipo = tpo_spec;
                          //$display("Transaccion enviada por el agente [%g]", i);
                          //transaccion.print();
                          agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al mailbox del agente al driver en la posición de la terminal de envío
                          transaccion_copia = new();
                          transaccion_copia = transaccion;
                          agente_sb_mbx.put(transaccion_copia); //Envía la transacción al mailbox del agente al scoreboard

                        end


                    end 

                    llenado_fifos: begin //Caso en el que se llenan las FIFOS de todos los drivers disponibles
      
                        for(int i = 0; i < drivers; i++)begin //For para recorrer todos los drivers disponibles
                            for (int j = 0; j < profundidad; j++)begin//For para llenar una por una las FIFOS
                              
                              transaccion = new;
                              transaccion.randomize(); //Vuelve aleatorios los valores de la transacción
                              direccion = $urandom_range(0,drivers-1);
                              identificador = transaccion.terminal_envio;
                              dato = $random;
                              dato_enviado = {direccion,dato,identificador};//Concatena el valor de la dirección, el dato y el identificador
                              transaccion.dato_enviado = dato_enviado;
                              transaccion.t_envio  = $time;
                              tpo_spec = enviar; //Define el tipo específico 
                              transaccion.tipo = tpo_spec;
                              //transaccion.print();
                              agente_drv_mbx[i].put(transaccion); //Envía la transacción al mailbox del agente al driver en la posición de la terminal de envío
                              transaccion_copia = new();
                              transaccion_copia = transaccion;
                              agente_sb_mbx.put(transaccion_copia); //Envía la transacción al mailbox del agente al scoreboard
                        
                              
                            end
                        end

                    end

                    envio_fuera_de_rango: begin //Caso de esquina en el que se envían transacciones a una dirección fuera del rango de terminales existentes
                      num_transacciones = $urandom_range(1,profundidad); 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            direccion = $urandom_range(drivers,drivers +20); //Asigna a dirección un valor aleatorio mayor a la cantidad de drivers existentes
                            identificador = $urandom_range(0,drivers-1);
                            transaccion.terminal_envio = identificador;
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};
                            transaccion.dato_enviado = dato_enviado;
                            while (espera < transaccion.t_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar;
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                    end

                    reset_inicio: begin //Caso de esquina en el que se realiza un reset antes de que se envíe alguna transacción
                      transaccion = new; //Crea la transacción
                      tpo_spec = reset; //Define el tipo como reset
                      transaccion.tipo = tpo_spec;
                      identificador = $urandom_range(0,drivers-1); //Define un identificador aleatorio
                      transaccion.terminal_envio = identificador; //Asigna a la terminal de invío el identificar obtenido
                      //transaccion.print();
                      transaccion_copia = new();
                      transaccion_copia = transaccion;
                      agente_sb_mbx.put(transaccion_copia); //Envía la transacción al scoreboard
                      agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al driver correspondiente
                    
                      num_transacciones = $urandom_range(1,profundidad); 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            direccion = $urandom_range(0,drivers-1);
                            identificador = $urandom_range(0,drivers-1);
                            transaccion.terminal_envio = identificador;
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};
                            transaccion.dato_enviado = dato_enviado;
                            while (espera < transaccion.t_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar;
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                    end

                    reset_mitad: begin //Caso de esquina en el que se realiza un reset a la mitad del envío de las transacciones
                      num_transacciones = $urandom_range(1,profundidad); 
                        for(int i = 0; i< num_transacciones/2; i++)begin //Se divide a la mitad las transacciones
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            direccion = $urandom_range(0,drivers-1);
                            identificador = $urandom_range(0,drivers-1);
                            transaccion.terminal_envio = identificador;
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};
                            transaccion.dato_enviado = dato_enviado;
                            while (espera < transaccion.t_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar;
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                        end

                        transaccion = new; //Crea la transacción
                        tpo_spec = reset; //Define el tipo como reset
                        transaccion.tipo = tpo_spec;
                        identificador = $urandom_range(0,drivers-1); //Define un identificador aleatorio
                        transaccion.terminal_envio = identificador; //Asigna a la terminal de invío el identificar obtenido
                        //transaccion.print();
                        agente_sb_mbx.put(transaccion); //Envía la transacción al scoreboard
                        agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al driver correspondiente

                        for(int i = 0; i< num_transacciones/2; i++)begin //Se hace la otra mitad de las transacciones
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            direccion = $urandom_range(0,drivers-1);
                            identificador = $urandom_range(0,drivers-1);
                            transaccion.terminal_envio = identificador;
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};
                            transaccion.dato_enviado = dato_enviado;
                            while (espera < transaccion.t_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar;
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);;
                        end
                    end

                    reset_final: begin  //Caso de esquina en el que se realiza un reset anteal final de que se envían las transacciones
                      
                      num_transacciones = $urandom_range(1,profundidad); 
                        for(int i = 0; i< num_transacciones; i++)begin
                            espera = 0;
                            transaccion = new;
                            transaccion.randomize();
                            direccion = $urandom_range(0,drivers-1);
                            identificador = $urandom_range(0,drivers-1);
                            transaccion.terminal_envio = identificador;
                            dato = $random;
                            dato_enviado = {direccion,dato,identificador};
                            transaccion.dato_enviado = dato_enviado;
                            while (espera < transaccion.t_retardo) begin
                              @(posedge vif.clk_i)
                                espera = espera +1;
                            end
                            transaccion.t_envio  = $time;
                            tpo_spec = enviar;
                            transaccion.tipo = tpo_spec;
                            //transaccion.print();
                            agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                            transaccion_copia = new();
                            transaccion_copia = transaccion;
                            agente_sb_mbx.put(transaccion_copia);
                            
                        end
                      transaccion = new; //Crea la transacción
                      tpo_spec = reset; //Define el tipo como reset
                      transaccion.tipo = tpo_spec;
                      identificador = $urandom_range(0,drivers-1); //Define un identificador aleatorio
                      transaccion.terminal_envio = identificador; //Asigna a la terminal de invío el identificar obtenido
                      //transaccion.print();
                      transaccion_copia = new();
                      transaccion_copia = transaccion;
                      agente_sb_mbx.put(transaccion_copia); //Envía la transacción al scoreboard
                      agente_drv_mbx[transaccion.terminal_envio].put(transaccion); //Envía la transacción al driver correspondiente
                    end

                    autoenvio: begin //Caso de esquina en el que una terminal se envía a sí misma datos
                        identificador = $urandom_range(0,drivers-1); //Define el identificador de la terminal que se va a autoenviar datos
                        num_transacciones = $urandom_range(1,profundidad); //Define un número aleatorio de transacciones 
                        for(int i = 0; i< num_transacciones; i++)begin
                          espera = 0;
                          transaccion = new;
                          transaccion.randomize();
                          direccion = identificador; //Define que la dirección a la que va a enviar va a ser a sí misma 
                          transaccion.terminal_envio = identificador;
                          dato = $random;
                          dato_enviado = {direccion,dato,identificador};
                          transaccion.dato_enviado = dato_enviado;
                          while (espera < transaccion.t_retardo) begin
                            @(posedge vif.clk_i)
                              espera = espera +1;
                          end
                          transaccion.t_envio  = $time;
                          tpo_spec = enviar;
                          transaccion.tipo = tpo_spec;
                          //transaccion.print();
                          agente_drv_mbx[transaccion.terminal_envio].put(transaccion);
                          transaccion_copia = new();
                          transaccion_copia = transaccion;
                          agente_sb_mbx.put(transaccion_copia);
                      end
                    end 
    

                endcase
        end
    end
    endtask
endclass


