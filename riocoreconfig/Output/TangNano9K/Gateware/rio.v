/*
    ######### TangNano9K #########


    Toolchain : icestorm
    Family    : GW1N-9C
    Type      : GW1NR-LV9QN88PC6/I5
    Package   : 
    Clock     : 27.0 Mhz

    PININ_SPI0_MOSI <- 25 
    PINOUT_SPI0_MISO -> 26 
    PININ_SPI0_SCLK <- 27 
    PININ_SPI0_SEL <- 28 
    PININ_FREQIN1_FREQ <- 29 PULL{pin_config.get('pull').upper()}
    PINOUT_PWMOUT2_PWM -> 30 
    PINOUT_STEPDIR3_STEP -> 40 
    PINOUT_STEPDIR3_DIR -> 35 
    PINOUT_STEPDIR3_EN -> 41 
    PINOUT_STEPDIR4_STEP -> 42 
    PINOUT_STEPDIR4_DIR -> 51 
    PINOUT_STEPDIR4_EN -> 53 
    PINOUT_STEPDIR5_STEP -> 54 
    PINOUT_STEPDIR5_DIR -> 55 
    PINOUT_STEPDIR5_EN -> 56 
    PININ_BITIN6_BIT <- 57 PULL{pin_config.get('pull').upper()}
    PININ_BITIN7_BIT <- 77 PULL{pin_config.get('pull').upper()}
    PININ_BITIN8_BIT <- 76 PULL{pin_config.get('pull').upper()}
    PININ_BITIN9_BIT <- 75 PULL{pin_config.get('pull').upper()}

*/

/* verilator lint_off UNUSEDSIGNAL */

