//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Este corresponde al objecto que va a ser utilizado como transaccion del ambiente para la comunicacion
// y captura para el DUT 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
typedef enum {escritura, lectura} tipo_transaccion;

class mesh_item extends uvm_sequence_item;

    rand logic [7 : 0] next_jump;
    rand logic [3: 0]  row;
    rand logic [3 : 0] colum;
    rand logic mode;
    rand logic [`PAKG_SIZE - 18 : 0] payload;
    logic [`PAKG_SIZE - 1 : 0] pckg;
    rand int terminal_envio;
    int tiempo_envio;
    int tiempo_recibido;
    int terminal_recibido;
    int tiempo_retardo;
    int latencia;
    tipo_transaccion tipo;


//Constraints para delimitar los valores de cada componente del item
    constraint c1 {row < 6 ; row >= 0;}
    constraint c2 { row == 0 -> colum < 5 ; row == 0 -> colum > 0; row == 5 -> colum < 5 ; row == 5 -> colum > 0;  row != 0 -> colum == 0 ; row != 0 -> colum == 5;}
    constraint c3 {mode >= 0; mode < 2;}
  	constraint c4 {terminal_envio >= 0 ; terminal_envio < 16;}
    constraint c5 {tiempo_retardo < 10; tiempo_retardo>=0;}
    constraint c6 {next_jump==0;}

//Crea
    `uvm_object_utils_begin(mesh_item)

        `uvm_field_int (next_jump, UVM_DEFAULT);
        `uvm_field_int (row, UVM_DEFAULT);
        `uvm_field_int (colum, UVM_DEFAULT);
        `uvm_field_int (mode, UVM_DEFAULT);
        `uvm_field_int (payload, UVM_DEFAULT);
        `uvm_field_int (pckg, UVM_DEFAULT);
        `uvm_field_int (terminal_envio, UVM_DEFAULT);
        `uvm_field_int (tiempo_envio, UVM_DEFAULT);
        `uvm_field_int (tiempo_recibido, UVM_DEFAULT);
        `uvm_field_int (terminal_recibido, UVM_DEFAULT);
        `uvm_field_int (tiempo_retardo, UVM_DEFAULT);
        `uvm_field_int (latencia, UVM_DEFAULT);
        `uvm_field_int (tipo, UVM_DEFAULT);
    `uvm_object_utils_end

    function  new(string name = "mesh_item");

        super.new(name);
        
    endfunction

    //Une los datos para crear el paquete
    function  fun_pckg();

        this.pckg = {this.next_jump,this.row,this.colum,this.mode,this.payload};
        
    endfunction
    
    //Función que realiza el cálculo de la terminal de recibido
    function cal_terminal_recibido();

        case ({this.row,this.colum})
            
            {4'd0, 4'd1}: begin

                this.terminal_recibido = 0;

            end
            {4'd0, 4'd2}: begin

                this.terminal_recibido = 1;

            end
            {4'd0, 4'd3}: begin

                this.terminal_recibido = 2;

            end
            {4'd0, 4'd4}: begin

                this.terminal_recibido = 3;

            end

            {4'd1, 4'd0}: begin

                this.terminal_recibido = 4;

            end
            {4'd2, 4'd0}: begin

                this.terminal_recibido = 5;

            end
            {4'd3, 4'd0}: begin

                this.terminal_recibido = 6;

            end
            {4'd4, 4'd0}: begin

                this.terminal_recibido = 7;

            end

            {4'd1, 4'd5}: begin

                this.terminal_recibido = 12;

            end
            {4'd2, 4'd5}: begin

                this.terminal_recibido = 13;

            end
            {4'd3, 4'd5}: begin

                this.terminal_recibido = 14;

            end
            {4'd4, 4'd5}: begin

                this.terminal_recibido = 15;

            end

            {4'd5, 4'd1}: begin

                this.terminal_recibido = 8;

            end
            {4'd5, 4'd2}: begin

                this.terminal_recibido = 9;

            end
            {4'd5, 4'd3}: begin

                this.terminal_recibido = 10;

            end
            {4'd5, 4'd4}: begin

                this.terminal_recibido = 11;

            end
      
            default: 

                this.terminal_recibido = 0;
        endcase

    endfunction

endclass