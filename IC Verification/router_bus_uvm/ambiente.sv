/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al ambiente, el cual contiene al agente y al scoreboard
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class env extends uvm_env;
`uvm_component_utils(env)
function new(string name="env", uvm_component parent=null);
    super.new(name,parent);
endfunction

agent  a0;
scoreboard sb0;

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = agent::type_id::create("a0",this); //Instanzación y construcción del agente
    sb0 = scoreboard::type_id::create("sb0", this); //Instanzación y construcción del scoreboard
endfunction


virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    for (int i=0; i<16; i++)begin
        a0.m0[i].mon_analysis_port.connect(sb0.m_analysis_exp); //conexión de los puertos de análisis del monitor con el scoreboard
        a0.d0[i].drv_analysis_port.connect(sb0.drv_analysis_exp); //conexión de los puertos de análisis del driver con el scoreboard
    end
endfunction

endclass