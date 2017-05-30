# Max Howald

# commad to run the icarus verilog simulator. also see rtl/Makefile.
ICARUS_SIMULATOR = vvp -v
# This runs the compiler and simulator without the gui.
CADENCE_SIM = ncverilog +incdir+../rtl +access+rw +nc64bit -sv

# if defined (e.g. with make NO_TIMING=1, the timing basicCells.v
# timings library will not be included (useful for behavioral
# simulation)
ifdef NO_TIMING
CADENCE_SIM += +define+NO_TIMING
endif

# list of testbenchs.
MODULES = input_block_TB rsc_TB output_block_TB TurboEncoderTB \
AddrEncoder_TB SRAM10T_TB \
dpu_TB filter_TB mapper_TB shape_TB upsample_TB \
transmitter_TB

#set to icarus (e.g. make SIM=icarus on the cmd line) to use icarus.
SIM=nc

.PHONY: clean synth_clean

all: $(MODULES:%=$(SIM)_%)

icarus_%:
	$(eval TARG := $(@:icarus_%=%))
	make -C rtl $(TARG).vvp
	$(ICARUS_SIMULATOR) rtl/$(TARG).vvp

nc_%:
	$(eval TARG := $(@:nc_%=%))
	mkdir -p build_$(TARG)
	( cd build_$(TARG) && $(CADENCE_SIM) ../rtl/$(TARG).v )

clean:
	make -C rtl clean
	rm -rf build_*
	rm -f ncverilog.log *.vcd
	rm -rf .simvision sxcmd.log simvision*.diag

synth_clean:
	find -name logs_* | xargs rm -rf
	find -name outputs_* | xargs rm -rf
	find -name reports_* | xargs rm -rf
	find -name fv | xargs rm -rf
	find -name genus.* | xargs rm -rf
	find -name .rs.tstamp | xargs rm -rf
	find -name synthesis | xargs rm -rf
