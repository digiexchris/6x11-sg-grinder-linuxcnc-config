/*
    ######### IceShield #########


    Toolchain : icestorm
    Family    : ice40
    Type      : up5k
    Package   : sg48
    Clock     : 29.812 Mhz

    PINOUT_BLINK0_LED -> LED:G 
    PININ_SPI1_MOSI <- 14 
    PINOUT_SPI1_MISO -> 17 
    PININ_SPI1_SCLK <- 15 
    PININ_SPI1_SEL <- 32 
    PINOUT_BITOUT2_BIT -> 45 
    PINOUT_STEPDIR3_STEP -> 13 
    PINOUT_STEPDIR3_DIR -> 12 
    PINOUT_STEPDIR4_STEP -> 11 
    PINOUT_STEPDIR4_DIR -> 10 
    PINOUT_STEPDIR5_STEP -> 9 
    PINOUT_STEPDIR5_DIR -> 6 
    PINOUT_STEPDIR6_STEP -> 4 
    PINOUT_STEPDIR6_DIR -> 3 
    PINOUT_STEPDIR7_STEP -> 2 
    PINOUT_STEPDIR7_DIR -> 48 
    PINOUT_STEPDIR8_STEP -> 47 
    PINOUT_STEPDIR8_DIR -> 46 
    PINOUT_BITOUT9_BIT -> 44 
    PINOUT_BITOUT10_BIT -> 43 
    PINOUT_BITOUT11_BIT -> LED:R 
    PININ_BITIN12_BIT <- 41 PULL{pin_config.get('pull').upper()}
    PININ_BITIN13_BIT <- 40 PULL{pin_config.get('pull').upper()}
    PININ_BITIN14_BIT <- 39 PULL{pin_config.get('pull').upper()}
    PININ_BITIN15_BIT <- 38 PULL{pin_config.get('pull').upper()}
    PININ_BITIN16_BIT <- 37 PULL{pin_config.get('pull').upper()}
    PININ_BITIN17_BIT <- 36 PULL{pin_config.get('pull').upper()}
    PININ_BITIN18_BIT <- 42 PULL{pin_config.get('pull').upper()}
    PININ_BITIN19_BIT <- 34 PULL{pin_config.get('pull').upper()}

*/

/* verilator lint_off UNUSEDSIGNAL */

