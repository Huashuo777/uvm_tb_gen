SEED = $(shell date +%s)
cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns ../factory_test.sv -l compile.log
sim:
	./simv -full64 +notimingcheck +ntb_random_seed=$(SEED) -l sim.log  
all:cmp sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
