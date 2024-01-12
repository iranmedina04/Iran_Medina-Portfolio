module mux_procesador (


// Entradas del mux

    input logic [31 : 0] mux_sel_i,

    input logic [31 : 0] ram_i,
    input logic [31 : 0] uart_a_i,
    input logic [31 : 0] uart_b_i,
    input logic [31 : 0] uart_c_i,
    input logic [31 : 0] switches_i,
    input logic [31 : 0] led_i,
    input logic [31 : 0] siete_segmentos,

// Salida del mux

    output logic [31 : 0] mux_o

);

always_comb
    begin

        if(mux_sel_i >= 31'h1000 && mux_sel_i < 31'h13FC )
            begin
                mux_o = ram_i;    
            end
        else
            begin

                case (mux_sel_i)
                    
                    31'h2000:
                        begin
                           
                            mux_o = switches_i;

                        end
                    
                    31'h2004:
                        begin
                           
                            mux_o = led_i;

                        end
                    
                    31'h2008:
                        begin
                           
                            mux_o = siete_segmentos;

                        end    

                    31'h2010:
                        begin
                           
                            mux_o = uart_a_i;

                        end
                    31'h2018:
                        begin
                           
                            mux_o = uart_a_i;

                        end
                    31'h201C:
                        begin
                           
                            mux_o = uart_a_i;

                        end
                    31'h2020:
                        begin
                           
                            mux_o = uart_b_i;

                        end
                    31'h2028:
                        begin
                           
                            mux_o = uart_b_i;

                        end
                    31'h202C:
                        begin
                           
                            mux_o = uart_b_i;

                        end
                    31'h2030:
                        begin
                           
                            mux_o = uart_c_i;

                        end
                    31'h2038:
                        begin
                           
                            mux_o = uart_c_i;

                        end
                    31'h203C:
                        begin
                           
                            mux_o = uart_c_i;

                        end
                    default: 
                        mux_o = 31'b0;
                
                endcase

            end
    end



endmodule