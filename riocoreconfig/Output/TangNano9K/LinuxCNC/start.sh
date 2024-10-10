#!/bin/sh

set -e
set -x

DIRNAME=`dirname "$0"`
halcompile --install "$DIRNAME/rio.c"

linuxcnc "$DIRNAME/rio.ini" $@
