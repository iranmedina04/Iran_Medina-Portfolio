`timescale 10ns/1ps
`include "interfaces_transacciones.sv"
`include "drv_mon.sv"
`default_nettype none

module prueba_driver();

    reg clk = 0;
    parameter bits = 1;
    parameter drivers = 2;
    parameter width = 32;
    parameter broadcast = {8{1'b1}};
    
    bus_if #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) _if(.clk_i(clk));
    always #5 clk = ~clk;

    trans_bus transaccion;
    trans_bus transaccion_rec;
    trans_bus_mbx agnt_drv_mbx;
    trans_bus_mbx mon_ckcr_mbx;

    drv_mon #(.bits(bits), .drivers(drivers), .width(width), .broadcast(broadcast)) driv_mon;

    initial begin

        $display("Inicio del testbench");

        driv_mon = new(.id(0));
        transaccion = new();
        transaccion_rec = new();
        agnt_drv_mbx = new();
        mon_ckcr_mbx = new();
        transaccion.randomize();
        transaccion.terminal_envio = 0;
        driv_mon.vif = _if;
        driv_mon.agnt_drv_mbx = agnt_drv_mbx;
        driv_mon.mon_ckcr_mbx =mon_ckcr_mbx;
       
       
        @(posedge _if.clk_i);
        fork
            begin
                driv_mon.run();
            end
            
            begin    
                @(posedge _if.clk_i);
                @(posedge _if.clk_i);
                @(posedge _if.clk_i);
                agnt_drv_mbx.put(transaccion);
                $display("Se guardó la transaccion [%t]", $time);
                @(posedge _if.clk_i);
                @(posedge _if.clk_i);
                

                if(_if.pndng_i[0][0]) begin

                    $display("El pending si se puso en 1 para el tiempo [%t]", $time);
                    

                end
                else begin
                
                    $display("El pending no se puso en 1 para el tiempo [%t]", $time);
                
                end
                
            
                @(posedge _if.clk_i);
                _if.pop_o[0][0] = '1;
                @(posedge _if.clk_i);
                _if.pop_o[0][0] = '0;
                @(posedge _if.clk_i);
                
                if(!_if.pndng_i[0][0]) begin

                    $display("El pending si se puso en 0 cuando se vacio la terminal para el tiempo [%t]", $time);
                   

                end
                else begin
                
                    $display("El pending no se puso en 0 cuando se vacio la terminal para el tiempo [%t]", $time);
                
                end

                _if.d_push_o[0][0] = 32'd2;
                @(posedge _if.clk_i);
                _if.push_o[0][0] = '1;
                @(posedge _if.clk_i);
                _if.push_o[0][0] = '0;
                @(posedge _if.clk_i);

                mon_ckcr_mbx.get(transaccion_rec);
                transaccion_rec.print();
                $finish;

            end
        join_none
    end

endmodule
