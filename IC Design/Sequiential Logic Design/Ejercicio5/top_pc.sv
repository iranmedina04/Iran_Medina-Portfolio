module top_pc(
    input  logic       clk_pi,
    input  logic [1:0] pcop_pi,
    input  logic [3:0] salto_pi,
    
    output logic [6:0] seg_po,
    output logic [3:0] en_po
    
    );
    
    //Variables del pc counter
   logic [3:0] pc_o;
   logic [3:0] pcinc_o;
   
   logic clk2;  //Reloj de 10MHz
   logic rst;
   logic en;
   
   clk_wiz_0 cwtb                  // Clocking wizard
   (
        .clk_out1(clk2),
        .locked(rst),
        .clk_in1(clk_pi)
    );
    
    /// Clock divider para mostrar la salida cada segundo
    en_per_seg enp(
        
        .clk_i      (clk2),
        .rst_i      (rst),
        .seg_i      (1),
        
        .en_o       (en)
    );
    
    module_pc #(.W(4)) pc_counter (

        .pc_i             (salto_pi),
        .pc_op_i          (pcop_pi),
        .clk_i            (en),
        .reset            (rst),
        .pc_o             (pc_o),
        .pcinc_o          (pcinc_o)
    
    );
        
    dec_hex_to_sevseg dhts(
        .clk_i     (clk2),
        .rst_i     (rst),
        .data_i    ({pc_o, 8'b00000000, pcinc_o}),
        .en_o      (en_po),
        .seg_o     (seg_po)
   );
    
    
    
endmodule

