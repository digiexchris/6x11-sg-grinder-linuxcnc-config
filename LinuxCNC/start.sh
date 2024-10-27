#!/bin/sh

set -e
set -x

DIRNAME=`dirname "$0"`

gpio mode 7 clock
gpio clock 7 5000000

linuxcnc "$DIRNAME/config.ini" $@
