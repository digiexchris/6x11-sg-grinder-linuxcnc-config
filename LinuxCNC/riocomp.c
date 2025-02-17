// Generated by component()
#include <rtapi.h>
#include <rtapi_app.h>
#include <hal.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <termios.h>

MODULE_AUTHOR("Oliver Dippel");
MODULE_DESCRIPTION("Driver for RIO FPGA boards");
MODULE_LICENSE("GPL v2");

#define MODNAME "rio"
#define PREFIX "rio"
#define JOINTS 3
#define BUFFER_SIZE 21
#define OSC_CLOCK 29812000
#define UDP_IP "192.168.10.194"
#define UDP_PORT 2390
#define SERIAL_PORT "/dev/ttyUSB1"
#define SERIAL_BAUD B1000000
#define SPI_PIN_MOSI 10
#define SPI_PIN_MISO 9
#define SPI_PIN_CLK 11
#define SPI_PIN_CS 8
#define SPI_SPEED BCM2835_SPI_CLOCK_DIVIDER_256

static int 			      comp_id;
static const char 	      *modname = MODNAME;
static const char 	      *prefix = PREFIX;

uint32_t pkg_counter = 0;
uint32_t err_counter = 0;

long stamp_last = 0;

void rio_readwrite();
int error_handler(int retval);

// Generated by component_variables()
typedef struct {
    // hal variables
    hal_bit_t   *sys_enable;
    hal_bit_t   *sys_enable_request;
    hal_bit_t   *sys_status;
    hal_bit_t   *sys_simulation;
    hal_float_t *duration;
    hal_bit_t   *SIGOUT_ENABLE_BIT;
    hal_float_t *SIGOUT_STEPPERX_VELOCITY;
    hal_float_t *SIGOUT_STEPPERX_VELOCITY_SCALE;
    hal_float_t *SIGOUT_STEPPERX_VELOCITY_OFFSET;
    hal_float_t *SIGIN_STEPPERX_POSITION;
    hal_float_t *SIGIN_STEPPERX_POSITION_ABS;
    hal_s32_t *SIGIN_STEPPERX_POSITION_S32;
    hal_u32_t *SIGIN_STEPPERX_POSITION_U32_ABS;
    hal_float_t *SIGIN_STEPPERX_POSITION_SCALE;
    hal_float_t *SIGIN_STEPPERX_POSITION_OFFSET;
    hal_bit_t   *SIGOUT_STEPPERX_ENABLE;
    hal_float_t *SIGOUT_STEPPERY_VELOCITY;
    hal_float_t *SIGOUT_STEPPERY_VELOCITY_SCALE;
    hal_float_t *SIGOUT_STEPPERY_VELOCITY_OFFSET;
    hal_float_t *SIGIN_STEPPERY_POSITION;
    hal_float_t *SIGIN_STEPPERY_POSITION_ABS;
    hal_s32_t *SIGIN_STEPPERY_POSITION_S32;
    hal_u32_t *SIGIN_STEPPERY_POSITION_U32_ABS;
    hal_float_t *SIGIN_STEPPERY_POSITION_SCALE;
    hal_float_t *SIGIN_STEPPERY_POSITION_OFFSET;
    hal_bit_t   *SIGOUT_STEPPERY_ENABLE;
    hal_float_t *SIGOUT_STEPPERZ_VELOCITY;
    hal_float_t *SIGOUT_STEPPERZ_VELOCITY_SCALE;
    hal_float_t *SIGOUT_STEPPERZ_VELOCITY_OFFSET;
    hal_float_t *SIGIN_STEPPERZ_POSITION;
    hal_float_t *SIGIN_STEPPERZ_POSITION_ABS;
    hal_s32_t *SIGIN_STEPPERZ_POSITION_S32;
    hal_u32_t *SIGIN_STEPPERZ_POSITION_U32_ABS;
    hal_float_t *SIGIN_STEPPERZ_POSITION_SCALE;
    hal_float_t *SIGIN_STEPPERZ_POSITION_OFFSET;
    hal_bit_t   *SIGOUT_STEPPERZ_ENABLE;
    hal_bit_t   *SIGOUT_OUTPUT2_BIT;
    hal_bit_t   *SIGOUT_LED_BIT;
    hal_bit_t   *SIGIN_HOME_X_BIT;
    hal_bit_t   *SIGIN_HOME_X_BIT_not;
    hal_bit_t   *SIGIN_HOME_Y_BIT;
    hal_bit_t   *SIGIN_HOME_Y_BIT_not;
    hal_bit_t   *SIGIN_HOME_Z_BIT;
    hal_bit_t   *SIGIN_HOME_Z_BIT_not;
    hal_bit_t   *SIGIN_INPUT5_BIT;
    hal_bit_t   *SIGIN_INPUT5_BIT_not;
    hal_bit_t   *SIGIN_INPUT6_BIT;
    hal_bit_t   *SIGIN_INPUT6_BIT_not;
    hal_bit_t   *SIGIN_INPUT7_BIT;
    hal_bit_t   *SIGIN_INPUT7_BIT_not;
    hal_bit_t   *SIGIN_INPUT8_BIT;
    hal_bit_t   *SIGIN_INPUT8_BIT_not;
    hal_float_t *SIGOUT_SPINDLE0_DTY;
    hal_float_t *SIGOUT_SPINDLE0_DTY_SCALE;
    hal_float_t *SIGOUT_SPINDLE0_DTY_OFFSET;
    hal_bit_t   *SIGOUT_SPINDLE0_ENABLE;
    hal_float_t *SIGIN_SPINDLE0RPS_WIDTH;
    hal_float_t *SIGIN_SPINDLE0RPS_WIDTH_ABS;
    hal_s32_t *SIGIN_SPINDLE0RPS_WIDTH_S32;
    hal_u32_t *SIGIN_SPINDLE0RPS_WIDTH_U32_ABS;
    hal_float_t *SIGIN_SPINDLE0RPS_WIDTH_SCALE;
    hal_float_t *SIGIN_SPINDLE0RPS_WIDTH_OFFSET;
    hal_bit_t   *SIGIN_SPINDLE0RPS_VALID;
    hal_bit_t   *SIGIN_SPINDLE0RPS_VALID_not;
    // raw variables
    int32_t VAROUT32_STEPDIR3_VELOCITY;
    int32_t VARIN32_STEPDIR3_POSITION;
    int32_t VAROUT32_STEPDIR4_VELOCITY;
    int32_t VARIN32_STEPDIR4_POSITION;
    int32_t VAROUT32_STEPDIR5_VELOCITY;
    int32_t VARIN32_STEPDIR5_POSITION;
    int32_t VAROUT32_PWMOUT16_DTY;
    int32_t VARIN32_PWMIN17_WIDTH;
    bool VAROUT1_BITOUT2_BIT;
    bool VAROUT1_STEPDIR3_ENABLE;
    bool VAROUT1_STEPDIR4_ENABLE;
    bool VAROUT1_STEPDIR5_ENABLE;
    bool VAROUT1_BITOUT6_BIT;
    bool VAROUT1_BITOUT7_BIT;
    bool VARIN1_BITIN8_BIT;
    bool VARIN1_BITIN9_BIT;
    bool VARIN1_BITIN10_BIT;
    bool VARIN1_BITIN11_BIT;
    bool VARIN1_BITIN12_BIT;
    bool VARIN1_BITIN13_BIT;
    bool VARIN1_BITIN14_BIT;
    bool VAROUT1_PWMOUT16_ENABLE;
    bool VARIN1_PWMIN17_VALID;

} data_t;
static data_t *data;

