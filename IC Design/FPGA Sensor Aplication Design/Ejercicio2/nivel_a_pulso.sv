`timescale 1ns / 1ps

module nivel_a_pulso(
    input logic btn_i,
    input logic clk_i,
    input logic rst_i,
    output logic pulso_o
    );


typedef enum logic [1:0]{
    INICIAL,
    PULSO,
    FIN_PULSO
     
} estado_t;

logic pulso_reg;

estado_t estado_actual , estado_siguiente;

always_ff @(posedge clk_i) begin
    if (!rst_i) begin
        estado_actual <= INICIAL;
        pulso_reg <= 0;
    end
    else begin 
        case (estado_actual)
            INICIAL: begin
                if (btn_i == 1) begin
                    pulso_reg <= 1;
                    estado_actual <= PULSO;
                end
                else begin
                    estado_actual <= INICIAL;
                    pulso_reg <= 0;
                end
            end
                          
            PULSO: begin
                if (btn_i == 1) begin
                    pulso_reg <= 0;
                    estado_actual <= FIN_PULSO;                   
                end
                else estado_actual <= INICIAL;
            end
            
           FIN_PULSO: begin
                if (btn_i == 1) begin
                    pulso_reg <= 0;
                    estado_actual <= FIN_PULSO;                   
                end
                else estado_actual <= INICIAL;
            end
            default: begin
                estado_actual <= INICIAL;
            end
        endcase   
    end        
end    

assign pulso_o = pulso_reg;
    
endmodule
