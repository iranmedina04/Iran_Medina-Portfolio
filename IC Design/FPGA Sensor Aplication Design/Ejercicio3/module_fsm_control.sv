 module fsm_control (

    // Del reloj 

    input logic         clck_i,
    input logic         rst_i,

    // Entradas del SPI

    input logic [31 : 0] entrada_spi_i, 

    //Entrada del datapath

    input logic end_bcd_i,
    
    // Entradas del uart 

    input logic  entrada_uart_i,

    // Salidas para el spi
    
    output logic          wr_spi_o,
    output logic          reg_sel_spi_o,
    output logic [31 : 0] entrada_spi_o,
    output logic [ 4 : 0] addr_spi_o,

    // Salida Datapath

    output logic          wr_depurador_de_datos_o,
    output logic          begin_bcd,
    output logic [1 :0]   sel_ascci_o,

    //Salida al uart

    output logic          wr_guardado_o,
    output logic          wr_enviar_o,
    output logic          wr_clear_o

 );

    typedef enum logic [4 : 0] { 

    //Estados para el spi

        espera_dos_segundos,
        escribe_instruccion_spi,
        guarda_instruccion_spi,
        revision_termina_spi,
    
    //Estados del datapath

        cambio_reg_sel_spi,
        depurar_datos_primer_registro,
        cambio_addr_spi,
        depurar_datos_segundo_registro,
        iniciar_bcd,
        espera_fin_bcd,

    // Estados del uart

        seleccion_ascii_1,
        guardado_ascii_1,
        
        delay_tx_start_1,
        envio_ascii_1,
        espera_fin_envio_ascii_1,
        seleccion_ascii_2,
        guardado_ascii_2,
        
        delay_tx_start_2,
        envio_ascii_2,
        espera_fin_envio_ascii_2,
        seleccion_ascii_3,
        guardado_ascii_3,
        
        delay_tx_start_3,
        envio_ascii_3,
        espera_fin_envio_ascii_3,
        seleccion_ascii_4,
        guardado_ascii_4,
        
        delay_tx_start_4,
        envio_ascii_4,
        espera_fin_envio_ascii_4

     } estados_t;

        estados_t estado_actual;
        estados_t estado_siguiente;
        logic [31:0] contador_secuencial;
        logic [31:0] contador_combinacional;
        localparam dos_segundos = 31'd10; //20M para 2 segundos

        logic [31:0] delay_sec;
        logic [31:0] delay_comb;
        localparam tiempo_delay = 31'd1500;
        
    always_ff @(posedge clck_i)begin

    if (!rst_i) begin

        estado_actual <= espera_dos_segundos;
        contador_secuencial <= dos_segundos;
        delay_sec <= tiempo_delay;
        
        end
    else begin

        contador_secuencial <= contador_combinacional;
        estado_actual <= estado_siguiente;
        delay_sec <= delay_comb;
        end
        
    end
    
    always_comb begin
            
        case (estado_actual)

            espera_dos_segundos: begin

                if(contador_secuencial > 0)
                    begin

                        estado_siguiente = espera_dos_segundos;

                    end
                else begin

                    estado_siguiente = escribe_instruccion_spi;

                end

            end 

            escribe_instruccion_spi: begin
            
                estado_siguiente = guarda_instruccion_spi;
            
            end

            guarda_instruccion_spi: begin

                estado_siguiente = revision_termina_spi;

            end

            revision_termina_spi: begin

                if(entrada_spi_i[0])

                    estado_siguiente = revision_termina_spi;
                
                else

                    estado_siguiente = cambio_reg_sel_spi;

            end

            cambio_reg_sel_spi: begin

                estado_siguiente = depurar_datos_primer_registro;

            end

            depurar_datos_primer_registro: begin

                estado_siguiente =  cambio_addr_spi;

            end

            cambio_addr_spi: begin
            
                estado_siguiente = depurar_datos_segundo_registro;

            end

            depurar_datos_segundo_registro: begin

                estado_siguiente = iniciar_bcd;

            end

            iniciar_bcd: begin

                estado_siguiente =  espera_fin_bcd;

            end

            espera_fin_bcd: begin

                if(end_bcd_i)

                    estado_siguiente =  seleccion_ascii_1;

                else

                    estado_siguiente = espera_fin_bcd;

            end

            seleccion_ascii_1: begin

                estado_siguiente = guardado_ascii_1;

            end

            guardado_ascii_1:begin

                estado_siguiente = delay_tx_start_1;

            end
            
            delay_tx_start_1: begin
                if (delay_sec > 0)begin
                    estado_siguiente = delay_tx_start_1;
                end else 
                    estado_siguiente = envio_ascii_1;
            end
            
            envio_ascii_1: begin

                estado_siguiente = espera_fin_envio_ascii_1;

            end

            espera_fin_envio_ascii_1: begin

                if(entrada_uart_i == 0)

                    estado_siguiente = espera_fin_envio_ascii_1;
                else

                    estado_siguiente = seleccion_ascii_2;
            end

            seleccion_ascii_2: begin

                estado_siguiente = guardado_ascii_2;

            end

            guardado_ascii_2:begin

                estado_siguiente = delay_tx_start_2;

            end
            
            delay_tx_start_2: begin
                if (delay_sec > 0)begin
                    estado_siguiente = delay_tx_start_2;
                end else 
                    estado_siguiente = envio_ascii_2;
            end

            envio_ascii_2: begin

                estado_siguiente = espera_fin_envio_ascii_2;

            end

            espera_fin_envio_ascii_2: begin

                if(entrada_uart_i==0)

                    estado_siguiente = espera_fin_envio_ascii_2;
                else

                    estado_siguiente = seleccion_ascii_3;
            end

            seleccion_ascii_3: begin

                estado_siguiente = guardado_ascii_3;

            end

            guardado_ascii_3:begin

                estado_siguiente = delay_tx_start_3;

            end
            
            delay_tx_start_3: begin
                if (delay_sec > 0)begin
                    estado_siguiente = delay_tx_start_3;
                end else 
                    estado_siguiente = envio_ascii_3;
            end

            envio_ascii_3: begin

                estado_siguiente = espera_fin_envio_ascii_3;

            end

            espera_fin_envio_ascii_3: begin

                if(entrada_uart_i==0)

                    estado_siguiente = espera_fin_envio_ascii_3;
                else

                    estado_siguiente = seleccion_ascii_4;
            end

            seleccion_ascii_4: begin

                estado_siguiente = guardado_ascii_4;

            end

            guardado_ascii_4:begin

                estado_siguiente = delay_tx_start_4;

            end
            
            delay_tx_start_4: begin
                if (delay_sec > 0)begin
                    estado_siguiente = delay_tx_start_4;
                end else 
                    estado_siguiente = envio_ascii_4;
            end

            envio_ascii_4: begin

                estado_siguiente = espera_fin_envio_ascii_4;

            end

            espera_fin_envio_ascii_4: begin

                if(entrada_uart_i==0)

                    estado_siguiente = espera_fin_envio_ascii_4;
                else

                    estado_siguiente = espera_dos_segundos;
            end

            default: 
                estado_siguiente = espera_dos_segundos;

        endcase
    
    end

    // Cambio de salidas

    always_comb begin
            
        case (estado_actual)

            espera_dos_segundos: begin
                
                if(contador_secuencial > 0) begin
                        //Salidas spi
    
                    wr_spi_o      = 1; // 1 bit
                    reg_sel_spi_o = 0; //1 bit
                    entrada_spi_o = '0; // 32 bits
                    addr_spi_o    = '0; // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = '0; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    wr_clear_o      = 0; // 1bit
                    delay_comb = delay_sec;
                    contador_combinacional = contador_secuencial - 1; 

                end
                
                else begin
                    //Salidas spi

                    wr_spi_o      = 0; // 1 bit
                    reg_sel_spi_o = 0; //1 bit
                    entrada_spi_o = '0; // 32 bits
                    addr_spi_o    = '0; // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = '0; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    wr_clear_o      = 0; // 1bit
                    delay_comb = delay_sec;
                    contador_combinacional = dos_segundos;

                end

            end 

            escribe_instruccion_spi: begin
            
                
                //Salidas spi

                wr_spi_o      = 0;      // 1 bit
                reg_sel_spi_o = 0;      //1 bit
                entrada_spi_o = 32'h13; // 32 bits  instruccion
                addr_spi_o    = '0;     // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                wr_clear_o      = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                            
            end

            guarda_instruccion_spi: begin

                //Salidas spi

                wr_spi_o      = 1;      // 1 bit
                reg_sel_spi_o = 0;      //1 bit
                entrada_spi_o = 32'h13; // 32 bits
                addr_spi_o    = '0;     // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

            end

            revision_termina_spi: begin

                //Salidas spi

                wr_spi_o      = 0;      // 1 bit
                reg_sel_spi_o = 0;      //1 bit
                entrada_spi_o = 0; // 32 bits
                addr_spi_o    = '0;     // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            cambio_reg_sel_spi: begin

                //Salidas spi

                wr_spi_o      = 0;      // 1 bit
                reg_sel_spi_o = 1;      //1 bit
                entrada_spi_o = 0; // 32 bits
                addr_spi_o    = '0;     // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                

            end

            depurar_datos_primer_registro: begin

                //Salidas spi

                wr_spi_o      = 0;      // 1 bit
                reg_sel_spi_o = 1;      //1 bit
                entrada_spi_o = 0; // 32 bits
                addr_spi_o    = '0;     // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 1;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

            end

            cambio_addr_spi: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 5'b00001; // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            depurar_datos_segundo_registro: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 5'b00001; // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 1;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            iniciar_bcd: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 5'b00001; // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 1;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            espera_fin_bcd: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

                
            end

            seleccion_ascii_1: begin

               //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            guardado_ascii_1:begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
            
            end

            delay_tx_start_1: begin
                if (delay_sec > 0)begin
                     //Salidas spi
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = '0; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 1; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = delay_sec - 1;
                    contador_combinacional = dos_segundos;
                    end
                else begin
                
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = '0; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = tiempo_delay;
                    contador_combinacional = dos_segundos;
         
                end 
                
            end
            
            
            envio_ascii_1: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 1; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            
            end

            espera_fin_envio_ascii_1: begin

                
                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 0;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b01; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                            
            end

            seleccion_ascii_2: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b01; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                

                
            end

            guardado_ascii_2:begin

               
                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b01; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 1; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                 

                
            end
            
            delay_tx_start_2: begin
                if (delay_sec > 0)begin
                     //Salidas spi
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = 2'b01; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = delay_sec - 1;
                    contador_combinacional = dos_segundos;
                    end
                else begin
                
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = 2'b01; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = tiempo_delay;
                    contador_combinacional = dos_segundos;
         
                end 
                
            end

            envio_ascii_2: begin

                
                
                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b01; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 1; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

            end

            espera_fin_envio_ascii_2: begin

                
                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b10; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            seleccion_ascii_3: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b10; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

                
            end

            guardado_ascii_3:begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b10; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 1; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
            end
            
            delay_tx_start_3: begin
                if (delay_sec > 0)begin
                     //Salidas spi
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = 2'b10; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = delay_sec - 1;
                    contador_combinacional = dos_segundos;
                    end
                else begin
                
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = 2'b10; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = tiempo_delay;
                    contador_combinacional = dos_segundos;
         
                end 
                
            end
            
            envio_ascii_3: begin

               //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b10; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 1; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            espera_fin_envio_ascii_3: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b11; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

            end

            seleccion_ascii_4: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b11; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            guardado_ascii_4:begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b11; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 1; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

                
            end
            
            delay_tx_start_4: begin
                if (delay_sec > 0)begin
                     //Salidas spi
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = 2'b11; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = delay_sec - 1;
                    contador_combinacional = dos_segundos;
                    end
                else begin
                
                    wr_spi_o      = 0;        // 1 bit
                    reg_sel_spi_o = 1;        //1 bit
                    entrada_spi_o = 0;        // 32 bits
                    addr_spi_o    = 0;        // 5 bits
    
                    // Salida Datapath
    
                    wr_depurador_de_datos_o = 0;  // 1bit
                    begin_bcd               = 0;  // 1 bit
                    sel_ascci_o             = 2'b11; //2 bits 
    
                    //Salida al uart
    
                    
                    wr_guardado_o   = 0; // 1bit
                    wr_enviar_o     = 0; // 1bit
                    delay_comb = tiempo_delay;
                    contador_combinacional = dos_segundos;
         
                end 
                
            end
            
            envio_ascii_4: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b11; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 1; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            espera_fin_envio_ascii_4: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 1;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = 2'b00; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;
                
            end

            default: begin

                //Salidas spi

                wr_spi_o      = 0;        // 1 bit
                reg_sel_spi_o = 0;        //1 bit
                entrada_spi_o = 0;        // 32 bits
                addr_spi_o    = 0;        // 5 bits

                // Salida Datapath

                wr_depurador_de_datos_o = 0;  // 1bit
                begin_bcd               = 0;  // 1 bit
                sel_ascci_o             = '0; //2 bits 

                //Salida al uart

                
                wr_guardado_o   = 0; // 1bit
                wr_enviar_o     = 0; // 1bit
                delay_comb = delay_sec;
                contador_combinacional = dos_segundos;

            end

        endcase
    
    end
    
    
    

endmodule