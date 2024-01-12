module generador_y_control_datos (

    input logic             wr_i,
    input logic             clck_i,
    input logic             rst_clck_i,
    input logic             reg_sel_i,
    input logic  [2 : 0]    seleccion_generador,
    input logic  [4:0]      addr_in_i,
    input logic  [31 : 0]   salida_i,

    output logic            wr_o,
    output logic            reg_sel_o,
    output logic [31 : 0]   entrada_o,
    output logic [ 4 : 0]   addr_in_o,
    output logic [ 3 : 0]   en_o,
    output logic [ 6 : 0]   seg_o



);

    logic [15 : 0]   seven_segments; 
    
    assign seven_segments = salida_i [15 : 0];   

    nivel_a_pulso nivel_a_pulso_del_wr (

        .clck_i     (clck_i),
        .boton_i    (wr_i),
        .rst_i      (rst_clck_i),
        .nivel_o    (wr_o)

    );

    dec_hex_to_sevseg ss (

        .clk_pi     (clck_i),
        .rst_pi     (rst_clck_i),
        .data_pi    (seven_segments),
        .en_po      (en_o),
        .seg_po     (seg_o)


    );

    always_comb begin

        
        reg_sel_o      = reg_sel_i;
        addr_in_o      = addr_in_i;
        

        case (seleccion_generador)
            
            3'b000:
                begin

                    entrada_o = 32'h7;    

                end
            
            3'b001:
                begin

                    entrada_o = 32'hb;    

                end
            
            3'b010:
                begin

                    entrada_o = 32'h3;    

                end
            
            3'b011:
                begin

                    entrada_o = 32'h17;    

                end
            
            3'b100:
                begin

                    entrada_o = {28'h1, 4'hb};    

                end  
                
            3'b101:
                begin

                    entrada_o = {28'h1, 4'h3};    

                end  

            default: entrada_o = '0; 
        endcase
        

    end



endmodule