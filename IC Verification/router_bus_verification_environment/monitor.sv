/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al monitor. Este controla todo lo realacionado a la recepcion de los 
////// paquetes.
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class monitor #(

    parameter ROWS = 4,
    parameter COLUMNS = 4,  
    parameter PAKG_SIZE = 32,
    parameter FIFO_DEPTH = 16

);

     // Objeto fifo de salida en lo cual se almacenarán los paquetes recibidos

    sim_fifo #(.PAKG_SIZE(PAKG_SIZE), .FIFO_DEPTH(FIFO_DEPTH)) fifo_salida;

    // Constantes necesarias para el funcionamiento

    int id_terminal;

    // Transacciones que se utilizarán para los datos recibidos

    trans_mesh #(.PAKG_SIZE(PAKG_SIZE)) transaccion_checker; 

    // Mailboxes que se utilizarán para enviar datos al checker

    trans_mbx #(.PAKG_SIZE(PAKG_SIZE)) mon_chckr_mbx;

    // Interfaz virutal que controlará el sistema

    virtual mesh_if #(

        .ROWS(ROWS),
        .COLUMNS(COLUMNS),
        .PAKG_SIZE(PAKG_SIZE),
        .FIFO_DEPTH(FIFO_DEPTH) 
    
    ) vif;

    int filas [] = {0,0,0,0,1,2,3,4,5,5,5,5,1,2,3,4};
    int columnas [] = {1,2,3,4,0,0,0,0,1,2,3,4,5,5,5,5};

    // Inicializacón de los monitores

    function  new (int id);

        fifo_salida = new(id);
        transaccion_checker = new();
        $display("Se creo el checker con el id: %g \ns", id);
        this.id_terminal = id;
        
    endfunction

    task run();

        $display("Monitor %g run \n", id_terminal);
        vif.pop[id_terminal] = '0;
        //$display("El vif.pop[%g] fue puesto es %b \n", id_terminal, vif.pop[id_terminal]);

        forever begin

            @(posedge vif.clk_i);

            if (vif.pndng[id_terminal]) begin

                transaccion_checker = new();
                transaccion_checker.tiempo_recibido = $time;
                transaccion_checker.terminal_recibido = id_terminal;
                transaccion_checker.pckg = vif.data_out[id_terminal];
                //$display("Se recicbio el paquete %h en el tiempo %g en la terminal: %g \n", transaccion_checker.pckg , $time, id_terminal);
                fifo_salida.push(transaccion_checker.pckg);
                mon_chckr_mbx.put(transaccion_checker);

                assert(transaccion_checker.pckg[PAKG_SIZE-9 : PAKG_SIZE-12] == filas[id_terminal] )//Aserción para comprobar que el paquete se esté enviando al checker a la fila correcta 
          else $warning("El paquete se envió a una fila erronea");

                assert(transaccion_checker.pckg[PAKG_SIZE-13 : PAKG_SIZE-16] == columnas[id_terminal] )//Aserción para comprobar que el paquete se esté enviando al checker a la columna correcta 
          else $warning("El paquete se envió a una columna erronea");

                if(vif.pndng[id_terminal] == 0) begin
                assert(vif.pop[id_terminal] == 0 )//Aserción para comprobar que no haya un pop si el pending es cero
                else $warning("Hubo un pop cuando el pending estaba en cero");
                end

                vif.pop[id_terminal] = '1;
                @(posedge vif.clk_i);
                vif.pop[id_terminal] = '0;

            end

        end
        
    endtask

endclass
