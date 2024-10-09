cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log 
sim:
	./simv -full64 +UVM_TESTNAME=dadd_fixen_test -l sim.log  
all:cmp sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
