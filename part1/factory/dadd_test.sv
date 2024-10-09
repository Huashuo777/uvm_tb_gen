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
class dadd_fixen_test extends uvm_test;
    `uvm_component_utils(dadd_fixen_test)
    dadd_environment env;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_fixen_test",uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
endclass: dadd_fixen_test

function dadd_fixen_test :: new(string name ="dadd_fixen_test",uvm_component parent = null);
    super.new(name,parent);
    set_type_override_by_type(dadd_driver::get_type(),dadd_fixen_driver::get_type());
    seq = dadd_rand_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : new

task dadd_fixen_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    uvm_top.print_topology();
    phase.raise_objection(this);
    #100ns;
    seq.start(env.iagt.sqr);
    phase.drop_objection(this);
endtask : main_phase
