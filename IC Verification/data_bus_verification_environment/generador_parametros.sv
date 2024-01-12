module generador_parametros;

    class A;

        integer f;

        rand int unsigned BITS;
        rand int unsigned DRIVERS;
        rand int unsigned WIDTH;
        rand int unsigned BROADCAST;
        rand int unsigned PROFUNDIDAD;


        constraint C0 { BITS == 1;}
        constraint C1 { DRIVERS < 17; DRIVERS > 1;}
        constraint C2 { WIDTH == 32;}
        constraint C3 { BROADCAST == {8{1'b1}};}
        constraint C4 { PROFUNDIDAD > 0 ; PROFUNDIDAD < 17;}

        function void printPackage;
            f = $fopen("my_package.sv", "w");
            $fdisplay(f, "package my_package;");
            $fdisplay(f, "  parameter bits = %0d;", BITS);
            $fdisplay(f, "  parameter drivers = %0d;", DRIVERS );
            $fdisplay(f, "  parameter width = %0d;", WIDTH );
            $fdisplay(f, "  parameter broadcast = %0d;", BROADCAST );
            $fdisplay(f, "  parameter profundidad = %0d;", PROFUNDIDAD );
            $fdisplay(f, "endpackage");
        endfunction
    
    endclass

A a;

initial begin
    a = new();
    a.randomize();
    a.printPackage();
end

endmodule