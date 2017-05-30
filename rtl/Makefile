# Makefile for icaurs

# (ncverilog runs cadence's compiler and simulator, icarus has
# separate commands: vvp (simulator) and iverilog (compiler))
COMPILER = iverilog -Wall -g2009 -DNO_TIMING -DSIM_IS_ICARUS

.PHONY: clean
.SUFFIXES: .vvp .v

all: $(MODULES:=.vvp)

.v.vvp:
	$(eval BASE := $(@:.vvp=))
	$(COMPILER) -o$@ $<

clean:
	rm -f *.vvp a.out


