module conversor_bcd_ascii (

    input logic  [15 : 0]   data_i,

    output logic [31 : 0]   ascii_1_o,
    output logic [31 : 0]   ascii_2_o,
    output logic [31 : 0]   ascii_3_o


);

    always_comb 
        begin

            ascii_1_o = {28'h3, data_i[11:8]};
            ascii_2_o = {28'h3, data_i[7:4]};
            ascii_3_o = {28'h3, data_i[3:0]};

        end




endmodule
