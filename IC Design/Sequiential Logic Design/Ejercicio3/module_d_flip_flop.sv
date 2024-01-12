module d_flip_flop (

    input logic enable_i,
    input logic d_i,
    output logic q_o
    
    );
    
    
    always_ff @(posedge enable_i)
        begin
        
        if (enable_i)
            begin
            
                q_o <= d_i; 
            
            end
        else
            begin
            
                q_o <= q_o;
            
            end
        
        end
    
    
endmodule