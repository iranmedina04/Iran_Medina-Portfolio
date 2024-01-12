module sincronizador (

    input  logic clck_i,
    input  logic d_i,
    output logic q_o

    );
    
    logic n0;
    logic n1;
    
    always_ff @(posedge clck_i)
            
           begin
              
              n0  <=  d_i;
              n1  <=  n0;
              q_o <=  n1;
           
           end
         
endmodule
