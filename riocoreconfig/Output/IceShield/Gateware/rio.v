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
    PINOUT_BITOUT6_BIT -> 43 
    PINOUT_BITOUT7_BIT -> LED:R 
    PININ_BITIN8_BIT <- 40 PULL{pin_config.get('pull').upper()}
    PININ_BITIN9_BIT <- 39 PULL{pin_config.get('pull').upper()}
    PININ_BITIN10_BIT <- 38 PULL{pin_config.get('pull').upper()}
    PININ_BITIN11_BIT <- 37 PULL{pin_config.get('pull').upper()}
    PININ_BITIN12_BIT <- 36 PULL{pin_config.get('pull').upper()}
    PININ_BITIN13_BIT <- 42 PULL{pin_config.get('pull').upper()}
    PININ_BITIN14_BIT <- 34 PULL{pin_config.get('pull').upper()}
    PINOUT_PWMOUT16_PWM -> 44 
    PININ_PWMIN17_PWM <- 41 

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
        output PINOUT_BITOUT6_BIT,
        output PINOUT_BITOUT7_BIT,
        input PININ_BITIN8_BIT,
        input PININ_BITIN9_BIT,
        input PININ_BITIN10_BIT,
        input PININ_BITIN11_BIT,
        input PININ_BITIN12_BIT,
        input PININ_BITIN13_BIT,
        input PININ_BITIN14_BIT,
        output PINOUT_PWMOUT16_PWM,
        input PININ_PWMIN17_PWM
    );

    parameter BUFFER_SIZE = 16'd168; // 21 bytes

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

    wire[167:0] rx_data;
    wire[167:0] tx_data;

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
    wire VAROUT1_BITOUT6_BIT;
    wire VAROUT1_BITOUT7_BIT;
    wire VARIN1_BITIN8_BIT;
    wire VARIN1_BITIN9_BIT;
    wire VARIN1_BITIN10_BIT;
    wire VARIN1_BITIN11_BIT;
    wire VARIN1_BITIN12_BIT;
    wire VARIN1_BITIN13_BIT;
    wire VARIN1_BITIN14_BIT;
    wire [31:0] VAROUT32_PWMOUT16_DTY;
    wire VAROUT1_PWMOUT16_ENABLE;
    wire [31:0] VARIN32_PWMIN17_WIDTH;
    wire VARIN1_PWMIN17_VALID;

    // assign header_rx = {rx_data[143:136], rx_data[151:144], rx_data[159:152], rx_data[167:160]};
    assign VAROUT32_STEPDIR3_VELOCITY = {rx_data[111:104], rx_data[119:112], rx_data[127:120], rx_data[135:128]};
    assign VAROUT32_STEPDIR4_VELOCITY = {rx_data[79:72], rx_data[87:80], rx_data[95:88], rx_data[103:96]};
    assign VAROUT32_STEPDIR5_VELOCITY = {rx_data[47:40], rx_data[55:48], rx_data[63:56], rx_data[71:64]};
    assign VAROUT32_PWMOUT16_DTY = {rx_data[15:8], rx_data[23:16], rx_data[31:24], rx_data[39:32]};
    assign VAROUT1_BITOUT2_BIT = {rx_data[7]};
    assign VAROUT1_STEPDIR3_ENABLE = {rx_data[6]};
    assign VAROUT1_STEPDIR4_ENABLE = {rx_data[5]};
    assign VAROUT1_STEPDIR5_ENABLE = {rx_data[4]};
    assign VAROUT1_BITOUT6_BIT = {rx_data[3]};
    assign VAROUT1_BITOUT7_BIT = {rx_data[2]};
    assign VAROUT1_PWMOUT16_ENABLE = {rx_data[1]};
    // assign FILL = rx_data[0:0];

    assign tx_data = {
        header_tx[7:0], header_tx[15:8], header_tx[23:16], header_tx[31:24],
        VARIN32_STEPDIR3_POSITION[7:0], VARIN32_STEPDIR3_POSITION[15:8], VARIN32_STEPDIR3_POSITION[23:16], VARIN32_STEPDIR3_POSITION[31:24],
        VARIN32_STEPDIR4_POSITION[7:0], VARIN32_STEPDIR4_POSITION[15:8], VARIN32_STEPDIR4_POSITION[23:16], VARIN32_STEPDIR4_POSITION[31:24],
        VARIN32_STEPDIR5_POSITION[7:0], VARIN32_STEPDIR5_POSITION[15:8], VARIN32_STEPDIR5_POSITION[23:16], VARIN32_STEPDIR5_POSITION[31:24],
        VARIN32_PWMIN17_WIDTH[7:0], VARIN32_PWMIN17_WIDTH[15:8], VARIN32_PWMIN17_WIDTH[23:16], VARIN32_PWMIN17_WIDTH[31:24],
        VARIN1_BITIN8_BIT,
        VARIN1_BITIN9_BIT,
        VARIN1_BITIN10_BIT,
        VARIN1_BITIN11_BIT,
        VARIN1_BITIN12_BIT,
        VARIN1_BITIN13_BIT,
        VARIN1_BITIN14_BIT,
        VARIN1_PWMIN17_VALID
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
    wire PINOUT_BITOUT2_BIT_RAW_ONERROR;
    assign PINOUT_BITOUT2_BIT_RAW_ONERROR = PINOUT_BITOUT2_BIT_RAW & ~ERROR;
    assign PINOUT_BITOUT2_BIT = PINOUT_BITOUT2_BIT_RAW_ONERROR;
    wire PINOUT_BITOUT2_BIT_RAW;
    assign PINOUT_BITOUT2_BIT_RAW = VAROUT1_BITOUT2_BIT;

    // Name: StepperX (stepdir)
    assign PINOUT_STEPDIR3_STEP = PINOUT_STEPDIR3_STEP_RAW;
    assign PINOUT_STEPDIR3_DIR = PINOUT_STEPDIR3_DIR_RAW;
    wire PINOUT_STEPDIR3_STEP_RAW;
    wire PINOUT_STEPDIR3_DIR_RAW;
    wire UNUSED_PIN_STEPDIR3_EN;
    stepdir #(
        .PULSE_LEN(0),
        .DIR_DELAY(20)
    ) stepdir3 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR3_STEP_RAW),
        .dir(PINOUT_STEPDIR3_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR3_EN),
        .velocity(VAROUT32_STEPDIR3_VELOCITY),
        .enable(VAROUT1_STEPDIR3_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR3_POSITION)
    );

    // Name: StepperY (stepdir)
    assign PINOUT_STEPDIR4_STEP = PINOUT_STEPDIR4_STEP_RAW;
    assign PINOUT_STEPDIR4_DIR = PINOUT_STEPDIR4_DIR_RAW;
    wire PINOUT_STEPDIR4_STEP_RAW;
    wire PINOUT_STEPDIR4_DIR_RAW;
    wire UNUSED_PIN_STEPDIR4_EN;
    stepdir #(
        .PULSE_LEN(0),
        .DIR_DELAY(20)
    ) stepdir4 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR4_STEP_RAW),
        .dir(PINOUT_STEPDIR4_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR4_EN),
        .velocity(VAROUT32_STEPDIR4_VELOCITY),
        .enable(VAROUT1_STEPDIR4_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR4_POSITION)
    );

    // Name: StepperZ (stepdir)
    assign PINOUT_STEPDIR5_STEP = PINOUT_STEPDIR5_STEP_RAW;
    assign PINOUT_STEPDIR5_DIR = PINOUT_STEPDIR5_DIR_RAW;
    wire PINOUT_STEPDIR5_STEP_RAW;
    wire PINOUT_STEPDIR5_DIR_RAW;
    wire UNUSED_PIN_STEPDIR5_EN;
    stepdir #(
        .PULSE_LEN(0),
        .DIR_DELAY(20)
    ) stepdir5 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR5_STEP_RAW),
        .dir(PINOUT_STEPDIR5_DIR_RAW),
        .en(UNUSED_PIN_STEPDIR5_EN),
        .velocity(VAROUT32_STEPDIR5_VELOCITY),
        .enable(VAROUT1_STEPDIR5_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR5_POSITION)
    );

    // Name: Output2 (bitout)
    wire PINOUT_BITOUT6_BIT_RAW_INVERTED;
    assign PINOUT_BITOUT6_BIT_RAW_INVERTED = ~PINOUT_BITOUT6_BIT_RAW;
    assign PINOUT_BITOUT6_BIT = PINOUT_BITOUT6_BIT_RAW_INVERTED;
    wire PINOUT_BITOUT6_BIT_RAW;
    assign PINOUT_BITOUT6_BIT_RAW = VAROUT1_BITOUT6_BIT;

    // Name: LED (bitout)
    wire PINOUT_BITOUT7_BIT_RAW_INVERTED;
    assign PINOUT_BITOUT7_BIT_RAW_INVERTED = ~PINOUT_BITOUT7_BIT_RAW;
    assign PINOUT_BITOUT7_BIT = PINOUT_BITOUT7_BIT_RAW_INVERTED;
    wire PINOUT_BITOUT7_BIT_RAW;
    assign PINOUT_BITOUT7_BIT_RAW = VAROUT1_BITOUT7_BIT;

    // Name: HOME_X (bitin)
    wire PININ_BITIN8_BIT_INVERTED;
    assign PININ_BITIN8_BIT_INVERTED = ~PININ_BITIN8_BIT;
    assign VARIN1_BITIN8_BIT = PININ_BITIN8_BIT_INVERTED;

    // Name: HOME_Y (bitin)
    wire PININ_BITIN9_BIT_INVERTED;
    assign PININ_BITIN9_BIT_INVERTED = ~PININ_BITIN9_BIT;
    assign VARIN1_BITIN9_BIT = PININ_BITIN9_BIT_INVERTED;

    // Name: HOME_Z (bitin)
    wire PININ_BITIN10_BIT_INVERTED;
    assign PININ_BITIN10_BIT_INVERTED = ~PININ_BITIN10_BIT;
    assign VARIN1_BITIN10_BIT = PININ_BITIN10_BIT_INVERTED;

    // Name: Input5 (bitin)
    wire PININ_BITIN11_BIT_INVERTED;
    assign PININ_BITIN11_BIT_INVERTED = ~PININ_BITIN11_BIT;
    assign VARIN1_BITIN11_BIT = PININ_BITIN11_BIT_INVERTED;

    // Name: Input6 (bitin)
    wire PININ_BITIN12_BIT_INVERTED;
    assign PININ_BITIN12_BIT_INVERTED = ~PININ_BITIN12_BIT;
    assign VARIN1_BITIN12_BIT = PININ_BITIN12_BIT_INVERTED;

    // Name: Input7 (bitin)
    wire PININ_BITIN13_BIT_INVERTED;
    assign PININ_BITIN13_BIT_INVERTED = ~PININ_BITIN13_BIT;
    assign VARIN1_BITIN13_BIT = PININ_BITIN13_BIT_INVERTED;

    // Name: Input8 (bitin)
    wire PININ_BITIN14_BIT_INVERTED;
    assign PININ_BITIN14_BIT_INVERTED = ~PININ_BITIN14_BIT;
    assign VARIN1_BITIN14_BIT = PININ_BITIN14_BIT_INVERTED;

    // Name: Spindle0 (pwmout)
    assign PINOUT_PWMOUT16_PWM = PINOUT_PWMOUT16_PWM_RAW;
    wire PINOUT_PWMOUT16_PWM_RAW;
    wire UNUSED_PIN_PWMOUT16_DIR;
    wire UNUSED_PIN_PWMOUT16_EN;
    pwmout #(
        .DIVIDER(745300)
    ) pwmout16 (
        .clk(sysclk),
        .pwm(PINOUT_PWMOUT16_PWM_RAW),
        .dir(UNUSED_PIN_PWMOUT16_DIR),
        .en(UNUSED_PIN_PWMOUT16_EN),
        .dty(VAROUT32_PWMOUT16_DTY),
        .enable(VAROUT1_PWMOUT16_ENABLE & ~ERROR)
    );

    // Name: Spindle0RPS (pwmin)
    pwmin #(
        .RESET_CNT(2981200)
    ) pwmin17 (
        .clk(sysclk),
        .pwm(PININ_PWMIN17_PWM),
        .width(VARIN32_PWMIN17_WIDTH),
        .valid(VARIN1_PWMIN17_VALID)
    );

endmodule
