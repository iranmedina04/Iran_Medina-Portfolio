/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente módulo corresponde al test, en el cual se crean las pruebas del DUT 
////// 
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class test extends uvm_test;
`uvm_component_utils(test)
function new(string name = "test", uvm_component parent=null);
    super.new(name,parent);
endfunction

env   e0;
gen_item_seq seq;
virtual mesh_if vif;

//Creación de la interface virtual, instanzación del ambiente, y creación del sequence item
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0 = env::type_id::create("e0",this);
    if(!uvm_config_db#(virtual mesh_if)::get(this,"","mesh_vif",vif))
        `uvm_fatal("TEST","Didn't get vif")
    uvm_config_db#(virtual mesh_if)::set(this,"e0.a0.*","mesh_vif",vif);

    seq = gen_item_seq::type_id::create("seq");
    seq.randomize();
    //seq.fun_pckg();
    
endfunction


virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
    seq.start(e0.a0.s0);
    #2000;
    phase.drop_objection(this);
endtask

//Generación de un reset 
virtual task apply_reset();
    vif.rst_i <=1;
    repeat(5) @(posedge vif.clk_i);
    vif.rst_i <=0;
    repeat(10) @(posedge vif.clk_i);

endtask

endclass

//Test derivado del test base para enviar varias transacciones
class un_paquete extends test;
`uvm_component_utils(un_paquete)
function new(string name="un_paquete", uvm_component parent=null);
    super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    seq.randomize() with {numero_transacciones inside {[1:32]};};
    //seq.fun_pckg();

endfunction    


endclass