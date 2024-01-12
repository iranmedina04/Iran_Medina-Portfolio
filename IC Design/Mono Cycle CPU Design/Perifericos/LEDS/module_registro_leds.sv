module registro_leds (

    input logic             clck_i,
    input logic             rst_i,
    input logic  [31 : 0]   data_i,
    input logic             we_i,
    
    output logic [31 : 0]   reg_leds_o

);

always_ff @(posedge clck_i)
    begin
    
    if(!rst_i)
    
        begin
        
            reg_leds_o <= '0;
        
        end
        
    else
        begin
        
            if (we_i)
            
                reg_leds_o <= data_i;
            
            else
            
                reg_leds_o <= reg_leds_o;
        
        end
    
    end




endmodule