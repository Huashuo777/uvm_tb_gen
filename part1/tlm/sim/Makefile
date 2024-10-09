cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tlm_test.sv -l compile.log
sim:
	./simv -full64 -l sim.log  +notimingcheck
all:cmp sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
