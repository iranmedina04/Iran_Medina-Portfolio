`timescale 1ns / 1ps


module hazard_detection_unit(

    input  logic  id_ex_mem_read_i,
    input  logic  id_ex_registerrd_i,
    input  logic  if_id_registerrs1,
    input  logic  if_id_registerrs2,
    input  logic  pcsrcE,
    
    output logic  stallD,
    output logic  stallF,
    output logic  flushD,
    output logic  flushE

 );
 
 logic  lw_stall_D;
 
 assign lw_stall_D = id_ex_mem_read_i && ((id_ex_registerrd_i == if_id_registerrs1) || (id_ex_registerrd_i == if_id_registerrs2));
 assign stallD = lw_stall_D;
 assign stallF = lw_stall_D;
 assign flushD = pcsrcE;
 assign flushE = lw_stall_D || pcsrcE;
 
endmodule