module rio (
        input sysclk_in,
        input PININ_SPI0_MOSI,
        output PINOUT_SPI0_MISO,
        input PININ_SPI0_SCLK,
        input PININ_SPI0_SEL,
        input PININ_FREQIN1_FREQ,
        output PINOUT_PWMOUT2_PWM,
        output PINOUT_STEPDIR3_STEP,
        output PINOUT_STEPDIR3_DIR,
        output PINOUT_STEPDIR3_EN,
        output PINOUT_STEPDIR4_STEP,
        output PINOUT_STEPDIR4_DIR,
        output PINOUT_STEPDIR4_EN,
        output PINOUT_STEPDIR5_STEP,
        output PINOUT_STEPDIR5_DIR,
        output PINOUT_STEPDIR5_EN,
        input PININ_BITIN6_BIT,
        input PININ_BITIN7_BIT,
        input PININ_BITIN8_BIT,
        input PININ_BITIN9_BIT
    );

    parameter BUFFER_SIZE = 16'd168; // 21 bytes

    reg INTERFACE_TIMEOUT = 0;
    reg ESTOP = 0;
    wire ERROR;
    wire INTERFACE_SYNC;
    assign ERROR = (INTERFACE_TIMEOUT | ESTOP);

    wire sysclk;
    assign sysclk = sysclk_in;

    parameter TIMEOUT = 32'd2700000;

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

    wire [31:0] VARIN32_FREQIN1_FREQUENCY;
    wire VARIN1_FREQIN1_VALID;
    wire [31:0] VAROUT32_PWMOUT2_DTY;
    wire VAROUT1_PWMOUT2_ENABLE;
    wire [31:0] VAROUT32_STEPDIR3_VELOCITY;
    wire VAROUT1_STEPDIR3_ENABLE;
    wire [31:0] VARIN32_STEPDIR3_POSITION;
    wire [31:0] VAROUT32_STEPDIR4_VELOCITY;
    wire VAROUT1_STEPDIR4_ENABLE;
    wire [31:0] VARIN32_STEPDIR4_POSITION;
    wire [31:0] VAROUT32_STEPDIR5_VELOCITY;
    wire VAROUT1_STEPDIR5_ENABLE;
    wire [31:0] VARIN32_STEPDIR5_POSITION;
    wire VARIN1_BITIN6_BIT;
    wire VARIN1_BITIN7_BIT;
    wire VARIN1_BITIN8_BIT;
    wire VARIN1_BITIN9_BIT;

    // assign header_rx = {rx_data[143:136], rx_data[151:144], rx_data[159:152], rx_data[167:160]};
    assign VAROUT32_PWMOUT2_DTY = {rx_data[111:104], rx_data[119:112], rx_data[127:120], rx_data[135:128]};
    assign VAROUT32_STEPDIR3_VELOCITY = {rx_data[79:72], rx_data[87:80], rx_data[95:88], rx_data[103:96]};
    assign VAROUT32_STEPDIR4_VELOCITY = {rx_data[47:40], rx_data[55:48], rx_data[63:56], rx_data[71:64]};
    assign VAROUT32_STEPDIR5_VELOCITY = {rx_data[15:8], rx_data[23:16], rx_data[31:24], rx_data[39:32]};
    assign VAROUT1_PWMOUT2_ENABLE = {rx_data[7]};
    assign VAROUT1_STEPDIR3_ENABLE = {rx_data[6]};
    assign VAROUT1_STEPDIR4_ENABLE = {rx_data[5]};
    assign VAROUT1_STEPDIR5_ENABLE = {rx_data[4]};
    // assign FILL = rx_data[3:0];

    assign tx_data = {
        header_tx[7:0], header_tx[15:8], header_tx[23:16], header_tx[31:24],
        VARIN32_FREQIN1_FREQUENCY[7:0], VARIN32_FREQIN1_FREQUENCY[15:8], VARIN32_FREQIN1_FREQUENCY[23:16], VARIN32_FREQIN1_FREQUENCY[31:24],
        VARIN32_STEPDIR3_POSITION[7:0], VARIN32_STEPDIR3_POSITION[15:8], VARIN32_STEPDIR3_POSITION[23:16], VARIN32_STEPDIR3_POSITION[31:24],
        VARIN32_STEPDIR4_POSITION[7:0], VARIN32_STEPDIR4_POSITION[15:8], VARIN32_STEPDIR4_POSITION[23:16], VARIN32_STEPDIR4_POSITION[31:24],
        VARIN32_STEPDIR5_POSITION[7:0], VARIN32_STEPDIR5_POSITION[15:8], VARIN32_STEPDIR5_POSITION[23:16], VARIN32_STEPDIR5_POSITION[31:24],
        VARIN1_FREQIN1_VALID,
        VARIN1_BITIN6_BIT,
        VARIN1_BITIN7_BIT,
        VARIN1_BITIN8_BIT,
        VARIN1_BITIN9_BIT,
        3'd0
    };



    // Name: spi0 (spi)
    assign PINOUT_SPI0_MISO = PINOUT_SPI0_MISO_RAW;
    wire PINOUT_SPI0_MISO_RAW;
    spi #(
        .BUFFER_SIZE(BUFFER_SIZE),
        .MSGID(32'h74697277)
    ) spi0 (
        .clk(sysclk),
        .mosi(PININ_SPI0_MOSI),
        .miso(PINOUT_SPI0_MISO_RAW),
        .sclk(PININ_SPI0_SCLK),
        .sel(PININ_SPI0_SEL),
        .rx_data(rx_data),
        .tx_data(tx_data),
        .sync(INTERFACE_SYNC)
    );

    // Name: SPINDLE_RPM_IN (freqin)
    freqin #(
        .RESET_CNT(5400000)
    ) freqin1 (
        .clk(sysclk),
        .freq(PININ_FREQIN1_FREQ),
        .frequency(VARIN32_FREQIN1_FREQUENCY),
        .valid(VARIN1_FREQIN1_VALID)
    );

    // Name: SPINDLE_SPEED_PWM_OUT (pwmout)
    assign PINOUT_PWMOUT2_PWM = PINOUT_PWMOUT2_PWM_RAW;
    wire PINOUT_PWMOUT2_PWM_RAW;
    wire UNUSED_PIN_PWMOUT2_DIR;
    wire UNUSED_PIN_PWMOUT2_EN;
    pwmout #(
        .DIVIDER(2700)
    ) pwmout2 (
        .clk(sysclk),
        .pwm(PINOUT_PWMOUT2_PWM_RAW),
        .dir(UNUSED_PIN_PWMOUT2_DIR),
        .en(UNUSED_PIN_PWMOUT2_EN),
        .dty(VAROUT32_PWMOUT2_DTY),
        .enable(VAROUT1_PWMOUT2_ENABLE & ~ERROR)
    );

    // Name: ZStepper (stepdir)
    assign PINOUT_STEPDIR3_STEP = PINOUT_STEPDIR3_STEP_RAW;
    assign PINOUT_STEPDIR3_DIR = PINOUT_STEPDIR3_DIR_RAW;
    assign PINOUT_STEPDIR3_EN = PINOUT_STEPDIR3_EN_RAW;
    wire PINOUT_STEPDIR3_STEP_RAW;
    wire PINOUT_STEPDIR3_DIR_RAW;
    wire PINOUT_STEPDIR3_EN_RAW;
    stepdir stepdir3 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR3_STEP_RAW),
        .dir(PINOUT_STEPDIR3_DIR_RAW),
        .en(PINOUT_STEPDIR3_EN_RAW),
        .velocity(VAROUT32_STEPDIR3_VELOCITY),
        .enable(VAROUT1_STEPDIR3_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR3_POSITION)
    );

    // Name: YStepper (stepdir)
    assign PINOUT_STEPDIR4_STEP = PINOUT_STEPDIR4_STEP_RAW;
    assign PINOUT_STEPDIR4_DIR = PINOUT_STEPDIR4_DIR_RAW;
    assign PINOUT_STEPDIR4_EN = PINOUT_STEPDIR4_EN_RAW;
    wire PINOUT_STEPDIR4_STEP_RAW;
    wire PINOUT_STEPDIR4_DIR_RAW;
    wire PINOUT_STEPDIR4_EN_RAW;
    stepdir stepdir4 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR4_STEP_RAW),
        .dir(PINOUT_STEPDIR4_DIR_RAW),
        .en(PINOUT_STEPDIR4_EN_RAW),
        .velocity(VAROUT32_STEPDIR4_VELOCITY),
        .enable(VAROUT1_STEPDIR4_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR4_POSITION)
    );

    // Name: XStepper (stepdir)
    assign PINOUT_STEPDIR5_STEP = PINOUT_STEPDIR5_STEP_RAW;
    assign PINOUT_STEPDIR5_DIR = PINOUT_STEPDIR5_DIR_RAW;
    assign PINOUT_STEPDIR5_EN = PINOUT_STEPDIR5_EN_RAW;
    wire PINOUT_STEPDIR5_STEP_RAW;
    wire PINOUT_STEPDIR5_DIR_RAW;
    wire PINOUT_STEPDIR5_EN_RAW;
    stepdir stepdir5 (
        .clk(sysclk),
        .step(PINOUT_STEPDIR5_STEP_RAW),
        .dir(PINOUT_STEPDIR5_DIR_RAW),
        .en(PINOUT_STEPDIR5_EN_RAW),
        .velocity(VAROUT32_STEPDIR5_VELOCITY),
        .enable(VAROUT1_STEPDIR5_ENABLE & ~ERROR),
        .position(VARIN32_STEPDIR5_POSITION)
    );

    // Name: ESTOP (bitin)
    assign VARIN1_BITIN6_BIT = PININ_BITIN6_BIT;

    // Name: ZHOME (bitin)
    assign VARIN1_BITIN7_BIT = PININ_BITIN7_BIT;

    // Name: YHOME (bitin)
    assign VARIN1_BITIN8_BIT = PININ_BITIN8_BIT;

    // Name: XHOME (bitin)
    assign VARIN1_BITIN9_BIT = PININ_BITIN9_BIT;

endmodule
