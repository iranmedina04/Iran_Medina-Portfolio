/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente archivo contiene la cobertura funcional.
////// 
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class coverage #(parameter PAKG_SIZE= 32);

    covergroup filas;

        coverpoint testbench.DUT.data_out[0][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[1][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[2][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[3][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[4][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[5][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[6][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[7][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[8][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[9][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[10][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[11][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[12][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[13][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[14][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}
        coverpoint testbench.DUT.data_out[15][PAKG_SIZE-9:PAKG_SIZE-12] {bins fila = {[0:5]};}

    endgroup

    covergroup columnas;

        coverpoint testbench.DUT.data_out[0][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[1][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[2][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[3][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[4][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[5][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[6][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[7][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[8][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[9][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[10][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[11][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[12][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[13][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[14][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}
        coverpoint testbench.DUT.data_out[15][PAKG_SIZE-13:PAKG_SIZE-16] {bins columna = {[0:5]};}

    endgroup

    covergroup pops;
		coverpoint testbench.DUT.pop[0] {bins pop = {1};}
		coverpoint testbench.DUT.pop[1] {bins pop = {1};}
		coverpoint testbench.DUT.pop[2] {bins pop = {1};}
		coverpoint testbench.DUT.pop[3] {bins pop = {1};}
		coverpoint testbench.DUT.pop[4] {bins pop = {1};}
		coverpoint testbench.DUT.pop[6] {bins pop = {1};}
        coverpoint testbench.DUT.pop[7] {bins pop = {1};}
        coverpoint testbench.DUT.pop[8] {bins pop = {1};}
        coverpoint testbench.DUT.pop[9] {bins pop = {1};}
        coverpoint testbench.DUT.pop[10] {bins pop = {1};}
		coverpoint testbench.DUT.pop[11] {bins pop = {1};}
        coverpoint testbench.DUT.pop[12] {bins pop = {1};}
        coverpoint testbench.DUT.pop[13] {bins pop = {1};}
        coverpoint testbench.DUT.pop[14] {bins pop = {1};}
        coverpoint testbench.DUT.pop[15] {bins pop = {1};}

	endgroup
    
    function new();
        filas = new();
        columnas = new();
        pops = new();

    endfunction 

    task run();
		forever begin 
			#25
			filas.sample();
			columnas.sample();
			pops.sample();
		end
	endtask

    function print_cobertura();

        $display("Cobertura de filas: %0.2f", filas.get_coverage(),$time);
		$display("Cobertura de columnas: %0.2f", columnas.get_coverage(),$time);
		$display("Cobertura de pops: %0.2f", pops.get_coverage(),$time);
    endfunction

endclass 

 