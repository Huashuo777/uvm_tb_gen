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
//     File for cfg_sequencer.sv                                                       
//----------------------------------------------------------------------------------
class cfg_sequencer extends uvm_sequencer #(cfg_item);
    uvm_analysis_port #(cfg_item) ap;
    `uvm_component_utils(cfg_sequencer)
    extern function new(string name ="cfg_sequencer", uvm_component parent);
endclass: cfg_sequencer

function cfg_sequencer :: new(string name ="cfg_sequencer", uvm_component parent);
    super.new(name, parent);
    ap = new("ap",this);
endfunction: new