void register_signals(void) {
    int retval = 0;
    data->VAROUT32_STEPDIR3_VELOCITY = 0;
    data->VARIN32_STEPDIR3_POSITION = 0;
    data->VAROUT32_STEPDIR4_VELOCITY = 0;
    data->VARIN32_STEPDIR4_POSITION = 0;
    data->VAROUT32_STEPDIR5_VELOCITY = 0;
    data->VARIN32_STEPDIR5_POSITION = 0;
    data->VAROUT32_PWMOUT16_DTY = 0;
    data->VARIN32_PWMIN17_WIDTH = 0;
    data->VAROUT1_BITOUT2_BIT = 0;
    data->VAROUT1_STEPDIR3_ENABLE = 0;
    data->VAROUT1_STEPDIR4_ENABLE = 0;
    data->VAROUT1_STEPDIR5_ENABLE = 0;
    data->VAROUT1_BITOUT6_BIT = 0;
    data->VAROUT1_BITOUT7_BIT = 0;
    data->VARIN1_BITIN8_BIT = 0;
    data->VARIN1_BITIN9_BIT = 0;
    data->VARIN1_BITIN10_BIT = 0;
    data->VARIN1_BITIN11_BIT = 0;
    data->VARIN1_BITIN12_BIT = 0;
    data->VARIN1_BITIN13_BIT = 0;
    data->VARIN1_BITIN14_BIT = 0;
    data->VAROUT1_PWMOUT16_ENABLE = 0;
    data->VARIN1_PWMIN17_VALID = 0;

    if (retval = hal_pin_bit_newf(HAL_OUT, &(data->sys_status), comp_id, "%s.sys-status", prefix) != 0) error_handler(retval);
    if (retval = hal_pin_bit_newf(HAL_IN,  &(data->sys_enable), comp_id, "%s.sys-enable", prefix) != 0) error_handler(retval);
    if (retval = hal_pin_bit_newf(HAL_IN,  &(data->sys_enable_request), comp_id, "%s.sys-enable-request", prefix) != 0) error_handler(retval);
    if (retval = hal_pin_bit_newf(HAL_IN,  &(data->sys_simulation), comp_id, "%s.sys-simulation", prefix) != 0) error_handler(retval);
    if (retval = hal_pin_float_newf(HAL_OUT,  &(data->duration), comp_id, "%s.duration", prefix) != 0) error_handler(retval);
    *data->duration = rtapi_get_time();
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_ENABLE_BIT), comp_id, "%s.enable.bit", prefix) != 0) error_handler(retval);
    *data->SIGOUT_ENABLE_BIT = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERX_VELOCITY_SCALE), comp_id, "%s.StepperX.velocity-scale", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERX_VELOCITY_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERX_VELOCITY_OFFSET), comp_id, "%s.StepperX.velocity-offset", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERX_VELOCITY_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERX_VELOCITY), comp_id, "%s.StepperX.velocity", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERX_VELOCITY = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_STEPPERX_POSITION_SCALE), comp_id, "%s.StepperX.position-scale", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERX_POSITION_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_STEPPERX_POSITION_OFFSET), comp_id, "%s.StepperX.position-offset", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERX_POSITION_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_STEPPERX_POSITION), comp_id, "%s.StepperX.position", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERX_POSITION = 0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_STEPPERX_POSITION_ABS), comp_id, "%s.StepperX.position-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERX_POSITION_ABS = 0;
    if (retval = hal_pin_s32_newf(HAL_OUT, &(data->SIGIN_STEPPERX_POSITION_S32), comp_id, "%s.StepperX.position-s32", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERX_POSITION_S32 = 0;
    if (retval = hal_pin_u32_newf(HAL_OUT, &(data->SIGIN_STEPPERX_POSITION_U32_ABS), comp_id, "%s.StepperX.position-u32-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERX_POSITION_U32_ABS = 0;
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_STEPPERX_ENABLE), comp_id, "%s.StepperX.enable", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERX_ENABLE = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERY_VELOCITY_SCALE), comp_id, "%s.StepperY.velocity-scale", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERY_VELOCITY_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERY_VELOCITY_OFFSET), comp_id, "%s.StepperY.velocity-offset", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERY_VELOCITY_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERY_VELOCITY), comp_id, "%s.StepperY.velocity", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERY_VELOCITY = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_STEPPERY_POSITION_SCALE), comp_id, "%s.StepperY.position-scale", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERY_POSITION_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_STEPPERY_POSITION_OFFSET), comp_id, "%s.StepperY.position-offset", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERY_POSITION_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_STEPPERY_POSITION), comp_id, "%s.StepperY.position", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERY_POSITION = 0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_STEPPERY_POSITION_ABS), comp_id, "%s.StepperY.position-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERY_POSITION_ABS = 0;
    if (retval = hal_pin_s32_newf(HAL_OUT, &(data->SIGIN_STEPPERY_POSITION_S32), comp_id, "%s.StepperY.position-s32", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERY_POSITION_S32 = 0;
    if (retval = hal_pin_u32_newf(HAL_OUT, &(data->SIGIN_STEPPERY_POSITION_U32_ABS), comp_id, "%s.StepperY.position-u32-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERY_POSITION_U32_ABS = 0;
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_STEPPERY_ENABLE), comp_id, "%s.StepperY.enable", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERY_ENABLE = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERZ_VELOCITY_SCALE), comp_id, "%s.StepperZ.velocity-scale", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERZ_VELOCITY_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERZ_VELOCITY_OFFSET), comp_id, "%s.StepperZ.velocity-offset", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERZ_VELOCITY_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_STEPPERZ_VELOCITY), comp_id, "%s.StepperZ.velocity", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERZ_VELOCITY = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_STEPPERZ_POSITION_SCALE), comp_id, "%s.StepperZ.position-scale", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERZ_POSITION_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_STEPPERZ_POSITION_OFFSET), comp_id, "%s.StepperZ.position-offset", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERZ_POSITION_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_STEPPERZ_POSITION), comp_id, "%s.StepperZ.position", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERZ_POSITION = 0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_STEPPERZ_POSITION_ABS), comp_id, "%s.StepperZ.position-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERZ_POSITION_ABS = 0;
    if (retval = hal_pin_s32_newf(HAL_OUT, &(data->SIGIN_STEPPERZ_POSITION_S32), comp_id, "%s.StepperZ.position-s32", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERZ_POSITION_S32 = 0;
    if (retval = hal_pin_u32_newf(HAL_OUT, &(data->SIGIN_STEPPERZ_POSITION_U32_ABS), comp_id, "%s.StepperZ.position-u32-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_STEPPERZ_POSITION_U32_ABS = 0;
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_STEPPERZ_ENABLE), comp_id, "%s.StepperZ.enable", prefix) != 0) error_handler(retval);
    *data->SIGOUT_STEPPERZ_ENABLE = 0;
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_OUTPUT2_BIT), comp_id, "%s.Output2.bit", prefix) != 0) error_handler(retval);
    *data->SIGOUT_OUTPUT2_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_LED_BIT), comp_id, "%s.LED.bit", prefix) != 0) error_handler(retval);
    *data->SIGOUT_LED_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_HOME_X_BIT), comp_id, "%s.HOME_X.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_HOME_X_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_HOME_X_BIT_not), comp_id, "%s.HOME_X.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_HOME_X_BIT_not = 1 - *data->SIGIN_HOME_X_BIT;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_HOME_Y_BIT), comp_id, "%s.HOME_Y.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_HOME_Y_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_HOME_Y_BIT_not), comp_id, "%s.HOME_Y.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_HOME_Y_BIT_not = 1 - *data->SIGIN_HOME_Y_BIT;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_HOME_Z_BIT), comp_id, "%s.HOME_Z.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_HOME_Z_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_HOME_Z_BIT_not), comp_id, "%s.HOME_Z.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_HOME_Z_BIT_not = 1 - *data->SIGIN_HOME_Z_BIT;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT5_BIT), comp_id, "%s.Input5.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT5_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT5_BIT_not), comp_id, "%s.Input5.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT5_BIT_not = 1 - *data->SIGIN_INPUT5_BIT;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT6_BIT), comp_id, "%s.Input6.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT6_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT6_BIT_not), comp_id, "%s.Input6.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT6_BIT_not = 1 - *data->SIGIN_INPUT6_BIT;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT7_BIT), comp_id, "%s.Input7.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT7_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT7_BIT_not), comp_id, "%s.Input7.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT7_BIT_not = 1 - *data->SIGIN_INPUT7_BIT;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT8_BIT), comp_id, "%s.Input8.bit", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT8_BIT = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_INPUT8_BIT_not), comp_id, "%s.Input8.bit-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_INPUT8_BIT_not = 1 - *data->SIGIN_INPUT8_BIT;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_SPINDLE0_DTY_SCALE), comp_id, "%s.Spindle0.dty-scale", prefix) != 0) error_handler(retval);
    *data->SIGOUT_SPINDLE0_DTY_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_SPINDLE0_DTY_OFFSET), comp_id, "%s.Spindle0.dty-offset", prefix) != 0) error_handler(retval);
    *data->SIGOUT_SPINDLE0_DTY_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGOUT_SPINDLE0_DTY), comp_id, "%s.Spindle0.dty", prefix) != 0) error_handler(retval);
    *data->SIGOUT_SPINDLE0_DTY = 0;
    if (retval = hal_pin_bit_newf  (HAL_IN, &(data->SIGOUT_SPINDLE0_ENABLE), comp_id, "%s.Spindle0.enable", prefix) != 0) error_handler(retval);
    *data->SIGOUT_SPINDLE0_ENABLE = 0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_SPINDLE0RPS_WIDTH_SCALE), comp_id, "%s.Spindle0RPS.width-scale", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_WIDTH_SCALE = 1.0;
    if (retval = hal_pin_float_newf(HAL_IN, &(data->SIGIN_SPINDLE0RPS_WIDTH_OFFSET), comp_id, "%s.Spindle0RPS.width-offset", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_WIDTH_OFFSET = 0.0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_SPINDLE0RPS_WIDTH), comp_id, "%s.Spindle0RPS.width", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_WIDTH = 0;
    if (retval = hal_pin_float_newf(HAL_OUT, &(data->SIGIN_SPINDLE0RPS_WIDTH_ABS), comp_id, "%s.Spindle0RPS.width-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_WIDTH_ABS = 0;
    if (retval = hal_pin_s32_newf(HAL_OUT, &(data->SIGIN_SPINDLE0RPS_WIDTH_S32), comp_id, "%s.Spindle0RPS.width-s32", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_WIDTH_S32 = 0;
    if (retval = hal_pin_u32_newf(HAL_OUT, &(data->SIGIN_SPINDLE0RPS_WIDTH_U32_ABS), comp_id, "%s.Spindle0RPS.width-u32-abs", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_WIDTH_U32_ABS = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_SPINDLE0RPS_VALID), comp_id, "%s.Spindle0RPS.valid", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_VALID = 0;
    if (retval = hal_pin_bit_newf  (HAL_OUT, &(data->SIGIN_SPINDLE0RPS_VALID_not), comp_id, "%s.Spindle0RPS.valid-not", prefix) != 0) error_handler(retval);
    *data->SIGIN_SPINDLE0RPS_VALID_not = 1 - *data->SIGIN_SPINDLE0RPS_VALID;
}

/*
    interface: SPI
*/
#include <linux/spi/spidev.h>
#include <sys/ioctl.h>  
int spifd;
static uint8_t mode = SPI_MODE_0;
static uint8_t bits = 8;
static uint32_t speed = 1000000;


int spi_init(void) {
    rtapi_print("Info: Initialize SPI5 connection\n");
    spifd = open("/dev/spidev0.0", O_RDWR);
    if (spifd < 0) {
        rtapi_print_msg(RTAPI_MSG_ERR,"Failed to open SPI device\n");
        return -1;
    }
    // Set SPI mode
    if (ioctl(spifd, SPI_IOC_WR_MODE, &mode) == -1) {
        rtapi_print_msg(RTAPI_MSG_ERR,"Failed to set SPI mode\n");
        close(spifd);
        return -1;
    }
    // Set bits per word
    if (ioctl(spifd, SPI_IOC_WR_BITS_PER_WORD, &bits) == -1) {
        rtapi_print_msg(RTAPI_MSG_ERR,"Failed to set bits per word\n");
        close(spifd);
        return -1;
    }
    // Set max speed
    if (ioctl(spifd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) == -1) {
        rtapi_print_msg(RTAPI_MSG_ERR,"Failed to set max speed\n");
        close(spifd);
        return -1;
    }
}

void spi_exit(void) {
    close(spifd);
}

int spi_trx(uint8_t *txBuffer, uint8_t *rxBuffer, uint16_t size) {
    struct spi_ioc_transfer tr = {
        .tx_buf = (uint64_t)txBuffer,
        .rx_buf = (uint64_t)rxBuffer,
        .len = size,
        .speed_hz = speed,
        .delay_usecs = 0,
        .bits_per_word = bits,
    };

    // Perform SPI transfer
    if (ioctl(spifd, SPI_IOC_MESSAGE(1), &tr) == -1) {
        rtapi_print_msg(RTAPI_MSG_ERR,"Failed to perform SPI transfer\n");
    }
    return 1;
}



int interface_init(void) {
    spi_init();
}

void interface_exit(void) {
    spi_exit();
}


/*
    hal functions
*/

/***********************************************************************
*                       HELPER FUNCTIONS                               *
************************************************************************/

uint16_t crc16_update(uint16_t crc, uint8_t a) {
	int i;

	crc ^= (uint16_t)a;
	for (i = 0; i < 8; ++i) {
		if (crc & 1)
			crc = (crc >> 1) ^ 0xA001;
		else
			crc = (crc >> 1);
	}

	return crc;
}

int error_handler(int retval) {
    if (retval < 0) {
        rtapi_print_msg(RTAPI_MSG_ERR, "%s: ERROR: pin export failed with err=%i\n", modname, retval);
        hal_exit(comp_id);
        return -1;
    }
}

int rtapi_app_main(void) {
    char name[HAL_NAME_LEN + 1];
    int retval = 0;
    int n = 0;
    data = hal_malloc(sizeof(data_t));
    comp_id = hal_init(modname);
    if (comp_id < 0) {
        rtapi_print_msg(RTAPI_MSG_ERR, "%s ERROR: hal_init() failed \n", modname);
        return -1;
    }
    register_signals();
    rtapi_snprintf(name, sizeof(name), "%s.update-freq", prefix);
    rtapi_snprintf(name, sizeof(name), "%s.readwrite", prefix);
    retval = hal_export_funct(name, rio_readwrite, data, 1, 0, comp_id);
    if (retval < 0) {
        rtapi_print_msg(RTAPI_MSG_ERR, "%s: ERROR: read function export failed\n", modname);
        hal_exit(comp_id);
        return -1;
    }
    rtapi_print_msg(RTAPI_MSG_INFO, "%s: installed driver\n", modname);
    hal_ready(comp_id);

    interface_init();

    rio_readwrite();

    return 0;
}

void rtapi_app_exit(void) {
    interface_exit();
    hal_exit(comp_id);
}

/***********************************************************************/


/***********************************************************************
*                         PLUGIN GLOBALS                               *
************************************************************************/




















/***********************************************************************/

// Generated by component_signal_converter()
// output: SIGOUT -> calc -> VAROUT -> txBuffer
void convert_varout1_bitout2_bit(data_t *data){
    bool value = *data->SIGOUT_ENABLE_BIT;
    
    data->VAROUT1_BITOUT2_BIT = value;
}

void convert_varout32_stepdir3_velocity(data_t *data){
    float value = *data->SIGOUT_STEPPERX_VELOCITY;
    value = value * *data->SIGOUT_STEPPERX_VELOCITY_SCALE;
    value = value + *data->SIGOUT_STEPPERX_VELOCITY_OFFSET;
    if (value != 0) {
                value = OSC_CLOCK / value / 2;
            }
    data->VAROUT32_STEPDIR3_VELOCITY = value;
}

void convert_varout1_stepdir3_enable(data_t *data){
    bool value = *data->SIGOUT_STEPPERX_ENABLE;
    
    data->VAROUT1_STEPDIR3_ENABLE = value;
}

void convert_varout32_stepdir4_velocity(data_t *data){
    float value = *data->SIGOUT_STEPPERY_VELOCITY;
    value = value * *data->SIGOUT_STEPPERY_VELOCITY_SCALE;
    value = value + *data->SIGOUT_STEPPERY_VELOCITY_OFFSET;
    if (value != 0) {
                value = OSC_CLOCK / value / 2;
            }
    data->VAROUT32_STEPDIR4_VELOCITY = value;
}

void convert_varout1_stepdir4_enable(data_t *data){
    bool value = *data->SIGOUT_STEPPERY_ENABLE;
    
    data->VAROUT1_STEPDIR4_ENABLE = value;
}

void convert_varout32_stepdir5_velocity(data_t *data){
    float value = *data->SIGOUT_STEPPERZ_VELOCITY;
    value = value * *data->SIGOUT_STEPPERZ_VELOCITY_SCALE;
    value = value + *data->SIGOUT_STEPPERZ_VELOCITY_OFFSET;
    if (value != 0) {
                value = OSC_CLOCK / value / 2;
            }
    data->VAROUT32_STEPDIR5_VELOCITY = value;
}

void convert_varout1_stepdir5_enable(data_t *data){
    bool value = *data->SIGOUT_STEPPERZ_ENABLE;
    
    data->VAROUT1_STEPDIR5_ENABLE = value;
}

void convert_varout1_bitout6_bit(data_t *data){
    bool value = *data->SIGOUT_OUTPUT2_BIT;
    
    data->VAROUT1_BITOUT6_BIT = value;
}

void convert_varout1_bitout7_bit(data_t *data){
    bool value = *data->SIGOUT_LED_BIT;
    
    data->VAROUT1_BITOUT7_BIT = value;
}

void convert_varout32_pwmout16_dty(data_t *data){
    float value = *data->SIGOUT_SPINDLE0_DTY;
    value = value * *data->SIGOUT_SPINDLE0_DTY_SCALE;
    value = value + *data->SIGOUT_SPINDLE0_DTY_OFFSET;
    value = (value - 0) * (OSC_CLOCK / 40) / (100 - 0);
    data->VAROUT32_PWMOUT16_DTY = value;
}

void convert_varout1_pwmout16_enable(data_t *data){
    bool value = *data->SIGOUT_SPINDLE0_ENABLE;
    
    data->VAROUT1_PWMOUT16_ENABLE = value;
}


// input: rxBuffer -> VAROUT -> calc -> SIGOUT
void convert_sigin_stepperx_position(data_t *data) {
    float value = data->VARIN32_STEPDIR3_POSITION;
    float offset = *data->SIGIN_STEPPERX_POSITION_OFFSET;
    float scale = *data->SIGIN_STEPPERX_POSITION_SCALE;
    float last_value = *data->SIGIN_STEPPERX_POSITION;
    static float last_raw_value = 0.0;
    float raw_value = value;
    value = value + offset;
    value = value / scale;
    if (*data->sys_simulation == 1) {
        value = *data->SIGIN_STEPPERX_POSITION + *data->SIGOUT_STEPPERX_VELOCITY / 1000.0;
    }
    *data->SIGIN_STEPPERX_POSITION_ABS = abs(value);
    *data->SIGIN_STEPPERX_POSITION_S32 = value;
    *data->SIGIN_STEPPERX_POSITION_U32_ABS = abs(value);
    *data->SIGIN_STEPPERX_POSITION = value;

    last_raw_value = raw_value;
}

void convert_sigin_steppery_position(data_t *data) {
    float value = data->VARIN32_STEPDIR4_POSITION;
    float offset = *data->SIGIN_STEPPERY_POSITION_OFFSET;
    float scale = *data->SIGIN_STEPPERY_POSITION_SCALE;
    float last_value = *data->SIGIN_STEPPERY_POSITION;
    static float last_raw_value = 0.0;
    float raw_value = value;
    value = value + offset;
    value = value / scale;
    if (*data->sys_simulation == 1) {
        value = *data->SIGIN_STEPPERY_POSITION + *data->SIGOUT_STEPPERY_VELOCITY / 1000.0;
    }
    *data->SIGIN_STEPPERY_POSITION_ABS = abs(value);
    *data->SIGIN_STEPPERY_POSITION_S32 = value;
    *data->SIGIN_STEPPERY_POSITION_U32_ABS = abs(value);
    *data->SIGIN_STEPPERY_POSITION = value;

    last_raw_value = raw_value;
}

void convert_sigin_stepperz_position(data_t *data) {
    float value = data->VARIN32_STEPDIR5_POSITION;
    float offset = *data->SIGIN_STEPPERZ_POSITION_OFFSET;
    float scale = *data->SIGIN_STEPPERZ_POSITION_SCALE;
    float last_value = *data->SIGIN_STEPPERZ_POSITION;
    static float last_raw_value = 0.0;
    float raw_value = value;
    value = value + offset;
    value = value / scale;
    if (*data->sys_simulation == 1) {
        value = *data->SIGIN_STEPPERZ_POSITION + *data->SIGOUT_STEPPERZ_VELOCITY / 1000.0;
    }
    *data->SIGIN_STEPPERZ_POSITION_ABS = abs(value);
    *data->SIGIN_STEPPERZ_POSITION_S32 = value;
    *data->SIGIN_STEPPERZ_POSITION_U32_ABS = abs(value);
    *data->SIGIN_STEPPERZ_POSITION = value;

    last_raw_value = raw_value;
}

void convert_sigin_home_x_bit(data_t *data) {
    bool value = data->VARIN1_BITIN8_BIT;
    *data->SIGIN_HOME_X_BIT = value;
    *data->SIGIN_HOME_X_BIT_not = 1 - value;
}

void convert_sigin_home_y_bit(data_t *data) {
    bool value = data->VARIN1_BITIN9_BIT;
    *data->SIGIN_HOME_Y_BIT = value;
    *data->SIGIN_HOME_Y_BIT_not = 1 - value;
}

void convert_sigin_home_z_bit(data_t *data) {
    bool value = data->VARIN1_BITIN10_BIT;
    *data->SIGIN_HOME_Z_BIT = value;
    *data->SIGIN_HOME_Z_BIT_not = 1 - value;
}

void convert_sigin_input5_bit(data_t *data) {
    bool value = data->VARIN1_BITIN11_BIT;
    *data->SIGIN_INPUT5_BIT = value;
    *data->SIGIN_INPUT5_BIT_not = 1 - value;
}

void convert_sigin_input6_bit(data_t *data) {
    bool value = data->VARIN1_BITIN12_BIT;
    *data->SIGIN_INPUT6_BIT = value;
    *data->SIGIN_INPUT6_BIT_not = 1 - value;
}

void convert_sigin_input7_bit(data_t *data) {
    bool value = data->VARIN1_BITIN13_BIT;
    *data->SIGIN_INPUT7_BIT = value;
    *data->SIGIN_INPUT7_BIT_not = 1 - value;
}

void convert_sigin_input8_bit(data_t *data) {
    bool value = data->VARIN1_BITIN14_BIT;
    *data->SIGIN_INPUT8_BIT = value;
    *data->SIGIN_INPUT8_BIT_not = 1 - value;
}

void convert_sigin_spindle0rps_width(data_t *data) {
    float value = data->VARIN32_PWMIN17_WIDTH;
    if (value != 0) {
                value = 1000 / (OSC_CLOCK / value);
            }
    float offset = *data->SIGIN_SPINDLE0RPS_WIDTH_OFFSET;
    float scale = *data->SIGIN_SPINDLE0RPS_WIDTH_SCALE;
    float last_value = *data->SIGIN_SPINDLE0RPS_WIDTH;
    static float last_raw_value = 0.0;
    float raw_value = value;
    value = value + offset;
    value = value / scale;
    *data->SIGIN_SPINDLE0RPS_WIDTH_ABS = abs(value);
    *data->SIGIN_SPINDLE0RPS_WIDTH_S32 = value;
    *data->SIGIN_SPINDLE0RPS_WIDTH_U32_ABS = abs(value);
    *data->SIGIN_SPINDLE0RPS_WIDTH = value;

    last_raw_value = raw_value;
}

void convert_sigin_spindle0rps_valid(data_t *data) {
    bool value = data->VARIN1_PWMIN17_VALID;
    *data->SIGIN_SPINDLE0RPS_VALID = value;
    *data->SIGIN_SPINDLE0RPS_VALID_not = 1 - value;
}



// Generated by component_buffer_converter()
void convert_outputs(void) {
    // output loop: SIGOUT -> calc -> VAROUT -> txBuffer
    convert_varout1_bitout2_bit(data);
    convert_varout32_stepdir3_velocity(data);
    convert_varout1_stepdir3_enable(data);
    convert_varout32_stepdir4_velocity(data);
    convert_varout1_stepdir4_enable(data);
    convert_varout32_stepdir5_velocity(data);
    convert_varout1_stepdir5_enable(data);
    convert_varout1_bitout6_bit(data);
    convert_varout1_bitout7_bit(data);
    convert_varout32_pwmout16_dty(data);
    convert_varout1_pwmout16_enable(data);
}

void convert_inputs(void) {
    // input: rxBuffer -> VAROUT -> calc -> SIGOUT
    convert_sigin_stepperx_position(data);
    convert_sigin_steppery_position(data);
    convert_sigin_stepperz_position(data);
    convert_sigin_home_x_bit(data);
    convert_sigin_home_y_bit(data);
    convert_sigin_home_z_bit(data);
    convert_sigin_input5_bit(data);
    convert_sigin_input6_bit(data);
    convert_sigin_input7_bit(data);
    convert_sigin_input8_bit(data);
    convert_sigin_spindle0rps_width(data);
    convert_sigin_spindle0rps_valid(data);
}

// Generated by component_buffer()
void write_txbuffer(uint8_t *txBuffer) {
    int i = 0;
    for (i = 0; i < BUFFER_SIZE; i++) {
        txBuffer[i] = 0;
    }
    // raw vars to txBuffer
    txBuffer[0] = 0x74;
    txBuffer[1] = 0x69;
    txBuffer[2] = 0x72;
    txBuffer[3] = 0x77;
    memcpy(&txBuffer[4], &data->VAROUT32_STEPDIR3_VELOCITY, 4);
    memcpy(&txBuffer[8], &data->VAROUT32_STEPDIR4_VELOCITY, 4);
    memcpy(&txBuffer[12], &data->VAROUT32_STEPDIR5_VELOCITY, 4);
    memcpy(&txBuffer[16], &data->VAROUT32_PWMOUT16_DTY, 4);
    txBuffer[20] |= (data->VAROUT1_BITOUT2_BIT<<7);
    txBuffer[20] |= (data->VAROUT1_STEPDIR3_ENABLE<<6);
    txBuffer[20] |= (data->VAROUT1_STEPDIR4_ENABLE<<5);
    txBuffer[20] |= (data->VAROUT1_STEPDIR5_ENABLE<<4);
    txBuffer[20] |= (data->VAROUT1_BITOUT6_BIT<<3);
    txBuffer[20] |= (data->VAROUT1_BITOUT7_BIT<<2);
    txBuffer[20] |= (data->VAROUT1_PWMOUT16_ENABLE<<1);
}

void read_rxbuffer(uint8_t *rxBuffer) {
    // rxBuffer to raw vars
    // TODO: check rec size and header
    memcpy(&data->VARIN32_STEPDIR3_POSITION, &rxBuffer[4], 4);
    memcpy(&data->VARIN32_STEPDIR4_POSITION, &rxBuffer[8], 4);
    memcpy(&data->VARIN32_STEPDIR5_POSITION, &rxBuffer[12], 4);
    memcpy(&data->VARIN32_PWMIN17_WIDTH, &rxBuffer[16], 4);
    data->VARIN1_BITIN8_BIT = (rxBuffer[20] & (1<<7));
    data->VARIN1_BITIN9_BIT = (rxBuffer[20] & (1<<6));
    data->VARIN1_BITIN10_BIT = (rxBuffer[20] & (1<<5));
    data->VARIN1_BITIN11_BIT = (rxBuffer[20] & (1<<4));
    data->VARIN1_BITIN12_BIT = (rxBuffer[20] & (1<<3));
    data->VARIN1_BITIN13_BIT = (rxBuffer[20] & (1<<2));
    data->VARIN1_BITIN14_BIT = (rxBuffer[20] & (1<<1));
    data->VARIN1_PWMIN17_VALID = (rxBuffer[20] & (1<<0));
}

void rio_readwrite() {
    int ret = 0;
    uint8_t i = 0;
    uint8_t rxBuffer[BUFFER_SIZE * 2];
    uint8_t txBuffer[BUFFER_SIZE * 2];
    if (*data->sys_enable_request == 1) {
        *data->sys_status = 1;
    }
    long stamp_new = rtapi_get_time();
    *data->duration = (stamp_new - stamp_last) / 1000.0;
    stamp_last = stamp_new;
    if (*data->sys_enable == 1 && *data->sys_status == 1) {
        pkg_counter += 1;
        convert_outputs();
        if (*data->sys_simulation != 1) {
            write_txbuffer(txBuffer);
            spi_trx(txBuffer, rxBuffer, BUFFER_SIZE);
            if (rxBuffer[0] == 97 && rxBuffer[1] == 116 && rxBuffer[2] == 97 && rxBuffer[3] == 100) {
                if (err_counter > 0) {
                    err_counter = 0;
                rtapi_print("recovered..\n");
                }
                read_rxbuffer(rxBuffer);
                convert_inputs();
            } else {
                err_counter += 1;
            rtapi_print("wronng data (%i/3): ", err_counter);
                for (i = 0; i < BUFFER_SIZE; i++) {
                rtapi_print("%d ",rxBuffer[i]);
                }
            rtapi_print("\n");
                if (err_counter > 3) {
                rtapi_print("too many errors..\n");
                    *data->sys_status = 0;
                }
            }
        } else {
            convert_inputs();
        }
    } else {
        *data->sys_status = 0;
    }
}

