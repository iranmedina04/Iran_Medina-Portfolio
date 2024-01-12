/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde al driver, este es el que tiene conocimiento sobre cómo conducir las señales 
////// a la interfaz
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class driver extends uvm_driver #(mesh_item);

    `uvm_component_utils(driver)


    sim_fifo fifo_entrada;
    int id_terminal;
    logic [`PAKG_SIZE-1:0] dato_pop;
    mesh_item m_item;

    function new(string name = "driver", uvm_component parent = null);

        super.new(name, parent);

    endfunction

    virtual mesh_if vif;

    uvm_analysis_port #(mesh_item) drv_analysis_port;

    //Manejador de interface virtual

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        drv_analysis_port = new("drv_analysis_port", this);

        if(!uvm_config_db#(virtual mesh_if)::get(this, "", "mesh_vif", vif))
            `uvm_fatal("DRV", "Could not get vif" )

    endfunction

    //Codificación de fase de corrida
    
    virtual task run_phase(uvm_phase phase);

        super.run_phase(phase);
        fifo_entrada=new();
        vif.dato_out_i_in [id_terminal] = '0;
        vif.pdng_i_in [id_terminal] = '0;
        
        forever begin

            @(posedge vif.clk_i);

            
            `uvm_info("DRV", $sformatf("Wait for the sequencer"), UVM_HIGH);
            seq_item_port.get_next_item(m_item);

            if( m_item.terminal_envio == id_terminal) begin
                drive_item(m_item);
            end

            if(vif.popin[id_terminal]) begin
      
                // Si hay algo en la fifo el pending está en alto

                dato_pop = fifo_entrada.pop();

                @(posedge vif.clk_i);
                
                if (fifo_entrada.sizes() > 0) begin
                    
                    vif.pdng_i_in[id_terminal] = '1;
                    vif.dato_out_i_in [id_terminal] = fifo_entrada.fifo_sim[0];

                end else begin
                    
                    vif.pdng_i_in[id_terminal] = '0;
                    vif.dato_out_i_in [id_terminal] = '0;

                end

            end
            
            seq_item_port.item_done();

        end

    endtask

    virtual task drive_item(mesh_item item);

        fifo_entrada.push(item.pckg);
        vif.pdng_i_in[id_terminal] = '1;
        vif.dato_out_i_in [id_terminal] = fifo_entrada.fifo_sim[0];
        item.tiempo_envio = $time;
        item.tipo = escritura;
        item.cal_terminal_recibido();
        drv_analysis_port.write(item);

    endtask

endclass