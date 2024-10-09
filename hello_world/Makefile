vlogan:
	vlogan -ntb_opts uvm-1.1
	vlogan -timescale=1ns/1ns -ntb_opts uvm-1.1 hello_world.sv -l ./log
cmp:
	vcs +vcs+initreg+random -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 hello_world.sv
sim:
	./simv -full64 +UVM_VERBOSITY=UVM_LOW -l run.log  +notimingcheck
clean:
	rm -rf  csrc/ run.log  simv*  simv.daidir/  ucli.key  vc_hdrs.h AN.DB
all:cmp sim
