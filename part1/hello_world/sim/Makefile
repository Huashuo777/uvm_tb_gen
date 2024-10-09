cmp:
	vcs -full64 -sverilog -timescale=1ns/1ns -ntb_opts uvm-1.1 ../hello_world.sv -l compile.log 
sim:
	./simv -full64 +UVM_TESTNAME=hello_world_test -l sim.log  
all:cmp sim
clean:
	@ls | egrep -v "Makefile" | xargs rm -rf
	@echo Clean done.
