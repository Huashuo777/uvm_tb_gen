cmp:
	vcs -sverilog -full64 -debug_access+all -timescale=1ns/1ps -f ../tb/filelist.f -l compile.log +nospecify
sim:
	simv -l sim.log
all: cmp sim

dve:
	dve -vpd vcdplus.vpd &
clean: 
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v Makefile | xargs rm -rf
	@echo Clean done.
