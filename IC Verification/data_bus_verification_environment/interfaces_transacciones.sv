typedef enum  {enviar, reset, pass} tipo_trans; //Define el tipo de transacciones

class trans_bus #(parameter width = 32, parameter drivers = 16); //Clase que define las transacciones del bus

    // Tiempos
    rand int t_retardo; 
    int profundidad;
    int t_envio;
    int t_recibido;
    int max_retardo;
    rand int terminal_envio;
    int terminal_recibido;

    // Datos
    logic [width - 1 : 0] dato_enviado;
    logic [width - 1 : 0] dato_recibido;
    tipo_trans tipo;

    constraint const_retardo {t_retardo <= max_retardo; t_retardo>0;}
    constraint const_terminalenvio {terminal_envio < drivers; terminal_envio>-1;}

    function new(  //Función para crear una transacción

    //  Definición de los tiempos
        int tmp_ret = 0,
        int prof    = 1, 
        int tmp_en = 0,
        int tmp_re = 0,
        int tmp_max = 10,

    //  Definición de los tipos de envio

        tipo_trans tpo = enviar,

    // Definición de los datos

        bit [width - 1 : 0 ] dto_e = 0,
        bit [width - 1 : 0 ] dto_r = 0

    );

    this.t_retardo      = tmp_ret;
    this.profundidad    = prof;
    this.t_envio        = tmp_en;
    this.t_recibido     = tmp_re;
    this.max_retardo    = tmp_max;
    this.tipo           = tpo;
    this.terminal_envio = 0;
    this.terminal_recibido = 0;
    this.dato_enviado   = dto_e;
    this.dato_recibido  = dto_r;
    
    endfunction

    function clean(); //Función para limpiar la transacción

        this.t_retardo      = 0;
        this.t_envio        = 0;
        this.t_recibido     = 0;
        this.tipo           = enviar;
        this.dato_enviado   = 0;
        this.dato_recibido  = 0;

    endfunction

    function print(); //Función que imprime la transacción 
        
    $display("La transacción tiene almacenado \n t_retado: [%g] , \n profuncidad: [%g] , \n t_envio: [%g] ,\n t_recibido: [%g] ,\n max_retador: [%g],\n Tipo: [%g],\n Terminal envio: [%g],\n Terminal recibido: [%g],\n Dato enviado: [%h],\n Dato recibido: [%h] \n", this.t_retardo,
    this.profundidad,
    this.t_envio,
    this.t_recibido,
    this.max_retardo,
    this.tipo,
    this.terminal_envio,
    this.terminal_recibido,
    this.dato_enviado, 
    this.dato_recibido);
        
    endfunction
    
endclass



interface bus_if #( //Definición de la interfaz
                    
                    parameter bits = 1, 
                    parameter drivers = 16,
                    parameter width = 32,
                    parameter broadcast = {8{1'b1}}
                    
                    ) (

    input clk_i

);  



    // Entradas del modulo

    logic rst_i;
    logic pndng_i [bits - 1 : 0][drivers - 1 : 0];
    logic [width - 1 : 0] d_pop_i  [bits - 1 : 0][drivers - 1 : 0];

    // Salidas del modulo
    
    logic push_o [bits - 1 : 0][drivers - 1 : 0];
    logic pop_o  [bits - 1 : 0][drivers - 1 : 0];
    logic [width - 1 : 0] d_push_o  [bits - 1 : 0][drivers - 1 : 0];


endinterface

class trans_sb #( //Definición de la clase de transacciones del scoreboard

                parameter width = 32,
                parameter profundidad = 16,
                parameter drivers = 16,
                parameter bits= 1                 
);

    logic [width - 1 : 0] pckg;
    int t_envio;
    int t_recibido;
    int terminal_envio;
    int terminal_recibido;
    int latencia;
    int drv;
    int prof;

    function new(); //Función para crear una nueva transacción del scoreboard

        this.pckg  = 0;
        this.t_envio = 0;
        this.t_recibido = 0;
        this.terminal_envio =0;
        this.terminal_recibido = 0;
        this.latencia = 0;
        this.prof = profundidad; 
        this.drv = drivers; 
        
    endfunction

    function cal_latencia(); //Función para calcular la latencia
        
        this.latencia = this.t_recibido - this.t_envio;
        
    endfunction

    function print(); //Función para imprimir la transacción
        
        $display("El paquete del Sb posee: \n Paquete: [%h], Tiempo envio: [%t] \n Tiempo recibido: [%t] \n Terminal envio: [%g] \n Terminal recibido: [%g] \n Latencia: [%g] \n Profundidad: [%g] \n Drivers: [%g] \n",
        
        this.pckg,
        this.t_envio,
        this.t_recibido,
        this.terminal_envio,
        this.terminal_recibido,
        this.latencia,
        this.prof, 
        this.drv
        
        );
        
    endfunction

endclass

typedef enum {reporte} instrucciones_test_sb; //Define las instrucciones que le puede enviar el test al scoreboard

typedef enum {un_paquete,un_dispositivo_envio,un_dispositivo_recibido,varios_dispositivos_envio_recibido,broadcast_aleatorio,llenado_fifos,envio_fuera_de_rango,reset_inicio,reset_mitad,reset_final,autoenvio} instrucciones_agente; //Define las instrucciones del agente

typedef mailbox #(instrucciones_test_sb) test_sb_mbx; //Define el mailbox entre el test y el scoreboard

typedef mailbox #(trans_bus) trans_bus_mbx; //Define el mailbox de las transacciones del bus

typedef mailbox #(trans_sb) trans_sb_mbx; //Define el mailbox de las transacciones del scoreboard

typedef mailbox #(instrucciones_agente) test_agente_mbx; //Define el mailbox entre el test y el agente
