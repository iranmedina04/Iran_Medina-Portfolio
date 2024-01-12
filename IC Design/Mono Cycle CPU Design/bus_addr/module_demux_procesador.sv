module demux_procesador (

// Entradas del demux

input logic [31 : 0]  dmux_sel_i,
input logic           we_i,



// Salidas del demux

output logic we_ram_o,
output logic we_uart_a_o,
output logic we_uart_b_o,
output logic we_uart_c_o,
output logic we_switches_o,
output logic we_led_o,
output logic we_siete_segmentos_o

);

always_comb
begin

    if(dmux_sel_i >= 31'h1000 && dmux_sel_i < 31'h13FC )
        begin

            we_ram_o               = we_i;
            we_uart_a_o            = 0;
            we_uart_b_o            = 0;
            we_uart_c_o            = 0;
            we_switches_o          = 0;
            we_led_o               = 0;
            we_siete_segmentos_o   = 0;   
        
        end
    else
        begin

            case (dmux_sel_i)
                
                31'h2000:
                    begin
                       
                         we_ram_o               = 0;
                         we_uart_a_o            = 0;
                         we_uart_b_o            = 0;
                         we_uart_c_o            = 0;
                         we_switches_o          = we_i;
                         we_led_o               = 0;
                         we_siete_segmentos_o   = 0;
                        

                    end
                
                31'h2004:
                    begin
                       
                        we_ram_o               = 0;
                        we_uart_a_o            = 0;
                        we_uart_b_o            = 0;
                        we_uart_c_o            = 0;
                        we_switches_o          = 0;
                        we_led_o               = we_i;
                        we_siete_segmentos_o   = 0;
                        
                    end
                
                31'h2008:
                    begin
                       
                        we_ram_o               = 0;
                        we_uart_a_o            = 0;
                        we_uart_b_o            = 0;
                        we_uart_c_o            = 0;
                        we_switches_o          = 0;
                        we_led_o               = 0;
                        we_siete_segmentos_o   = we_i;

                    end    

                31'h2010:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = we_i;
                    we_uart_b_o            = 0;
                    we_uart_c_o            = 0;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h2018:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = we_i;
                    we_uart_b_o            = 0;
                    we_uart_c_o            = 0;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h201C:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = we_i;
                    we_uart_b_o            = 0;
                    we_uart_c_o            = 0;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h2020:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = 0;
                    we_uart_b_o            = we_i;
                    we_uart_c_o            = 0;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h2028:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = 0;
                    we_uart_b_o            = we_i;
                    we_uart_c_o            = 0;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h202C:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = 0;
                    we_uart_b_o            = we_i;
                    we_uart_c_o            = 0;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h2030:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = 0;
                    we_uart_b_o            = 0;
                    we_uart_c_o            = we_i;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h2038:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = 0;
                    we_uart_b_o            = 0;
                    we_uart_c_o            = we_i;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
                31'h203C:
                    begin
                       
                    we_ram_o               = 0;
                    we_uart_a_o            = 0;
                    we_uart_b_o            = 0;
                    we_uart_c_o            = we_i;
                    we_switches_o          = 0;
                    we_led_o               = 0;
                    we_siete_segmentos_o   = 0;

                    end
            default: 
                    begin
                    we_led_o                = 0;
                    we_ram_o                = 0;
                    we_siete_segmentos_o    = 0;
                    we_switches_o           = 0;
                    we_uart_a_o             = 0;
                    we_uart_b_o             = 0;
                    we_uart_c_o             = 0;
                    end
            endcase

        end
end



endmodule