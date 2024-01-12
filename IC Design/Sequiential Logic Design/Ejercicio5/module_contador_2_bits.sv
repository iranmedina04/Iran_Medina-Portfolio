module contador_2_bits (
    
    input  logic       clck_i,
    input  logic       enable_i,
    input  logic       hold_i,
    input  logic       rst_i,
    output logic [1:0] state_o
    
    );
    
    logic [1:0] count;
    
    always_ff @ (posedge clck_i)
        begin
        
            if (!rst_i)
                begin
                
                    count <= 0; 
                    state_o <= 0;
                
                end 
            else
                if (hold_i )
                    begin 
                    
                        state_o <= state_o;
                    
                    end
                else
                        
                    if (enable_i)
                        
                        begin
                            begin
                            
                                if (count < 3 )
                                    
                                    begin
                                        count <= count + 1;
                                        state_o <= state_o + 1 ; 
                                    end
                                else 
                                
                                    begin
                                
                                        count <= 0;
                                        state_o <= 0;
                                    
                                    end
                            end
                        end
                     else
                        
                        begin
                        
                            state_o <= state_o;
                        
                        end
        
        end
    
endmodule