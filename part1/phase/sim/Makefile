cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log 
rand_sim:
	./simv -full64 +UVM_TESTNAME=dadd_rand_test -l sim.log
reset_sim:
	./simv -full64 +UVM_TESTNAME=dadd_reset_test -l sim.log  
rand:cmp rand_sim
reset:cmp reset_sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
