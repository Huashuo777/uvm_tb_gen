cmp:
	@mkdir -p log
	vcs -sverilog -full64 ${ADD} -debug_acc+all \
			-q -ntb_opts uvm-1.1 -kdb \
			-f testbench.f \
			-l log/compile.log

test:
	@ls ../test | grep test | cut -d "." -f 1

clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v Makefile | grep -v testbench.f | grep -v testbench.sv | xargs rm -rf
	@echo clean done

sim:
	simv +UVM_TESTNAME=${TEST} -l log/sim.log ${ADD}
all:cmp sim
