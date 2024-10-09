cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns  -f dsel.f -l compile.log 
sim:
	./simv -full64  +notimingcheck -l sim.log  
all:cmp sim
clean:
	rm -rf csrc/  DVEfiles/ sim.log  simv*  simv.daidir/  ucli.key  vcdplus.vpd  vc_hdrs.h compile.log cm.log

