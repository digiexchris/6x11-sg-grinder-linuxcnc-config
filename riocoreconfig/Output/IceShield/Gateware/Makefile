
# Toolchain: Icestorm

PROJECT   := rio
TOP       := rio
CLK_SPEED := 29.812
FAMILY    := ice40
TYPE      := up5k
PACKAGE   := sg48
VERILOGS  := globals.v pll.v blink.v spi.v stepdir.v pwmout.v pwmin.v debouncer.v toggle.v pwmmod.v rio.v

all: $(PROJECT).bin

$(PROJECT).json: $(VERILOGS)
	yosys -q -l yosys.log -p 'synth_$(FAMILY) -dsp -top $(TOP) -json $(PROJECT).json' $(VERILOGS)

$(PROJECT).asc: $(PROJECT).json pins.pcf
	nextpnr-$(FAMILY) -q -l nextpnr.log --timing-allow-fail --pre-pack prepack.py --$(TYPE) --package $(PACKAGE) --json $(PROJECT).json --freq $(CLK_SPEED) --pcf pins.pcf --asc $(PROJECT).asc
	@echo ""
	@grep -B 1 "%$$" nextpnr.log
	@echo ""

$(PROJECT).bin: $(PROJECT).asc
	icepack $(PROJECT).asc $(PROJECT).bin
	cp -v hash_new.txt hash_compiled.txt

clean:
	rm -rf $(PROJECT).bin $(PROJECT).asc $(PROJECT).json yosys.log nextpnr.log

check:
	verilator --top-module $(PROJECT) --lint-only -Wall *.v

sim: $(VERILOGS)
	verilator --cc --exe --build -j 0 -Wall --top-module $(PROJECT) sim_main.cpp $(VERILOGS)

tinyprog: $(PROJECT).bin
	tinyprog -p $(PROJECT).bin

load: $(PROJECT).bin
	./spiflash.sh rio.bin

