//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Corresponde al elemento que realizará las secuencias según la transacción
//  Este generá de 1 a 32 transacciones 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class gen_item_seq extends uvm_sequence;

    `uvm_object_utils (gen_item_seq)

    function new( string name = "gen_item_seq");

        super.new(name);

    endfunction

    rand int numero_transacciones;
    
    constraint transaccion_rand {numero_transacciones inside {[1: 32]};} //Delimita la cantidad de transacciones de 1 a 32

    virtual task body();

        for (int i = 0; i < numero_transacciones; i++ ) begin
            
            mesh_item m_item = mesh_item::type_id::create("m_item");
            start_item(m_item);
            m_item.randomize(); //Randomiza los valores 
            m_item.fun_pckg(); //Crea el paquete
            `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
            m_item.print();
            finish_item(m_item); //Guarda

        end

        `uvm_info("SEQ", $sformatf("Done generation of %d items", numero_transacciones), UVM_LOW)

    endtask

endclass