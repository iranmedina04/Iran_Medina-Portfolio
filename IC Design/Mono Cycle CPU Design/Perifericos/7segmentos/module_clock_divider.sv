
module clock_divider (

    input logic clck_i,
    input logic rst_i,

    output logic clck_divided_o

    );
    
    logic [31 : 0] cont;
    
    
    always_ff @(posedge clck_i) 

        if (!rst_i) 
            begin
            
                cont <= 0;
                clck_divided_o <= 0;
                     
            end 
        else
            begin
            
                if (cont < 50000 ) //50k Para FPGA y 2 para testbech
                    
                    begin
                        cont <= cont + 1;
                        clck_divided_o <= 0; 
                    end
                else 
                
                    begin
                
                        cont <= 0;
                        clck_divided_o <= 1;
                    
                    end
            
            end
            
endmodule
