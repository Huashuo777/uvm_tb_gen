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
//     File for dadd_sequencer.sv                                                       
//----------------------------------------------------------------------------------
class dadd_rand_sequencer extends uvm_sequencer #(dadd_item);
    `uvm_component_utils(dadd_rand_sequencer)
    virtual dadd_interface vif;
    extern function new(string name ="dadd_rand_sequencer", uvm_component parent);
endclass: dadd_rand_sequencer

function dadd_rand_sequencer :: new(string name ="dadd_rand_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction: new
