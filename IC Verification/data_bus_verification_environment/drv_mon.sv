class drv_mon #(    parameter bits = 1, 
                    parameter drivers = 16,
                    parameter width = 32,
                    parameter broadcast = {8{1'b1}},
                    parameter profundidad = 16 );

    virtual bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) vif;
    trans_bus_mbx #(.width(width), .drivers(drivers)) agnt_drv_mbx;
    trans_bus_mbx #(.width(width), .drivers(drivers)) mon_ckcr_mbx;
    logic [width - 1 : 0] fifo_envio [$];
    logic [width - 1 : 0] fifo_recibido [$];
    int id_terminal;
    trans_bus  #(.width(width), .drivers(drivers)) transaccion_base;
    trans_bus  #(.width(width), .drivers(drivers)) transaccion_recibida;
    trans_bus  #(.width(width), .drivers(drivers)) transaccion_envio; 
    int nada;
    int contador;


    function new(int id);
        
        this.id_terminal = id;
        //$display("Se creo el driver [%g]", this.id_terminal );
        this.fifo_envio = {};
        this.fifo_recibido = {};


        
    endfunction

    task run();

        //$display("Se inicalizo el driver y monitor");

        // Reset Inicial del Sistema
        transaccion_base = new();
        transaccion_base.tipo = pass;
        @(posedge vif.clk_i);
        //$display("Se reinicio el sistema. \n reset: [%g], \n tiempo: [%t]", vif.rst_i, $time);
        vif.rst_i = '1;
        @(posedge vif.clk_i);
        vif.rst_i = '0;
        //$display("Se dejó el reinicio el sistema. \n reset: [%g], \n tiempo: [%t]", vif.rst_i, $time);
        vif.d_pop_i[0][id_terminal] = '0;
        vif.pndng_i[0][id_terminal] = '0;
        contador = 0;
 
        // Inicia el analisis del envio
        
            forever begin 

                    @(posedge vif.clk_i);

                    
                    transaccion_recibida = new();
                    transaccion_envio = new();
                    
                   
                    transaccion_envio = transaccion_base;
                    agnt_drv_mbx.try_get(transaccion_envio);
                    case (transaccion_envio.tipo)
                        
                        enviar:
                            begin

                                if (contador >= profundidad) begin
                                    
                                    fifo_envio = fifo_envio;

                                end
                                else begin
                                   
                                    fifo_envio.push_back(transaccion_envio.dato_enviado);
                                    contador = contador + 1;

                                end
                                vif.pndng_i[0][id_terminal] = '1;

                            end
                        reset:
                            begin
                                $display("Ha llegado una transacción de reset en [%t]", $time);
                                $display("Se reinicio el sistema. \n reset: [%g], \n tiempo: [%t] por parte de la terminal [%g]", vif.rst_i, $time, id_terminal);
                                vif.rst_i = '1;
                                @(posedge vif.clk_i);
                                vif.rst_i = '0;
                                $display("Se dejó el reinicio el sistema. \n reset: [%g], \n tiempo: [%t] por parte de la terminal [%g]", vif.rst_i, $time, id_terminal);
                            end
                        pass:

                            nada = 0;

                        default:
                            begin
                                $display("No se ha recibido un tipo de transaccion valido");
                            end
                    endcase 

                    if (fifo_envio.size() > 0) begin

                        vif.d_pop_i[0][id_terminal] = fifo_envio.pop_front();
                        
                    end
            
                    if(vif.pop_o[0][id_terminal])begin
                        
                        if(fifo_envio.size() == 0) begin
                            
                           
                            vif.pndng_i [0][id_terminal] = '0;

                        end
                        else begin
                            
                            vif.pndng_i[0][id_terminal] = vif.pndng_i[0][id_terminal];
                            
                        end
                        

                        end
                    else begin
                        
                        vif.d_pop_i[0][id_terminal] = vif.d_pop_i[0][id_terminal];
                    end

                    if(vif.push_o[0][id_terminal])
                        begin
                           
                            fifo_recibido.push_back(vif.d_push_o[0][id_terminal]);
                            transaccion_recibida.dato_recibido = vif.d_push_o[0][id_terminal];
                            transaccion_recibida.t_recibido = $time;
                            transaccion_recibida.terminal_recibido = id_terminal;
                            mon_ckcr_mbx.put(transaccion_recibida);
                            
                        end
                    else
                        begin
                            
                            fifo_recibido = fifo_recibido;

                        end
                    
       
                end

    endtask
    
endclass