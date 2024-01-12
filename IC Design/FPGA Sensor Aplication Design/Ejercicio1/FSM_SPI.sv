`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2023 04:05:18 PM
// Design Name: 
// Module Name: FSM_SPI
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FSM_SPI #( BITS_ADDRS = 5) 
    (
    input  logic                    clk_i,
    input  logic                    rst_i,
    input  logic [31:0]             inst_i,
    input  logic                    reg_dat_i,//recordar que es bit por  bit
    
    output logic                    ss_o,
    output logic                    mosi_o,
    output logic                    sclk_o,
    output logic                    wr1_o,
    output logic [31:0]             in1_o,
    output logic                    wr2_o,
    output logic [BITS_ADDRS - 1:0] addr2_o,
    output logic                    hold_ctrl_o,
    output logic                    en_dat_i,
    output logic                    psclk_o,
    output logic                    nsclk_o
    );
    
    localparam [2:0] cuenta = 3'd5; //Cuenta hacia abajo
    localparam [3:0] bits   = 4'd7; //Cuenta la cantidad de bits enviados por transaccion
    
    typedef enum logic [3:0]{
        ESPERA_INST_E,
        TODOS_UNO_TODOS_CEROS_E,
        ESCRIBE_REGISTRO_E,
        PREPARA_PARA_ENVIAR_E,
        DELAY_SCLK_1_E,
        PREPARA_PARA_RECIBIR_E,
        DELAY_SCLK_0_E,
        GUARDA_DATO_RECIBIDO_E,
        TRANSACCIONES_E,
        REESCRIBE_INST_E
    } 
    estado_t ;
    
    estado_t estado_actual , estado_siguiente ;
    logic [2:0]              contador; //Contador que cambia secuencialmente
    logic [2:0]              contador_comb;//Contador que cambia combinacionalmente
    
    logic [3:0]              bits_enviados; //Contador de bits enviados
    logic [3:0]              bits_enviados_comb;//Contador de bits enviados combinacional
    
    logic [8:0]              transacciones; //Contador de transaciones secuencial
    logic [8:0]              transacciones_comb;//Contador de taransacciones combinacional
    
    logic [9:0]              transac_sum;//contador de transacciones realizadas
    logic [9:0]              transac_sum_comb;//contador de transacciones realizadas combinacional
    
    logic                    sclk_comb;
    
    logic [BITS_ADDRS - 1:0] addr2_comb;//Incremento en la direccion del addres
    
    always_ff @ ( posedge clk_i , posedge rst_i ) begin
        if ( rst_i )
            estado_actual <= ESPERA_INST_E ;
        else 
            estado_actual <= estado_siguiente ;
    
    end 
    
    always_ff @ ( posedge clk_i , posedge rst_i ) begin
        if ( rst_i ) begin
            contador      <= cuenta ;
            bits_enviados <= bits;
            transacciones <= 0;
            addr2_o       <= 0;
            transac_sum   <= 1;
            sclk_o        <= 0;
            end
            
        else begin
            contador      <= contador_comb ;
            bits_enviados <= bits_enviados_comb;
            transacciones <= transacciones_comb;
            addr2_o       <= addr2_comb;
            transac_sum   <= transac_sum_comb;
            sclk_o        <= sclk_comb;
            end
    
    end 
    
    always_comb begin  //Cabmbio entre estados
        case ( estado_actual )
            ESPERA_INST_E: begin
            
                if ((inst_i[0] && inst_i[1]) == 1)// Verifica el send y el chip control
                    estado_siguiente = TODOS_UNO_TODOS_CEROS_E;
                    
                else
                    estado_siguiente = ESPERA_INST_E;
                    
            end 
            
            TODOS_UNO_TODOS_CEROS_E: begin
                if ((inst_i[2] == 1) | (inst_i[3] == 1))
                    estado_siguiente = PREPARA_PARA_ENVIAR_E;
                else 
                    estado_siguiente = ESCRIBE_REGISTRO_E;
            end

            ESCRIBE_REGISTRO_E: begin
                estado_siguiente = PREPARA_PARA_ENVIAR_E;
            end
            
            PREPARA_PARA_ENVIAR_E: begin
                estado_siguiente = DELAY_SCLK_1_E;
            end
            
            DELAY_SCLK_1_E: begin
                if (contador > 0)
                    estado_siguiente = DELAY_SCLK_1_E;
                else
                    estado_siguiente = PREPARA_PARA_RECIBIR_E;
            end
            
            PREPARA_PARA_RECIBIR_E: begin 
                estado_siguiente = DELAY_SCLK_0_E;
            end
            
            DELAY_SCLK_0_E: begin
                if (bits_enviados == 0)
                    estado_siguiente = GUARDA_DATO_RECIBIDO_E;
                    
                else if (contador > 0)
                    estado_siguiente = DELAY_SCLK_0_E;
                    
                else
                    estado_siguiente = PREPARA_PARA_ENVIAR_E;
            end
            
            GUARDA_DATO_RECIBIDO_E: begin
                estado_siguiente = TRANSACCIONES_E;
            end
            
            TRANSACCIONES_E: begin
            
                if (transacciones == 0)
                    estado_siguiente = REESCRIBE_INST_E;
                    
                else 
                    estado_siguiente = TODOS_UNO_TODOS_CEROS_E;
            end
            
            REESCRIBE_INST_E: begin
                estado_siguiente = ESPERA_INST_E;
            end
            
            default:
                estado_siguiente = ESPERA_INST_E;
        endcase
    end
    
    always_comb begin  //Cambio de salidas
    
        case ( estado_actual )
            ESPERA_INST_E: begin
            
                if ((inst_i[0] && inst_i[1]) == 1) begin// Verifica el send y el chip control
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb          = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = 0;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = inst_i[12:4] + 1;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                    end
                    
                else begin
                    ss_o               = 1;
                    mosi_o             = 0;
                    sclk_comb          = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = 0;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = 0;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                    end
                    
            end 
            
            TODOS_UNO_TODOS_CEROS_E: begin
            
                if ( inst_i[2] == 1 ) begin //all 1
                    ss_o               = 0;
                    mosi_o             = 1;
                    sclk_comb            = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                end
                
                else if (inst_i [3] == 1 ) begin
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb            = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                end
                
                else begin
                    ss_o               = 0;
                    mosi_o             = reg_dat_i;
                    sclk_comb            = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 1;
                    en_dat_i           = 1;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                end
                    
            end

            ESCRIBE_REGISTRO_E: begin
                ss_o               = 0;
                mosi_o             = reg_dat_i;
                sclk_comb             = 0;
                wr1_o              = 0;
                in1_o              = 0;
                wr2_o              = 0;
                addr2_comb         = addr2_o;
                hold_ctrl_o        = 0;
                en_dat_i           = 0;
                contador_comb      = contador;
                bits_enviados_comb = bits_enviados;
                transacciones_comb = transacciones;
                transac_sum_comb   = transac_sum;
                psclk_o            = 0;
                nsclk_o            = 0;
            end
            
            PREPARA_PARA_ENVIAR_E: begin
                if ( inst_i[2] == 1 ) begin
                    ss_o               = 0;
                    mosi_o             = 1;
                    sclk_comb             = 1;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 1;
                    nsclk_o            = 0;
                end
                
                else if (inst_i [3] == 1 ) begin
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb             = 1;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 1;
                    nsclk_o            = 0;
                end
                
                else begin
                    ss_o               = 0;
                    mosi_o             = reg_dat_i;
                    sclk_comb             = 1;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 1;
                    nsclk_o            = 0;
                end
            end
            
            DELAY_SCLK_1_E: begin
                if (contador > 0) begin
                    if ( inst_i[2] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 1;
                        sclk_comb           = 1;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = contador - 1;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                
                    else if (inst_i [3] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 0;
                        sclk_comb            = 1;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = contador - 1;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                    
                    else begin
                        ss_o               = 0;
                        mosi_o             = reg_dat_i;
                        sclk_comb           = 1;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = contador - 1;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                    end
                    
                    
                    
                    
                else begin
                    if ( inst_i[2] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 1;
                        sclk_comb             = 1;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = cuenta;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                    end
                    
                    else if (inst_i [3] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 0;
                        sclk_comb             = 1;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = cuenta;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                    end
                    
                    else begin
                        ss_o               = 0;
                        mosi_o             = reg_dat_i;
                        sclk_comb             = 1;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = cuenta;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                    end
                end
            end
            
            PREPARA_PARA_RECIBIR_E: begin 
                if ( inst_i[2] == 1 ) begin
                    ss_o               = 0;
                    mosi_o             = 1;
                    sclk_comb             = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 1;
                end
                
                else if (inst_i [3] == 1 ) begin
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb             = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 1;
                end
                
                else begin
                    ss_o               = 0;
                    mosi_o             = reg_dat_i;
                    sclk_comb            = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = contador;
                    bits_enviados_comb = bits_enviados;
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 1;
                end
            end
            
            DELAY_SCLK_0_E: begin
            
                if (bits_enviados == 0) begin
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb             = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 1;
                    addr2_comb         = addr2_o;
                    hold_ctrl_o        = 1;
                    en_dat_i           = 0;
                    contador_comb      = cuenta;
                    bits_enviados_comb = bits;              
                    transacciones_comb = transacciones - 1;
                    transac_sum_comb   = transac_sum  + 1;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                    end
            

                else if (contador > 0) begin
                    if ( inst_i[2] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 1;
                        sclk_comb            = 0;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = contador - 1;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                
                    else if (inst_i [3] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 0;
                        sclk_comb            = 0;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = contador - 1;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0; 
                        end
                    
                    else begin
                        ss_o               = 0;
                        mosi_o             = reg_dat_i;
                        sclk_comb            = 0;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = contador - 1;
                        bits_enviados_comb = bits_enviados;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                end

                else begin
                    if ( inst_i[2] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 1;
                        sclk_comb             = 0;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = cuenta;
                        bits_enviados_comb = bits_enviados - 1;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                
                    else if (inst_i [3] == 1 ) begin
                        ss_o               = 0;
                        mosi_o             = 0;
                        sclk_comb            = 0;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = cuenta;
                        bits_enviados_comb = bits_enviados - 1;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                    
                    else begin
                        ss_o               = 0;
                        mosi_o             = reg_dat_i;
                        sclk_comb            = 0;
                        wr1_o              = 0;
                        in1_o              = 0;
                        wr2_o              = 0;
                        addr2_comb         = addr2_o;
                        hold_ctrl_o        = 0;
                        en_dat_i           = 0;
                        contador_comb      = cuenta;
                        bits_enviados_comb = bits_enviados - 1;
                        transacciones_comb = transacciones;
                        transac_sum_comb   = transac_sum;
                        psclk_o            = 0;
                        nsclk_o            = 0;
                        end
                end
                
            end
            
            GUARDA_DATO_RECIBIDO_E: begin
                ss_o               = 0;
                mosi_o             = 0;
                sclk_comb             = 0;
                wr1_o              = 0;
                in1_o              = 0;
                wr2_o              = 0;
                addr2_comb         = addr2_o;
                hold_ctrl_o        = 1;
                en_dat_i           = 0;
                contador_comb      = cuenta;
                bits_enviados_comb = bits;              
                transacciones_comb = transacciones;
                transac_sum_comb   = transac_sum;
                psclk_o            = 0;
                nsclk_o            = 0;
                end
                
            TRANSACCIONES_E: begin
            
                if (transacciones == 0) begin
                
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb          = 0;
                    wr1_o              = 1;
                    in1_o              = {6'd0, transac_sum, 3'd0, inst_i[12:1], 1'b0}; //El send debe estar en 0
                    wr2_o              = 0;
                    addr2_comb         = 0;
                    hold_ctrl_o        = 1;
                    en_dat_i           = 0;
                    contador_comb      = cuenta;
                    bits_enviados_comb = bits;              
                    transacciones_comb = 0; //Dejar en 0 o poner la cantidad de transacciones de la instruccion
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                    end
                    
                else begin
                    ss_o               = 0;
                    mosi_o             = 0;
                    sclk_comb          = 0;
                    wr1_o              = 0;
                    in1_o              = 0;
                    wr2_o              = 0;
                    addr2_comb         = addr2_o + 1;
                    hold_ctrl_o        = 0;
                    en_dat_i           = 0;
                    contador_comb      = cuenta;
                    bits_enviados_comb = bits;              
                    transacciones_comb = transacciones;
                    transac_sum_comb   = transac_sum;
                    psclk_o            = 0;
                    nsclk_o            = 0;
                    end
                    
            end
            
            REESCRIBE_INST_E: begin
                ss_o               = 0; //Error previo
                mosi_o             = 0;
                sclk_comb          = 0;
                wr1_o              = 0;
                in1_o              = 0;
                wr2_o              = 0;
                addr2_comb         = 0;
                hold_ctrl_o        = 0;
                en_dat_i           = 0;
                contador_comb      = cuenta;
                bits_enviados_comb = bits;              
                transacciones_comb = 0;
                transac_sum_comb   = transac_sum;
                psclk_o            = 0;
                nsclk_o            = 0;
            end
            
            default: begin
                ss_o               = 1;
                mosi_o             = 0;
                sclk_comb          = 0;
                wr1_o              = 0;
                in1_o              = 0;
                wr2_o              = 0;
                addr2_comb         = 0;
                hold_ctrl_o        = 0;
                en_dat_i           = 0;
                contador_comb      = contador;
                bits_enviados_comb = bits_enviados;
                transacciones_comb = 0;
                transac_sum_comb   = transac_sum;
                psclk_o            = 0;
                nsclk_o            = 0;
                end
        endcase
    end

endmodule

