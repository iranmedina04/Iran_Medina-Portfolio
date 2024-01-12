/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al monitor, este se encarga de capturar la actividad de la señal de la interfaz
////// y la traduce en objetos de datos que pueden ser enviados a otros componentes
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
function new(string name= "monitor", uvm_component parent=null);
    super.new(name,parent);
endfunction

//Declaración de puertos y manejadores de la interface virtual 
uvm_analysis_port #(mesh_item) mon_analysis_port;
virtual mesh_if vif;
int id_terminal;

//Construcción del monitor
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mesh_if)::get(this,"","mesh_vif",vif))
        `uvm_fatal("MON","Could not get vif")
    mon_analysis_port = new ("mon_analysis_port", this);
endfunction

//Codificación de la fase de run
virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

        vif.pop[id_terminal] = '0;

    forever begin
        @(posedge vif.clk_i);

            if (vif.pndng[id_terminal]) begin

                mesh_item item = mesh_item::type_id::create("item");
                item.tiempo_recibido = $time;
                item.terminal_recibido = id_terminal;  //Asigna a la terminal de recibido el id de la terminal enviado por el agente
                item.pckg = vif.data_out[id_terminal]; //Asigna al paquete el valor del dato de salida de la interface virtual
                item.tipo = lectura; //Define que el item es de tipo lectura
                mon_analysis_port.write(item); //Escribe lo que contiene el item en el puerto de análisis
                `uvm_info("MON", $sformatf("Monitor found a package"),UVM_HIGH)
                vif.pop[id_terminal] = '1;
                @(posedge vif.clk_i);
                vif.pop[id_terminal] = '0;
            end    

    end

endtask   

endclass