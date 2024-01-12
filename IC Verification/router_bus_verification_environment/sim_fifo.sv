/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde a la fifo de simulación. Este es la simulación de una fifo en la cual se
////// se guardarán los paquetes de envío.
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class sim_fifo #(
    
    parameter PAKG_SIZE = 32,
    parameter FIFO_DEPTH = 16
    
    );

    logic [PAKG_SIZE - 1 : 0] fifo_sim [$];
    logic [PAKG_SIZE - 1 : 0] d_out;
    int size;
    int pass;
    int id_terminal;

    function  new(int id = 0);
        //$display("Se creo la fifa de entrada con id: %g", id);
        this.fifo_sim = {};
        this.id_terminal = id;
        
    endfunction

    function push ( logic [PAKG_SIZE - 1 : 0] d_in);

        if (this.fifo_sim.size() == FIFO_DEPTH) begin

            //$display("Una de las fifos de entrada se encuentra llena \nNo se cargará el dato para no hacer un ovearflow\n");
            pass = 0;
        end
        else begin
            
          //$display("Se agregó el dato %h a la FIFO %g \n", d_in, id_terminal);
            this.fifo_sim.push_back(d_in);
        
        end

        
    endfunction

    function logic [PAKG_SIZE - 1 : 0] pop ();

      if (fifo_sim.size() == 0) begin
            
            //$display("Una de las fifos se encuentra vacía \nNo se realizará el pop\n");
            pass = 0;
        end
        else begin
            
            this.d_out = this.fifo_sim.pop_front();
            return this.d_out;

        end

        
    endfunction

    function int sizes ();
        
        size = fifo_sim.size();
        return size;

    endfunction


endclass

