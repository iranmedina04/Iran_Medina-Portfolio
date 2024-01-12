`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2023 14:05:10
// Design Name: 
// Module Name: module_pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module module_pc #(
    parameter W = 4
            
)(
    input logic [W-1:0]  pc_i,
    input logic  [1:0]   pc_op_i,
    input logic          clk_i,
    input logic          reset,
    output logic [W-1:0] pc_o,
    output logic [W-1:0] pcinc_o
    );
    
    //Registros para las salidas
    logic [W-1:0] pc_reg;
    logic [W-1:0] pcInc_reg;
        
   //Casos para la entrada de seleccion
    always_ff @(posedge clk_i) begin
        if (!reset) begin
            pc_reg <= 0;
            pcInc_reg <= 0;
        end else begin
            case (pc_op_i)
                2'b00: begin    //reset
                    pc_reg  <=  0;
                    pcInc_reg <= 0;                    
                    end  
                2'b01: begin
                    pc_reg <= pc_reg; //hold
                    pcInc_reg <= pc_reg;
                    end
                2'b10: begin
                    pc_reg <= pc_reg + 'd4; //incrementar +4
                    pcInc_reg <= pc_reg;
                    end
                2'b11: begin 
                    pcInc_reg <= pc_reg + 'd4; // salto
                    pc_reg <= pc_i;
                    end
                default: begin
                    pc_reg <= 0;
                    pcInc_reg <= 0;
                    end
            endcase
        end 
     end
    
    assign pc_o = pc_reg;
    assign pcinc_o = pcInc_reg;   

endmodule