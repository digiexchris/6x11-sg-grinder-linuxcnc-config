/*
    ######### TangNano9K-icestorm #########


    Toolchain : icestorm
    Family    : GW1N-9C
    Type      : GW1NR-LV9QN88PC6/I5
    Package   : 
    Clock     : 27.0 Mhz

    PININ_SPI0_MOSI <- 72 
    PINOUT_SPI0_MISO -> 73 
    PININ_SPI0_SCLK <- 82 
    PININ_SPI0_SEL <- 83 

*/

/* verilator lint_off UNUSEDSIGNAL */

module rio (
        input sysclk_in,
        input PININ_SPI0_MOSI,
        output PINOUT_SPI0_MISO,
        input PININ_SPI0_SCLK,
        input PININ_SPI0_SEL
    );

    parameter BUFFER_SIZE = 16'd32; // 4 bytes

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

    wire[31:0] rx_data;
    wire[31:0] tx_data;

    reg signed [31:0] header_tx;
    always @(posedge sysclk) begin
        if (ESTOP) begin
            header_tx <= 32'h65737470;
        end else begin
            header_tx <= 32'h64617461;
        end
    end


    // assign header_rx = {rx_data[7:0], rx_data[15:8], rx_data[23:16], rx_data[31:24]};

    assign tx_data = {
        header_tx[7:0], header_tx[15:8], header_tx[23:16], header_tx[31:24]
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

endmodule
