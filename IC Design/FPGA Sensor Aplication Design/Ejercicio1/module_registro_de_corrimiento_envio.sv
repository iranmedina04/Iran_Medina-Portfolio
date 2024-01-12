module registro_de_corrimiento_envio (

    input logic          clck_i,
    input logic          enable_i, 
    input logic [31 : 0] datos_envio_i,
    input logic          psclk_i,
    output logic         bit_enviado_o

);

logic [8  : 0] registro;
//logic [31 : 0] registro_con_corrimiento;

//always_ff @(posedge clck_i)
//    begin

//        if(sclck_i)
//            begin

//                registro <= registro_con_corrimiento;

//            end
//        else if (enable_i)
//            begin

//                registro <= datos_envio_i ;

//            end
//        else
//            begin

//                registro <= registro;

//            end

//    end

//always_ff @(posedge sclck_i)
//    begin
    
//        registro_con_corrimiento <= registro >> 1;
//        bit_enviado_o <= registro[0];

//    end

always_ff @(posedge clck_i) begin

    if (enable_i)
        registro <= datos_envio_i [7:0];
        
    else if (psclk_i)begin 
        registro <= registro << 1;
    end 
end 

assign bit_enviado_o = registro[8];
endmodule