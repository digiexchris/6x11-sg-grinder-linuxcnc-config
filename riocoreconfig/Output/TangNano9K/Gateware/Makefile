
# Toolchain: Icestorm

PROJECT   := rio
TOP       := rio
CLK_SPEED := 27.0
FAMILY    := himbaechel
DEVICE_FAMILY   := GW1N-9C
TYPE      := GW1NR-LV9QN88PC6/I5
PACKAGE   := 
VERILOGS  := globals.v spi.v freqin.v pwmout.v stepdir.v debouncer.v toggle.v pwmmod.v rio.v

all: $(PROJECT).fs

$(PROJECT).json: $(VERILOGS)
	yosys -q -l yosys.log -p 'synth_gowin -noalu -nowidelut -top $(TOP) -json $(PROJECT).json' $(VERILOGS)

$(PROJECT)_pnr.json: $(PROJECT).json pins.cst
	nextpnr-himbaechel -q -l nextpnr.log --timing-allow-fail --json $(PROJECT).json --write $(PROJECT)_pnr.json --freq $(CLK_SPEED) --device $(TYPE) --vopt cst=pins.cst --vopt family=${DEVICE_FAMILY}
	@echo ""
	@grep -B 1 "%$$" nextpnr.log
	@echo ""

$(PROJECT).fs: $(PROJECT)_pnr.json
	gowin_pack -d ${DEVICE_FAMILY} -o $(PROJECT).fs $(PROJECT)_pnr.json
	cp -v hash_new.txt hash_compiled.txt

clean:
	rm -rf $(PROJECT).fs $(PROJECT).json $(PROJECT)_pnr.json $(PROJECT).tcl abc.history impl yosys.log nextpnr.log

check:
	verilator --top-module $(PROJECT) --lint-only -Wall *.v

sim: $(VERILOGS)
	verilator --cc --exe --build -j 0 -Wall --top-module $(PROJECT) sim_main.cpp $(VERILOGS)

tinyprog: $(PROJECT).fs
	tinyprog -p $(PROJECT).fs

load: $(PROJECT).fs
	openFPGALoader -b tangnano9k $(PROJECT).fs -f
	cp -v hash_new.txt hash_flashed.txt