module rio (
        input sysclk_in,
        output PINOUT_BLINK0_LED,
        input PININ_SPI1_MOSI,
        output PINOUT_SPI1_MISO,
        input PININ_SPI1_SCLK,
        input PININ_SPI1_SEL,
        output PINOUT_BITOUT2_BIT,
        output PINOUT_STEPDIR3_STEP,
        output PINOUT_STEPDIR3_DIR,
        output PINOUT_STEPDIR4_STEP,
        output PINOUT_STEPDIR4_DIR,
        output PINOUT_STEPDIR5_STEP,
        output PINOUT_STEPDIR5_DIR,
        output PINOUT_STEPDIR6_STEP,
        output PINOUT_STEPDIR6_DIR,
        output PINOUT_STEPDIR7_STEP,
        output PINOUT_STEPDIR7_DIR,
        output PINOUT_STEPDIR8_STEP,
        output PINOUT_STEPDIR8_DIR,
        output PINOUT_BITOUT9_BIT,
        output PINOUT_BITOUT10_BIT,
        output PINOUT_BITOUT11_BIT,
        input PININ_BITIN12_BIT,
        input PININ_BITIN13_BIT,
        input PININ_BITIN14_BIT,
        input PININ_BITIN15_BIT,
        input PININ_BITIN16_BIT,
        input PININ_BITIN17_BIT,
        input PININ_BITIN18_BIT,
        input PININ_BITIN19_BIT
    );

    parameter BUFFER_SIZE = 16'd240; // 30 bytes

    reg INTERFACE_TIMEOUT = 0;
    reg ESTOP = 0;
    wire ERROR;
    wire INTERFACE_SYNC;
    assign ERROR = (INTERFACE_TIMEOUT | ESTOP);

    wire sysclk;
    wire locked;
    pll mypll(sysclk_in, sysclk, locked);

    parameter TIMEOUT = 32'd2981200;

    reg[2:0] INTERFACE_SYNCr;  always @(posedge sysclk) INTERFACE_SYNCr <= {INTERFACE_SYNCr[1:0], INTERFACE_SYNC};
    wire INTERFACE_SYNC_RISINGEDGE = (INTERFACE_SYNCr[2:1]==2'b01);

    localparam TIMEOUT_BITS = clog2(TIMEOUT + 1);
    reg [TIMEOUT_BITS:0] timeout_counter = 0;

    always @(posedge sysclk) begin
        if (INTERFACE_SYNC_RISINGEDGE == 1) begin
            timeout_counter <= 0;
        end else begin
            if (timeout_counter < TIMEOUT) begin
                timeout_counter <= timeout_counter + 1;
                INTERFACE_TIMEOUT <= 0;
            end else begin
                INTERFACE_TIMEOUT <= 1;
            end
        end
    end

    wire[239:0] rx_data;
    wire[239:0] tx_data;

    reg signed [31:0] header_tx;
    always @(posedge sysclk) begin
        if (ESTOP) begin
            header_tx <= 32'h65737470;
        end else begin
            header_tx <= 32'h64617461;
        end
    end

    wire VAROUT1_BITOUT2_BIT;
    wire [31:0] VAROUT32_STEPDIR3_VELOCITY;
    wire VAROUT1_STEPDIR3_ENABLE;
    wire [31:0] VARIN32_STEPDIR3_POSITION;
    wire [31:0] VAROUT32_STEPDIR4_VELOCITY;
    wire VAROUT1_STEPDIR4_ENABLE;
    wire [31:0] VARIN32_STEPDIR4_POSITION;
    wire [31:0] VAROUT32_STEPDIR5_VELOCITY;
    wire VAROUT1_STEPDIR5_ENABLE;
    wire [31:0] VARIN32_STEPDIR5_POSITION;
    wire [31:0] VAROUT32_STEPDIR6_VELOCITY;
    wire VAROUT1_STEPDIR6_ENABLE;
    wire [31:0] VARIN32_STEPDIR6_POSITION;
    wire [31:0] VAROUT32_STEPDIR7_VELOCITY;
    wire VAROUT1_STEPDIR7_ENABLE;
    wire [31:0] VARIN32_STEPDIR7_POSITION;
    wire [31:0] VAROUT32_STEPDIR8_VELOCITY;
    wire VAROUT1_STEPDIR8_ENABLE;
    wire [31:0] VARIN32_STEPDIR8_POSITION;
    wire VAROUT1_BITOUT9_BIT;
    wire VAROUT1_BITOUT10_BIT;
    wire VAROUT1_BITOUT11_BIT;
    wire VARIN1_BITIN12_BIT;
    wire VARIN1_BITIN13_BIT;
    wire VARIN1_BITIN14_BIT;
    wire VARIN1_BITIN15_BIT;
    wire VARIN1_BITIN16_BIT;
    wire VARIN1_BITIN17_BIT;
    wire VARIN1_BITIN18_BIT;
    wire VARIN1_BITIN19_BIT;

    // assign header_rx = {rx_data[215:208], rx_data[223:216], rx_data[231:224], rx_data[239:232]};
    assign VAROUT32_STEPDIR3_VELOCITY = {rx_data[183:176], rx_data[191:184], rx_data[199:192], rx_data[207:200]};
    assign VAROUT32_STEPDIR4_VELOCITY = {rx_data[151:144], rx_data[159:152], rx_data[167:160], rx_data[175:168]};
    assign VAROUT32_STEPDIR5_VELOCITY = {rx_data[119:112], rx_data[127:120], rx_data[135:128], rx_data[143:136]};
    assign VAROUT32_STEPDIR6_VELOCITY = {rx_data[87:80], rx_data[95:88], rx_data[103:96], rx_data[111:104]};
    assign VAROUT32_STEPDIR7_VELOCITY = {rx_data[55:48], rx_data[63:56], rx_data[71:64], rx_data[79:72]};
    assign VAROUT32_STEPDIR8_VELOCITY = {rx_data[23:16], rx_data[31:24], rx_data[39:32], rx_data[47:40]};
    assign VAROUT1_BITOUT2_BIT = {rx_data[15]};
    assign VAROUT1_STEPDIR3_ENABLE = {rx_data[14]};
    assign VAROUT1_STEPDIR4_ENABLE = {rx_data[13]};
    assign VAROUT1_STEPDIR5_ENABLE = {rx_data[12]};
    assign VAROUT1_STEPDIR6_ENABLE = {rx_data[11]};
    assign VAROUT1_STEPDIR7_ENABLE = {rx_data[10]};
    assign VAROUT1_STEPDIR8_ENABLE = {rx_data[9]};
    assign VAROUT1_BITOUT9_BIT = {rx_data[8]};
    assign VAROUT1_BITOUT10_BIT = {rx_data[7]};
    assign VAROUT1_BITOUT11_BIT = {rx_data[6]};
    // assign FILL = rx_data[5:0];

    assign tx_data = {
        header_tx[7:0], header_tx[15:8], header_tx[23:16], header_tx[31:24],
        VARIN32_STEPDIR3_POSITION[7:0], VARIN32_STEPDIR3_POSITION[15:8], VARIN32_STEPDIR3_POSITION[23:16], VARIN32_STEPDIR3_POSITION[31:24],
        VARIN32_STEPDIR4_POSITION[7:0], VARIN32_STEPDIR4_POSITION[15:8], VARIN32_STEPDIR4_POSITION[23:16], VARIN32_STEPDIR4_POSITION[31:24],
        VARIN32_STEPDIR5_POSITION[7:0], VARIN32_STEPDIR5_POSITION[15:8], VARIN32_STEPDIR5_POSITION[23:16], VARIN32_STEPDIR5_POSITION[31:24],
        VARIN32_STEPDIR6_POSITION[7:0], VARIN32_STEPDIR6_POSITION[15:8], VARIN32_STEPDIR6_POSITION[23:16], VARIN32_STEPDIR6_POSITION[31:24],
        VARIN32_STEPDIR7_POSITION[7:0], VARIN32_STEPDIR7_POSITION[15:8], VARIN32_STEPDIR7_POSITION[23:16], VARIN32_STEPDIR7_POSITION[31:24],
        VARIN32_STEPDIR8_POSITION[7:0], VARIN32_STEPDIR8_POSITION[15:8], VARIN32_STEPDIR8_POSITION[23:16], VARIN32_STEPDIR8_POSITION[31:24],
        VARIN1_BITIN12_BIT,
        VARIN1_BITIN13_BIT,
        VARIN1_BITIN14_BIT,
        VARIN1_BITIN15_BIT,
        VARIN1_BITIN16_BIT,
        VARIN1_BITIN17_BIT,
        VARIN1_BITIN18_BIT,
        VARIN1_BITIN19_BIT,
        8'd0
    };



    // Name: blink0 (blink)
    assign PINOUT_BLINK0_LED = PINOUT_BLINK0_LED_RAW;
    wire PINOUT_BLINK0_LED_RAW;
    blink #(
        .DIVIDER(14906000)
    ) blink0 (
        .clk(sysclk),
        .led(PINOUT_BLINK0_LED_RAW)
    );

    // Name: spi1 (spi)
    assign PINOUT_SPI1_MISO = PINOUT_SPI1_MISO_RAW;
    wire PINOUT_SPI1_MISO_RAW;
    spi #(
        .BUFFER_SIZE(BUFFER_SIZE),
        .MSGID(32'h74697277)
    ) spi1 (
        .clk(sysclk),
        .mosi(PININ_SPI1_MOSI),
        .miso(PINOUT_SPI1_MISO_RAW),
        .sclk(PININ_SPI1_SCLK),
        .sel(PININ_SPI1_SEL),
        .rx_data(rx_data),
        .tx_data(tx_data),
        .sync(INTERFACE_SYNC)
    );

    // Name: enable (bitout)
    wire PINOUT_BITOUT2_BIT_RAW_INVERTED;
    assign PINOUT_BITOUT2_BIT_RAW_INVERTED = ~PINOUT_BITOUT2_BIT_RAW;
    wire PINOUT_BITOUT2_BIT_RAW_INVERTED_ONERROR;
    assign PINOUT_BITOUT2_BIT_RAW_INVERTED_ONERROR = PINOUT_BITOUT2_BIT_RAW_INVERTED & ~ERROR;
    assign PINOUT_BITOUT2_BIT = PINOUT_BITOUT2_BIT_RAW_INVERTED_ONERROR;
    wire PINOUT_BITOUT2_BIT_RAW;
    assign PINOUT_BITOUT2_BIT_RAW = VAROUT1_BITOUT2_BIT;

    // Name: Stepper1 (stepdir)
    assign PINOUT_STEPDIR3_STEP = PINOUT_STEPDIR3_STEP_RAW;
    assign PINOUT_STEPDIR3_DIR = PINOUT_STEPDIR3_DIR_RAW;
    wire PINOUT_STEPDIR3_STEP_RAW;
    wire PINOUT_STEPDIR3_DIR_RAW;
    wire UNUSED_PIN_STEPDIR3_EN;
    stepdir stepdir3 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR3_STEP_RAW),
        .dir(PINOUT_STEPDIR3_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR3_EN),
        .velocity(VAROUT32_STEPDIR3_VELOCITY),
        .enable(VAROUT1_STEPDIR3_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR3_POSITION)
    );

    // Name: Stepper2 (stepdir)
    assign PINOUT_STEPDIR4_STEP = PINOUT_STEPDIR4_STEP_RAW;
    assign PINOUT_STEPDIR4_DIR = PINOUT_STEPDIR4_DIR_RAW;
    wire PINOUT_STEPDIR4_STEP_RAW;
    wire PINOUT_STEPDIR4_DIR_RAW;
    wire UNUSED_PIN_STEPDIR4_EN;
    stepdir stepdir4 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR4_STEP_RAW),
        .dir(PINOUT_STEPDIR4_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR4_EN),
        .velocity(VAROUT32_STEPDIR4_VELOCITY),
        .enable(VAROUT1_STEPDIR4_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR4_POSITION)
    );

    // Name: Stepper3 (stepdir)
    assign PINOUT_STEPDIR5_STEP = PINOUT_STEPDIR5_STEP_RAW;
    assign PINOUT_STEPDIR5_DIR = PINOUT_STEPDIR5_DIR_RAW;
    wire PINOUT_STEPDIR5_STEP_RAW;
    wire PINOUT_STEPDIR5_DIR_RAW;
    wire UNUSED_PIN_STEPDIR5_EN;
    stepdir stepdir5 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR5_STEP_RAW),
        .dir(PINOUT_STEPDIR5_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR5_EN),
        .velocity(VAROUT32_STEPDIR5_VELOCITY),
        .enable(VAROUT1_STEPDIR5_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR5_POSITION)
    );

    // Name: Stepper4 (stepdir)
    assign PINOUT_STEPDIR6_STEP = PINOUT_STEPDIR6_STEP_RAW;
    assign PINOUT_STEPDIR6_DIR = PINOUT_STEPDIR6_DIR_RAW;
    wire PINOUT_STEPDIR6_STEP_RAW;
    wire PINOUT_STEPDIR6_DIR_RAW;
    wire UNUSED_PIN_STEPDIR6_EN;
    stepdir stepdir6 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR6_STEP_RAW),
        .dir(PINOUT_STEPDIR6_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR6_EN),
        .velocity(VAROUT32_STEPDIR6_VELOCITY),
        .enable(VAROUT1_STEPDIR6_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR6_POSITION)
    );

    // Name: Stepper5 (stepdir)
    assign PINOUT_STEPDIR7_STEP = PINOUT_STEPDIR7_STEP_RAW;
    assign PINOUT_STEPDIR7_DIR = PINOUT_STEPDIR7_DIR_RAW;
    wire PINOUT_STEPDIR7_STEP_RAW;
    wire PINOUT_STEPDIR7_DIR_RAW;
    wire UNUSED_PIN_STEPDIR7_EN;
    stepdir stepdir7 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR7_STEP_RAW),
        .dir(PINOUT_STEPDIR7_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR7_EN),
        .velocity(VAROUT32_STEPDIR7_VELOCITY),
        .enable(VAROUT1_STEPDIR7_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR7_POSITION)
    );

    // Name: Stepper6 (stepdir)
    assign PINOUT_STEPDIR8_STEP = PINOUT_STEPDIR8_STEP_RAW;
    assign PINOUT_STEPDIR8_DIR = PINOUT_STEPDIR8_DIR_RAW;
    wire PINOUT_STEPDIR8_STEP_RAW;
    wire PINOUT_STEPDIR8_DIR_RAW;
    wire UNUSED_PIN_STEPDIR8_EN;
    stepdir stepdir8 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR8_STEP_RAW),
        .dir(PINOUT_STEPDIR8_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR8_EN),
        .velocity(VAROUT32_STEPDIR8_VELOCITY),
        .enable(VAROUT1_STEPDIR8_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR8_POSITION)
    );

    // Name: Output1 (bitout)
    wire PINOUT_BITOUT9_BIT_RAW_INVERTED;
    assign PINOUT_BITOUT9_BIT_RAW_INVERTED = ~PINOUT_BITOUT9_BIT_RAW;
    assign PINOUT_BITOUT9_BIT = PINOUT_BITOUT9_BIT_RAW_INVERTED;
    wire PINOUT_BITOUT9_BIT_RAW;
    assign PINOUT_BITOUT9_BIT_RAW = VAROUT1_BITOUT9_BIT;

    // Name: Output2 (bitout)
    wire PINOUT_BITOUT10_BIT_RAW_INVERTED;
    assign PINOUT_BITOUT10_BIT_RAW_INVERTED = ~PINOUT_BITOUT10_BIT_RAW;
    assign PINOUT_BITOUT10_BIT = PINOUT_BITOUT10_BIT_RAW_INVERTED;
    wire PINOUT_BITOUT10_BIT_RAW;
    assign PINOUT_BITOUT10_BIT_RAW = VAROUT1_BITOUT10_BIT;

    // Name: LED (bitout)
    wire PINOUT_BITOUT11_BIT_RAW_INVERTED;
    assign PINOUT_BITOUT11_BIT_RAW_INVERTED = ~PINOUT_BITOUT11_BIT_RAW;
    assign PINOUT_BITOUT11_BIT = PINOUT_BITOUT11_BIT_RAW_INVERTED;
    wire PINOUT_BITOUT11_BIT_RAW;
    assign PINOUT_BITOUT11_BIT_RAW = VAROUT1_BITOUT11_BIT;

    // Name: Input1 (bitin)
    wire PININ_BITIN12_BIT_INVERTED;
    assign PININ_BITIN12_BIT_INVERTED = ~PININ_BITIN12_BIT;
    assign VARIN1_BITIN12_BIT = PININ_BITIN12_BIT_INVERTED;

    // Name: Input2 (bitin)
    wire PININ_BITIN13_BIT_INVERTED;
    assign PININ_BITIN13_BIT_INVERTED = ~PININ_BITIN13_BIT;
    assign VARIN1_BITIN13_BIT = PININ_BITIN13_BIT_INVERTED;

    // Name: Input3 (bitin)
    wire PININ_BITIN14_BIT_INVERTED;
    assign PININ_BITIN14_BIT_INVERTED = ~PININ_BITIN14_BIT;
    assign VARIN1_BITIN14_BIT = PININ_BITIN14_BIT_INVERTED;

    // Name: Input4 (bitin)
    wire PININ_BITIN15_BIT_INVERTED;
    assign PININ_BITIN15_BIT_INVERTED = ~PININ_BITIN15_BIT;
    assign VARIN1_BITIN15_BIT = PININ_BITIN15_BIT_INVERTED;

    // Name: Input5 (bitin)
    wire PININ_BITIN16_BIT_INVERTED;
    assign PININ_BITIN16_BIT_INVERTED = ~PININ_BITIN16_BIT;
    assign VARIN1_BITIN16_BIT = PININ_BITIN16_BIT_INVERTED;

    // Name: Input6 (bitin)
    wire PININ_BITIN17_BIT_INVERTED;
    assign PININ_BITIN17_BIT_INVERTED = ~PININ_BITIN17_BIT;
    assign VARIN1_BITIN17_BIT = PININ_BITIN17_BIT_INVERTED;

    // Name: Input7 (bitin)
    wire PININ_BITIN18_BIT_INVERTED;
    assign PININ_BITIN18_BIT_INVERTED = ~PININ_BITIN18_BIT;
    assign VARIN1_BITIN18_BIT = PININ_BITIN18_BIT_INVERTED;

    // Name: Input8 (bitin)
    wire PININ_BITIN19_BIT_INVERTED;
    assign PININ_BITIN19_BIT_INVERTED = ~PININ_BITIN19_BIT;
    assign VARIN1_BITIN19_BIT = PININ_BITIN19_BIT_INVERTED;

endmodule
