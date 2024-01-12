`timescale 1ns / 1ps


module module_control(
        input  logic led_tecla_i,
        input  logic switch,
        input  logic [3:0] teclado,
        input  logic clk,
        input  logic rst,
        
        //Salidas
        output logic led_error,
        output logic led_operacion,
        
        //7 segmentos
        output logic WE,
        
        //ALU
        output logic [3:0] OP,
        
        //Banco de registros
        output logic       we_banco,
        output logic [4:0] addr_rs1,
        output logic [4:0] addr_rs2,
        output logic [4:0] addr_rd,
        
        //Mux
        output logic mux_sel
    );
       
    logic [31:0] delay;
    assign       delay = 31'd20000000;
    
       // Definición de los estados
    typedef enum logic [3:0]{
        idle_e,
        espera_operando1_e,
        guardando_dato1_e,
        
        espera_operacion_e,
        espera_no_tocar1,
        
        
        espera_operando2_e,
        guardando_dato2_e,
        
        espera_enter_e,
        espera_no_tocar2,
        desactiva_mux,
        muestra_resultado,
        reinicia_ciclo,

        
        // Modo 2
        contador_cero_e,
        espera_dos_seg_e
               
    } estados_t;
    
     
    // Declaración de las señales de control
    estados_t estado_actual, estado_siguiente;
    
    logic [3:0] operacion;
    logic [3:0] operacion_inc;
    logic [31:0] contador;
    logic [31:0] contador_inc;
    //assign OP = operacion;
    
    
  always_ff @(posedge clk) begin
    if (!rst) begin
        estado_actual <= idle_e;
        
    end
    else begin
      estado_actual <= estado_siguiente;
      
    end
  end
  
  
  
  logic [4:0] addr_rs1_inc;
  logic [4:0] addr_rs2_inc;
  logic [4:0] addr_rd_inc;
  logic [4:0] save_rs2_inc;
  logic [4:0] save_rs2;
  
  always_ff@(posedge clk, posedge rst)begin
        if(!rst)
            begin
                addr_rd  <= 1;
                addr_rs2 <= 1;
                addr_rs1 <= 1;
               
            end
        else
            begin 
                operacion <= operacion_inc;
                addr_rs1 <= addr_rs1_inc;
                addr_rs2 <= addr_rs2_inc;
                addr_rd  <= addr_rd_inc;
                save_rs2 <= save_rs2_inc;
                contador <= contador_inc;
            end
    end
  


  always_comb begin
    
        case (estado_actual)
        
        idle_e:
            if (switch == 1)begin
                led_error      = 0;
                led_operacion  = 0;
                WE             = 0;
                OP             = 0;
                addr_rs1_inc   = addr_rs1;
                addr_rs2_inc   = addr_rs2;   //Se vuelve 0 para iniciar la cuenta
                addr_rd_inc    = addr_rd;
                save_rs2_inc   = 0;         //Se guarda la direccion
                we_banco       = 0;
                mux_sel        = 0;
                operacion_inc  = 0;
                contador_inc   = 0;
                estado_siguiente = espera_operando1_e;
                end
            else
                begin
                led_error      = 0;
                led_operacion  = 0;
                WE             = 0;
                OP             = 0;
                addr_rs1_inc   = addr_rs1;
                addr_rs2_inc   = 0;   //Se vuelve 0 para iniciar la cuenta
                addr_rd_inc    = addr_rd;
                save_rs2_inc   = addr_rs2;  //Se guarda la direccion
                we_banco       = 0;
                mux_sel        = 0;
                operacion_inc  = 0;
                contador_inc   = 0;
                estado_siguiente = contador_cero_e;
                end
               
        espera_operando1_e: 
            if (switch == 0)
                begin
                      led_error      = 0;
                      led_operacion  = 0;
                      WE             = 0;
                      OP             = 0;
                      addr_rs1_inc   = addr_rs1 ;
                      addr_rs2_inc   = 0;
                      addr_rd_inc    = addr_rd ;
                      save_rs2_inc   = addr_rd;
                      we_banco       = 0;
                      mux_sel        = 0;
                      operacion_inc  = 0;
                      contador_inc   = 0;
                      estado_siguiente = contador_cero_e;
                      end
          
            else if (teclado >= 'h0 && teclado <= 'h9 && led_tecla_i == 0) begin //Si se toca
                  if(addr_rd <= 30)begin
                      led_error      = 0;
                      led_operacion  = 0;
                      WE             = 0;
                      OP             = 0;
                      addr_rs1_inc   = addr_rs1 ;
                      addr_rs2_inc   = addr_rs2;
                      addr_rd_inc    = addr_rd ;
                      save_rs2_inc   = 0;
                      we_banco       = 0;
                      mux_sel        = 0;
                      operacion_inc  = 0;
                      contador_inc   = 0;
                      estado_siguiente = guardando_dato1_e;
                      end
                      
                  else begin
                      led_error      = 0;
                      led_operacion  = 0;
                      WE             = 0;
                      OP             = 0;
                      addr_rs1_inc   = 1;
                      addr_rs2_inc   = 1;
                      addr_rd_inc    = 1;
                      save_rs2_inc   = 0;
                      we_banco       = 0;
                      mux_sel        = 0;
                      operacion_inc  = 0;
                      contador_inc   = 0;
                      
                      estado_siguiente = guardando_dato1_e;
                      end
              end
              
              else begin //Si no se toca
                  led_error      = 0;
                  led_operacion  = 0;
                  WE             = 0;
                  OP             = 0;
                  addr_rs1_inc   = addr_rs1;
                  addr_rs2_inc   = addr_rs2;
                  addr_rd_inc    = addr_rd;
                  save_rs2_inc   = 0;
                  we_banco       = 0;
                  mux_sel        = 0;
                  operacion_inc  = 0;
                  contador_inc   = 0;
                  
                  estado_siguiente = espera_operando1_e;
              end
              
        guardando_dato1_e: begin
            if (led_tecla_i == 1)begin
            
                led_error      = 0;
                led_operacion  = 0;
                WE             = 1;
                OP             = 0;
                addr_rs1_inc   = addr_rs1 ;
                addr_rs2_inc   = addr_rs2 ;
                addr_rd_inc    = addr_rd ;
                save_rs2_inc   = 0;
                we_banco       = 1;
                mux_sel        = 0;
                operacion_inc  = 0;
                contador_inc   = 0;
                estado_siguiente = espera_operacion_e;
                end
                
            else begin
                led_error      = 0;
                led_operacion  = 0;
                WE             = 1;
                OP             = 0;
                addr_rs1_inc   = addr_rs1 ;
                addr_rs2_inc   = addr_rs2 ;
                addr_rd_inc    = addr_rd ;
                save_rs2_inc   = 0;
                we_banco       = 1;
                mux_sel        = 0;
                operacion_inc  = 0;
                contador_inc   = 0;
                estado_siguiente = guardando_dato1_e;
                end
                
        end
            
            espera_operacion_e: 
                begin
                if (switch == 0)
                begin
                      led_error      = 0;
                      led_operacion  = 0;
                      WE             = 0;
                      OP             = 0;
                      addr_rs1_inc   = addr_rs1 ;
                      addr_rs2_inc   = 0;
                      addr_rd_inc    = addr_rd ;
                      save_rs2_inc   = addr_rd;
                      we_banco       = 0;
                      mux_sel        = 0;
                      operacion_inc  = 0;
                      contador_inc   = 0;
                      estado_siguiente = contador_cero_e;
                      end
                      
                else if (teclado >= 'hb && teclado <= 'hf && led_tecla_i == 0) begin
                
                    led_error      = 0;
                    led_operacion  = 1;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2 + 1;
                    addr_rd_inc    = addr_rd + 1;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = teclado;
                    contador_inc   = 0;
                    
                    estado_siguiente = espera_no_tocar1;
                    end
                else begin
                
                    led_error      = 1;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = 0;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = 0;
                    contador_inc   = 0;
                    
                    estado_siguiente = espera_operacion_e;
                    end
                end
                
            espera_no_tocar1: begin
                if (led_tecla_i == 1) begin
                
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = espera_operando2_e;
                end
                
                else begin
                
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = espera_no_tocar1;
                end 
            end 
            
            espera_operando2_e: begin
            
                if (switch == 0)
                begin
                      led_error      = 0;
                      led_operacion  = 0;
                      WE             = 0;
                      OP             = 0;
                      addr_rs1_inc   = addr_rs1 ;
                      addr_rs2_inc   = 0;
                      addr_rd_inc    = addr_rd ;
                      save_rs2_inc   = addr_rd - 1;
                      we_banco       = 0;
                      mux_sel        = 0;
                      operacion_inc  = 0;
                      contador_inc   = 0;
                      estado_siguiente = contador_cero_e;
                      end
            
                else if (teclado >= 'h0 && teclado <= 'h9 && led_tecla_i == 0) begin
                  
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    
                    estado_siguiente = guardando_dato2_e;
                end
                    
                else begin
                
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = espera_operando2_e;
                    end
            end
          
            guardando_dato2_e: begin
            
                if(led_tecla_i == 1)begin
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 1;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;      //Ya no se modifica porque necesitamos que guarde la direccion
                    we_banco       = 1;
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc     = 0;
                    estado_siguiente = espera_enter_e;
                    end
                    
                else begin
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 1;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;      //Ya no se modifica porque necesitamos que guarde la direccion
                    we_banco       = 1;      
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = guardando_dato2_e;
                    end
                end
                
            espera_enter_e: begin
                if (switch == 0)
                begin
                      led_error      = 0;
                      led_operacion  = 0;
                      WE             = 0;
                      OP             = 0;
                      addr_rs1_inc   = addr_rs1 ;
                      addr_rs2_inc   = 0;
                      addr_rd_inc    = addr_rd ;
                      save_rs2_inc   = addr_rd - 1;
                      we_banco       = 0;
                      mux_sel        = 0;
                      operacion_inc  = 0;
                      contador_inc   = 0;
                      estado_siguiente = contador_cero_e;
                      end
                      
                else if (teclado == 'ha && led_tecla_i == 0 ) begin
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd + 1;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 1;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = espera_no_tocar2;
                    end
                    
                else begin
                
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    
                    estado_siguiente = espera_enter_e;
                    end
                end
                
           espera_no_tocar2: begin
                if (led_tecla_i == 1) begin
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 1;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = desactiva_mux;
                end
                
                else begin
                
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;              //Si se  mantiene el write enable para tocar el enter aqui se guardaria el segundo operando nuevamente 
                    OP             = operacion;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 1;
                    mux_sel        = 1;
                    operacion_inc  = operacion;
                    contador_inc   = 0;
                    estado_siguiente = espera_no_tocar2;
                end 
            end 
            
            desactiva_mux: begin
            
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 0;   //escribe el resultado en e registro del 7 segmentos
                    OP             = 0;
                    addr_rs1_inc   = addr_rs1 + 3;
                    addr_rs2_inc   = addr_rs2 + 1;
                    addr_rd_inc    = addr_rd  + 1;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = 0;
                    contador_inc   = 0;
                    estado_siguiente = muestra_resultado;
                end
                
            muestra_resultado: begin
            
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 1;
                    OP             = 0;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = 0;
                    contador_inc   = 0;
                    estado_siguiente = reinicia_ciclo;
                end
                
            reinicia_ciclo: begin
            
                    led_error      = 0;
                    led_operacion  = 0;
                    WE             = 1;
                    OP             = 0;
                    addr_rs1_inc   = addr_rs1;
                    addr_rs2_inc   = addr_rs2 + 1;
                    addr_rd_inc    = addr_rd;
                    save_rs2_inc   = 0;
                    we_banco       = 0;
                    mux_sel        = 0;
                    operacion_inc  = 0;
                    contador_inc   = 0;
                    estado_siguiente = idle_e;
                end
                
          contador_cero_e: begin
            if (switch == 0)begin
             
              led_error      = 0;
              led_operacion  = 0;
              WE             = 0;
              OP             = 0;
              addr_rs1_inc   = 0;
              addr_rs2_inc   = addr_rs2;
              addr_rd_inc    = 0;
              save_rs2_inc   = save_rs2;      //Ya no se modifica porque necesitamos que guarde la direccion
              we_banco       = 0;
              mux_sel        = 0;
              operacion_inc  = 0;
              contador_inc       = 0;
              estado_siguiente = espera_dos_seg_e;
              end
              
          else begin
              led_error      = 0;
              led_operacion  = 0;
              WE             = 0;
              OP             = 0;
              addr_rs1_inc   = save_rs2;
              addr_rs2_inc   = save_rs2;
              addr_rd_inc    = save_rs2;
              save_rs2_inc   = 0;      //Ya no se modifica porque necesitamos que guarde la direccion
              we_banco       = 0;
              mux_sel        = 0;
              operacion_inc  = 0;
              contador_inc       = 0;
              estado_siguiente = espera_operando1_e;
            end
          end
          
          espera_dos_seg_e:
          
            if (switch == 1)begin
             
              led_error      = 0;
              led_operacion  = 0;
              WE             = 0;
              OP             = 0;
              addr_rs1_inc   = save_rs2;
              addr_rs2_inc   = save_rs2;
              addr_rd_inc    = save_rs2;
              save_rs2_inc   = 0;      //Ya no se modifica porque necesitamos que guarde la direccion
              we_banco       = 0;
              mux_sel        = 0;
              operacion_inc  = 0;
              contador_inc       = 0;
              estado_siguiente = espera_operando1_e;
              end
              
            else if(contador < delay)begin //10 para simulaciom 20M para fpga
              led_error      = 0;
              led_operacion  = 0;
              WE             = 1;
              OP             = 0;
              addr_rs1_inc   = 0;
              addr_rs2_inc   = addr_rs2;
              addr_rd_inc    = 0;
              save_rs2_inc   = save_rs2;      //Ya no se modifica porque necesitamos que guarde la direccion
              we_banco       = 0;
              mux_sel        = 0;
              operacion_inc  = 0;
              contador_inc     = contador + 1;
              estado_siguiente = espera_dos_seg_e;
              end
       
          else begin
              led_error      = 0;
              led_operacion  = 0;
              WE             = 1;
              OP             = 0;
              addr_rs1_inc   = 0;
              addr_rs2_inc   = addr_rs2 + 1;
              addr_rd_inc    = 0;
              save_rs2_inc   = save_rs2;      //Ya no se modifica porque necesitamos que guarde la direccion
              we_banco       = 0;
              mux_sel        = 0;
              operacion_inc  = 0;
              contador_inc     = 0;
              estado_siguiente = contador_cero_e;
              end
          
          default: begin
            estado_siguiente = idle_e;
          end
       
        endcase    
  end
    


endmodule
