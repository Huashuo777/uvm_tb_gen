cmp:
	vcs -full64 -debug_access+all -timescale=1ns/100ps ../dadd.v ../tb_dadd.v -l compile.log 
sim:
	./simv -l sim.log  
all:cmp sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
