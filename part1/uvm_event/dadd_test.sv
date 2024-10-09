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
/*************************************************************************************/                                                                                                                                           
/**********************************Rand Test******************************************/
/*************************************************************************************/
class dadd_rand_test extends uvm_test;                                                                                                                                                                                            
    `uvm_component_utils(dadd_rand_test)
    uvm_event_pool event_pool;
    uvm_event an_event;
    dadd_environment env;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_rand_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
endclass: dadd_rand_test

function dadd_rand_test :: new(string name ="dadd_rand_test",uvm_component parent = null);
    super.new(name,parent);
    seq = new("seq");
    env = new("env",this);
endfunction : new

function void dadd_rand_test :: build_phase(uvm_phase phase);
    event_pool = uvm_event_pool :: get_global_pool();
    env.event_pool = event_pool;

endfunction : build_phase

task dadd_rand_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    an_event = event_pool.get("an_event");
    uvm_top.print_topology();
    phase.raise_objection(this);
    seq.start(env.iagt.sqr);
    an_event.wait_trigger();
    phase.drop_objection(this);
endtask : main_phase
