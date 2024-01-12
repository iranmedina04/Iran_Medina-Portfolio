module forwarding_unit (

// Entradas

// EX hazard

input logic         ex_mem_regwrite_wb_i,
input logic [4 : 0] ex_mem_register_rd_i,
input logic [4 : 0] id_ex_register_rs1_i,
input logic [4 : 0] id_ex_register_rs2_i,


// MEM hazard

input logic         mem_wb_regwrite_wb_i,
input logic [4 : 0] mem_wb_register_rd_i,

// Salidas

output logic [1 : 0] forwardA_o,
output logic [1 : 0] forwardB_o

);

    always_comb begin
        if (ex_mem_regwrite_wb_i && (ex_mem_register_rd_i != 5'b0) && (ex_mem_register_rd_i == id_ex_register_rs1_i ))
            begin
                
                forwardA_o = 2'b10;
        
            end
        else if (ex_mem_regwrite_wb_i && (ex_mem_register_rd_i != 5'b0) && (ex_mem_register_rd_i == id_ex_register_rs2_i )) begin
            
                forwardB_o = 2'b10;
        
        end
        else if (mem_wb_regwrite_wb_i && (mem_wb_register_rd_i == 5'b0) && !(ex_mem_regwrite_wb_i && (ex_mem_register_rd_i != 5'b0) && (ex_mem_register_rd_i == id_ex_register_rs1_i )) && (mem_wb_register_rd_i == id_ex_register_rs1_i)) begin
            
                forwardA_o = 2'b01;
        
        end
        else if (mem_wb_regwrite_wb_i && (mem_wb_register_rd_i == 5'b0) && !(ex_mem_regwrite_wb_i && (ex_mem_register_rd_i != 5'b0) && (ex_mem_register_rd_i == id_ex_register_rs2_i )) && (mem_wb_register_rd_i == id_ex_register_rs2_i)) begin
            
                forwardB_o = 2'b01;
        
        end
        
        else
            begin
        
                forwardA_o = 2'b00;
                forwardB_o = 2'b00;
        
            end
    end 
endmodule