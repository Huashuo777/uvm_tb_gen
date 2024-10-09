rand_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log
rand_sim:
	./simv -full64 +UVM_TESTNAME=dadd_rand_test -l sim.log
rand: rand_cmp rand_sim

reset_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log
reset_sim:
	./simv -full64 +UVM_TESTNAME=dadd_reset_test -l sim.log
reset: reset_cmp reset_sim

#send_item start_item
send_item_start_item_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+START_ITEM
send_item_start_item_sim:
	./simv -full64 +UVM_TESTNAME=dadd_rand_test -l sim.log +define+START_ITEM 
send_item_start_item: send_item_start_item_cmp send_item_start_item_sim
#send_item uvm_create
send_item_uvm_create_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+UVM_CREATE
send_item_uvm_create_sim:
	./simv -full64 +UVM_TESTNAME=dadd_rand_test -l sim.log +define+UVM_CREATE
send_item_uvm_create: send_item_uvm_create_cmp send_item_uvm_create_sim
#send_item uvm_do
send_item_uvm_do_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log
send_item_uvm_do_sim:
	./simv -full64 +UVM_TESTNAME=dadd_rand_test -l sim.log
send_item_uvm_do: send_item_uvm_do_cmp send_item_uvm_do_sim

#send_seq start
send_seq_start_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+SEND_SEQ +define+START
send_seq_start_sim:
	./simv -full64 +UVM_TESTNAME=dadd_fixen_test -l sim.log +define+SEND_SEQ +define+START 
send_seq_start: send_seq_start_cmp send_seq_start_sim
#send_seq uvm_create
send_seq_uvm_create_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+SEND_SEQ +define+UVM_CREATE
send_seq_uvm_create_sim:
	./simv -full64 +UVM_TESTNAME=dadd_fixen_test -l sim.log +define+SEND_SEQ +define+UVM_CREATE
send_seq_uvm_create: send_seq_uvm_create_cmp send_seq_uvm_create_sim
#send_seq uvm_do
send_seq_uvm_do_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+SEND_SEQ
send_seq_uvm_do_sim:
	./simv -full64 +UVM_TESTNAME=dadd_fixen_test -l sim.log +define+SEND_SEQ
send_seq_uvm_do: send_seq_uvm_do_cmp send_seq_uvm_do_sim
#default_sequence
default_seq_rand_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+DEFAULT_SEQUENCE
default_seq_rand_sim:
	./simv -full64 +UVM_TESTNAME=dadd_rand_test -l sim.log +define+DEFAULT_SEQUENCE
default_seq_rand: default_seq_rand_cmp default_seq_rand_sim
#sequencer arb
arb_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log
arb_sim:
	./simv -full64 +UVM_TESTNAME=dadd_arb_test -l sim.log
arb: arb_cmp arb_sim
#sequencer lock
sqr_lock_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+SQR_LOCK
sqr_lock_sim:
	./simv -full64 +UVM_TESTNAME=dadd_lock_grab_test -l sim.log +define+SQR_LOCK
sqr_lock: sqr_lock_cmp sqr_lock_sim
#sequencer grab
sqr_grab_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log +define+SQR_GRAB
sqr_grab_sim:
	./simv -full64 +UVM_TESTNAME=dadd_lock_grab_test -l sim.log +define+SQR_GRAB
sqr_grab: sqr_grab_cmp sqr_grab_sim

vsqr_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log
vsqr_sim:
	./simv -full64 +UVM_TESTNAME=dadd_virtual_test -l sim.log
vsqr: vsqr_cmp vsqr_sim

layer_cmp:
	vcs -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 ../tb_dadd.sv -l compile.log
layer_sim:
	./simv -full64 +UVM_TESTNAME=dadd_layer_test -l sim.log
layer: layer_cmp layer_sim
clean:
	@rm .[a-zA-Z0-9]* -rf
	@ls | grep -v 'Makefile' | xargs rm -rf
	@echo Clean done.
