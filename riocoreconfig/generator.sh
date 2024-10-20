#!/bin/bash
export PATH=$PATH:/opt/oss-cad-suite/bin/
# export PATH=$PATH:/opt/Xilinx/Vivado/2023.1/bin/
# export PATH=$PATH:/opt/gowin/IDE/bin/
# export PATH=$PATH:/opt/intelFPGA_lite/22.1std/quartus/bin/
#$ export PATH=$PATH:/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/
PYTHONPATH=./riocore/ riocore/bin/rio-setup ./config.json
