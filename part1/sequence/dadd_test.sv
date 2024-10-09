//----------------------------------------------------------------------------------
// This code is copyrighted by BrentWang and cannot be used for commercial purposes
// The github address:https://github.com/brentwang-lab/uvm_tb_gen                   
// You can refer to the book <UVM Experiment Guide> for learning, this is on this github
// If you have any questions, please contact email:brent_wang@foxmail.com          
//----------------------------------------------------------------------------------
//                                                                                  
// Author  : BrentWang                                                              
// Project : UVM study                                                              
// Date    : Sat Jan 26 06:05:52 WAT 2022                                           
//----------------------------------------------------------------------------------
//                                                                                  
// Description:                                                                     
//     File for dadd_test.sv                                                       
//----------------------------------------------------------------------------------
class dadd_rand_test extends uvm_test;
    `uvm_component_utils(dadd_rand_test)
    dadd_environment env;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_rand_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_rand_test

function dadd_rand_test :: new(string name ="dadd_rand_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_rand_test :: build_phase(uvm_phase phase);
    seq = dadd_rand_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
    `ifdef DEFAULT_SEQUENCE
    uvm_config_db #(uvm_object_wrapper) :: set(this,"env.iagt.sqr.main_phase","default_sequence",dadd_rand_sequence::type_id::get());
    `endif//SET_DEFAULT_SEQUENCE
endfunction : build_phase

task          dadd_rand_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    `ifndef DEFAULT_SEQUENCE
    seq.starting_phase = phase;
    seq.start(env.iagt.sqr);
    `endif//SET_DEFAULT_SEQUENCE
endtask: main_phase

//reset case
class dadd_reset_test extends uvm_test;
    `uvm_component_utils(dadd_reset_test)
    dadd_environment env;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_reset_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          run_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_reset_test

function dadd_reset_test :: new(string name ="dadd_reset_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_reset_test :: build_phase(uvm_phase phase);
    seq = dadd_rand_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase

task          dadd_reset_test :: run_phase(uvm_phase phase);
    #150ns;
    force tb_dadd.dadd_if.reset_n = 0;
    #20ns;
    force tb_dadd.dadd_if.reset_n = 1;
endtask : run_phase
task          dadd_reset_test :: reset_phase(uvm_phase phase);
    env.iagt.sqr.stop_sequences();
endtask : reset_phase

task          dadd_reset_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    seq.start(env.iagt.sqr);
    phase.drop_objection(this);
endtask: main_phase
//fixen case
class dadd_fixen_test extends uvm_test;
    `uvm_component_utils(dadd_fixen_test)
    dadd_environment env;
    dadd_fixen_sequence seq;
    extern function new(string name ="dadd_fixen_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_fixen_test

function dadd_fixen_test :: new(string name ="dadd_fixen_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_fixen_test :: build_phase(uvm_phase phase);
    seq = dadd_fixen_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase

task          dadd_fixen_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    seq.start(env.iagt.sqr);
    phase.drop_objection(this);
endtask: main_phase
//sequencer arbitrate case
class dadd_arb_test extends uvm_test;
    `uvm_component_utils(dadd_arb_test)
    dadd_environment env;
    dadd_rand_sequence rand_seq;
    dadd_addr_5a5a_sequence addr_5a5a_seq;
    dadd_addr_a5a5_sequence addr_a5a5_seq;
    extern function new(string name ="dadd_arb_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_arb_test

function dadd_arb_test :: new(string name ="dadd_arb_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_arb_test :: build_phase(uvm_phase phase);
    rand_seq = dadd_rand_sequence :: type_id :: create("rand_seq");
    addr_5a5a_seq = dadd_addr_5a5a_sequence :: type_id :: create("addr_5a5a_seq");
    addr_a5a5_seq = dadd_addr_a5a5_sequence :: type_id :: create("addr_a5a5_seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase

task          dadd_arb_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    env.iagt.sqr.set_arbitration(SEQ_ARB_STRICT_FIFO);
    phase.raise_objection(this);
    fork
    addr_5a5a_seq.start(env.iagt.sqr,null,100);
    addr_a5a5_seq.start(env.iagt.sqr,null,200);
    join
    phase.drop_objection(this);
endtask: main_phase
//sequencer lock and grab case
class dadd_lock_grab_test extends uvm_test;
    `uvm_component_utils(dadd_lock_grab_test)
    dadd_environment env;
    dadd_rand_sequence rand_seq;
    dadd_addr_5a5a_sequence addr_5a5a_seq;
    dadd_addr_a5a5_sequence addr_a5a5_seq;
    extern function new(string name ="dadd_lock_grab_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_lock_grab_test

function dadd_lock_grab_test :: new(string name ="dadd_lock_grab_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_lock_grab_test :: build_phase(uvm_phase phase);
    rand_seq = dadd_rand_sequence :: type_id :: create("rand_seq");
    addr_5a5a_seq = dadd_addr_5a5a_sequence :: type_id :: create("addr_5a5a_seq");
    addr_a5a5_seq = dadd_addr_a5a5_sequence :: type_id :: create("addr_a5a5_seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase

task          dadd_lock_grab_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);
    fork
    addr_5a5a_seq.start(env.iagt.sqr);
    addr_a5a5_seq.start(env.iagt.sqr);
    rand_seq.start(env.iagt.sqr);
    join
    phase.drop_objection(this);
endtask: main_phase

class dadd_virtual_test extends uvm_test;
    `uvm_component_utils(dadd_virtual_test)
    dadd_environment env;
    extern function new(string name ="dadd_virtual_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
endclass: dadd_virtual_test

function dadd_virtual_test :: new(string name ="dadd_virtual_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_virtual_test :: build_phase(uvm_phase phase);
    env = dadd_environment :: type_id :: create("env",this);
    uvm_config_db #(uvm_object_wrapper) :: set(this,"env.vsqr.main_phase","default_sequence",dadd_virtual_sequence::type_id::get());
endfunction : build_phase

//layer sequence test
class dadd_layer_test extends uvm_test;
    `uvm_component_utils(dadd_layer_test)
    dadd_environment env;
    extern function new(string name ="dadd_layer_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
endclass: dadd_layer_test

function dadd_layer_test :: new(string name ="dadd_layer_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_layer_test :: build_phase(uvm_phase phase);
    env = dadd_environment :: type_id :: create("env",this);
    uvm_config_db #(uvm_object_wrapper) :: set(this,"env.layer_vsqr.main_phase","default_sequence",dadd_layer_virtual_sequence::type_id::get());
endfunction : build_phase
