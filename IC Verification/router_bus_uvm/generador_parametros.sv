/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// 
////// El siguiente módulo corresponde al generador de parámetros. Este se encarga de aleatorizar los parámetros en este
////// caso la profundidad de las fifos
//////
////// Autores:
//////  Irán Medina Aguilar
//////  Ivannia Fernandez Rodriguez
//////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module generador_parametros;

    class A;

        integer f;

        rand int unsigned PAKG_SIZE;
        rand int unsigned FIFO_DEPTH;

        constraint C2 { PAKG_SIZE >= 32; PAKG_SIZE < 41; }
        constraint C3 { FIFO_DEPTH > 0; FIFO_DEPTH < 17;}
        

        function void printPackage;
            f = $fopen("my_package.sv", "w");
            $fdisplay(f, "`define PAKG_SIZE %0d", PAKG_SIZE );
            $fdisplay(f, "`define FIFO_DEPTH %0d", FIFO_DEPTH );
        endfunction
    
    endclass

A a;

initial begin
    a = new();
    a.randomize();
    a.printPackage();
end

endmodule