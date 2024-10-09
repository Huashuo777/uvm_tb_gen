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
    dadd_driver drv;
    dadd_rand_sequencer sqr;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_rand_test",uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
endclass: dadd_rand_test

function dadd_rand_test :: new(string name ="dadd_rand_test",uvm_component parent = null);
    super.new(name,parent);
    drv = new("drv",this);
    sqr = new("sqr",this);
    seq = new("seq");
    drv.seq_item_port.connect(sqr.seq_item_export);
endfunction : new

task dadd_rand_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    uvm_top.print_topology();
    phase.raise_objection(this);
    #100ns;
    seq.start(sqr);
    phase.drop_objection(this);
endtask : main_phase
