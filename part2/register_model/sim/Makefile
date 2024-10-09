cmp:
	vcs -full64 -sverilog -debug_access+all -q -ntb_opts uvm-1.1 -timescale=1ns/1ns ../rtl/version_info.v -f ../top/tb_ral.f -l compile.log 
sim:
	./simv -full64 +UVM_TESTNAME=${TEST} -l sim.log  
all:cmp sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
