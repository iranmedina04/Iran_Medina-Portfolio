/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo corresponde el scoreboard, el cual se encarga de comparar los resultados esperados con los
////// datos de salida reales del DUT y genera los reportes de estos 
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)


    function new(string name = "scoreboard", uvm_component parent = null);

        super.new(name, parent);

    endfunction

    // Variables para verificacion

    mesh_item transaciones_enviadas [$];
    mesh_item transaciones_recibidas [$];
    mesh_item transaciones_verificadas [$];
    
    int match;

    // Variables para el reporte


    int tiempo;
    int tpromedio;
    int bw;
    string filename;
    string linea;
    string linea_agregar;
    integer archivo_1;
    integer archivo_2;
    string informacion [$];

    uvm_analysis_imp #(mesh_item, scoreboard) m_analysis_exp;
    uvm_analysis_imp #(mesh_item, scoreboard) drv_analysis_exp;

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        m_analysis_exp = new("m_analysis_exp", this);
        drv_analysis_exp = new("drv_analysis_exp", this);

    endfunction

    virtual function void write (mesh_item item);

        if(item.tipo == escritura) begin

            transaciones_enviadas.push_back(item);

        end
        else if (item.tipo == lectura)begin

            transaciones_recibidas.push_back(item);

        end
        else begin

            `uvm_info("SCBD", $sformatf("Llego una transaccio con un tipo desconocido"), UVM_LOW)

        end

    endfunction

//Comparación de datos
    virtual function void check_phase (uvm_phase phase);

        super.check_phase(phase);

        for (int i = 0; i < transaciones_recibidas.size(); i++ ) begin

            match = 0;

            for (int j =0 ; j < transaciones_enviadas.size() ; j++ ) begin

                if(transaciones_recibidas[i].pckg[`PAKG_SIZE - 18 : 0] == transaciones_enviadas[j].pckg[`PAKG_SIZE - 18 : 0]) begin

                    if (transaciones_recibidas[i].tiempo_recibido >= transaciones_enviadas[j].tiempo_envio) begin
                        
                        if (transaciones_recibidas[i].terminal_recibido == transaciones_enviadas[j].terminal_recibido) begin
                            
                            transaciones_recibidas[i].terminal_envio =  transaciones_enviadas[j].terminal_envio;
                            transaciones_recibidas[i].tiempo_envio =  transaciones_enviadas[j].tiempo_envio;
                            transaciones_recibidas[i].tiempo_retardo = transaciones_enviadas[j].tiempo_retardo;
                            transaciones_recibidas[i].latencia = transaciones_recibidas[i].tiempo_recibido - transaciones_recibidas[i].tiempo_envio;
                            transaciones_verificadas.push_back(transaciones_recibidas[i]);
                            match = match + 1;

                        end

                    end

                end

                
            end
            
            if (match == 0) begin
                
                `uvm_info("SCBD", $sformatf("Trasacciones recibida\n"), UVM_HIGH)
                transaciones_recibidas[i].print();
                `uvm_info("SCBD", $sformatf("Trasacciones enviadas\n"), UVM_HIGH)
                for (int j = 0 ; j < transaciones_enviadas.size() ; j++ ) begin
                
                    transaciones_enviadas[j].print();

                end
                `uvm_error("SCBD", $sformatf("Error: Se encontró una transaccion  que nunca fue enviada"))

            end

        end

    endfunction

    //Generación de los reportes de transacciones
    virtual function void report_phase(uvm_phase phase);
         super.report_phase(phase);      

        `uvm_info("SCBD", $sformatf("Se iniciará con el reporte\n"), UVM_NONE)

        bw = 0;
        tpromedio = 0;
         tiempo = 0;
        linea = "";
        linea_agregar = "";
        informacion = {};

        for (int i=0; i < transaciones_verificadas.size(); ++i) begin
                            
                            
                mesh_item transaccion_auxiliar = mesh_item::type_id::create("transaccion_auxiliar");
                transaccion_auxiliar.copy(transaciones_verificadas[i]);
                 transaccion_auxiliar.print();
                tiempo = tiempo + transaccion_auxiliar.latencia;
                            
                $sformat(linea_agregar, "%h,%g,%g,%g,%g,%g,%g\n", 
                           
                transaccion_auxiliar.pckg,
                transaccion_auxiliar.tiempo_envio,
                transaccion_auxiliar.tiempo_recibido,
                transaccion_auxiliar.terminal_envio,
                transaccion_auxiliar.terminal_recibido,
                transaccion_auxiliar.latencia,
                `FIFO_DEPTH   
                                    
            );

            informacion.push_back(linea_agregar);
            
        end

        archivo_1 = $fopen("Reporte_transacciones.csv", "a" );
                        
        for (int i=0; i<informacion.size(); ++i) begin

            $fwrite(archivo_1, "%s", informacion[i]);
                            
        end
                        
        $fclose(archivo_1);

        tpromedio = tiempo / transaciones_verificadas.size();

        bw =  `PAKG_SIZE * 10e9 / (tpromedio);  

        archivo_2 = $fopen("Reporte_Anchos_de_banda_Tiempo_promedio.csv", "a" );

        $sformat (linea, "\n%g,%g,%g,%g,%g,%g", `ROWS, `COLUMNS, `FIFO_DEPTH, `PAKG_SIZE, tpromedio, bw);
                            
        $fwrite(archivo_2, "%s", linea);

        $fclose(archivo_2);

    endfunction

endclass