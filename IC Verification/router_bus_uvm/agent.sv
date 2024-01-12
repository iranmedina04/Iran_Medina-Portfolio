/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al agente, el cual contiene al driver, el monitor y el secuenciador
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class agent extends uvm_agent;
`uvm_component_utils(agent)
function new(string name="agent", uvm_component parent=null);
    super.new(name,parent);
endfunction

driver                   d0[15:0];
monitor                  m0[15:0];
uvm_sequencer #(mesh_item)    s0;

//Declaración de los componentes del agente
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s0 = uvm_sequencer#(mesh_item)::type_id::create("s0",this); //Instancia y construcción del secuenciador
    for (int i=0; i<16; i++)begin
        d0[i] = driver::type_id::create($sformatf("d%0d",i),this); //Instancia y construcción de los 16 drivers
        m0[i] = monitor::type_id::create($sformatf("m%0d",i),this); //Instancia y construcción de los 16 monitores
    end
endfunction    

//Conexión de los componentes del agente
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     for (int i=0; i<16; i++)begin
        d0[i].id_terminal = i;
        m0[i].id_terminal = i;
        d0[i].seq_item_port.connect(s0.seq_item_export);
    end
endfunction

endclass