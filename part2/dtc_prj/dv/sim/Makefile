#COMMAND EXAMPLE: make all MOD=dadd TEST=dadd_smoke_test SEED=123
SEED = $(shell date +%s)
cmp:
	vcs -sverilog -full64 ${ADD} -debug_access+all -timescale=1ns/100ps \
    -q -ntb_opts uvm-1.1 -kdb \
    -f ../${MOD}/top/tb_${MOD}.f \
    -l compile.log
	@echo Module:${MOD} compile done.
sim:
	simv +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=${TEST} +ntb_random_seed=$(SEED) -l sim.log ${ADD}
all: cmp sim

dve:
	dve -vpd vcdplus.vpd &
cov:
	dve -full64 -covdir simv.vdb &
clean: 
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v Makefile | xargs rm -rf
	@echo Clean done.
