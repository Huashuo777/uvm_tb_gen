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
endclass: dadd_rand_test

function dadd_rand_test :: new(string name ="dadd_rand_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_rand_test :: build_phase(uvm_phase phase);
    seq = dadd_rand_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
    uvm_config_db #(uvm_object_wrapper) :: set(this,"env.iagt.sqr.main_phase","default_sequence",dadd_rand_sequence::type_id::get());
endfunction : build_phase
