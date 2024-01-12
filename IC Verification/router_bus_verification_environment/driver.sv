/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al driver. Este controla todo lo realacionado al envio de los paquetes.
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class driver #(

    parameter ROWS = 4,
    parameter COLUMNS = 4,  
    parameter PAKG_SIZE = 32,
    parameter FIFO_DEPTH = 16

);

    // Objeto fifo de entrada

    sim_fifo #(.PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) fifo_entrada;

    // Constantes necesarias para el funcionamiento

    int id_terminal;

    // Transacciones que se utilizarán para el envio

    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_agente; 

    // Mailboxes que se utilizarán para recibir datos del angent

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) agnt_drv_mbx;

    logic [PAKG_SIZE - 1 : 0] dato_pop;

    // Interfaz virutal que controlará el sistema

    virtual mesh_if #(

        .ROWS(ROWS),
        .COLUMNS(COLUMNS),
        .PAKG_SIZE(PAKG_SIZE),
        .FIFO_DEPTH(FIFO_DEPTH) 
    
    ) vif;

    // Inicializacón de los drivers

    function  new (int id);

        fifo_entrada = new(id);
        $display("Se creo el driver con el id: %g \n", id);
        this.id_terminal = id;
        
    endfunction

    task  run ();

        // Reset de inicio y valores iniciales 

        $display("Driver %g run", id_terminal);
        vif.dato_out_i_in [id_terminal] = '0;
        vif.pdng_i_in [id_terminal] = '0;
        vif.rst_i = 1'b1;
        @(posedge vif.clk_i);
        vif.rst_i = 1'b0;

        // Corrida del sistema 

        forever begin

            @(posedge vif.clk_i);
            vif.dato_out_i_in [id_terminal] = fifo_entrada.fifo_sim[0];
            // Saca todos los paquetes y los agrega a los filos de entrada


            if (agnt_drv_mbx.num() > 0) begin
                
                transaccion_agente = new();
                agnt_drv_mbx.get(transaccion_agente);
                fifo_entrada.push(transaccion_agente.pckg);
                //$display("Se puso en la cola de envio el paquete %h en el tiempo %g en la terminal: %g \n", transaccion_agente.pckg , $time, id_terminal);
                //$display("Llego al driver");
                //transaccion_agente.print();
                vif.pdng_i_in[id_terminal] = '1;
                vif.dato_out_i_in [id_terminal] = fifo_entrada.fifo_sim[0];


            end

            
            // Si hay un pop toma el valor

            if(vif.popin[id_terminal]) begin
      
                // Si hay algo en la fifo el pending está en alto

                dato_pop = fifo_entrada.pop();

                @(posedge vif.clk_i);
                
                if (fifo_entrada.sizes() > 0) begin
                    
                    vif.pdng_i_in[id_terminal] = '1;
                    vif.dato_out_i_in [id_terminal] = fifo_entrada.fifo_sim[0];

                end else begin
                    
                    vif.pdng_i_in[id_terminal] = '0;
                     vif.dato_out_i_in [id_terminal] = '0;

                end


        end

        end
        
    endtask

    
endclass