SEED = $(shell date +%s)
cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -f ../dadd/top/tb_dadd.f -l compile.log
sim:
	./simv -full64 +notimingcheck +BVM_TESTNAME=dadd_smoke_test +ntb_random_seed=$(SEED) -l sim.log  
all:cmp sim
dve:
	dve -vpd vcdplus.vpd &
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
