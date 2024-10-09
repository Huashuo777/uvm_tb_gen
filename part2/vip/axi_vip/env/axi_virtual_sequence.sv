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
//     File for axi_virtual_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_VIRTUAL_SEQUENCE__SV
`define AXI_VIRTUAL_SEQUENCE__SV
class axi_virtual_sequence extends uvm_sequence_base;
    axi_env_config cfg;
    uvm_event_pool  events;

    `uvm_object_utils(axi_virtual_sequence)
    `uvm_declare_p_sequencer(axi_virtual_sequencer)
    extern function new(string name = "axi_virtual_sequence");
    extern virtual task pre_start();
endclass

function axi_virtual_sequence :: new(string name = "axi_virtual_sequence");
    super.new();
endfunction : new

task axi_virtual_sequence :: pre_start();
    cfg = p_sequencer.cfg;
    events = cfg.events;
endtask : pre_start
`endif //AXI_VIRTUAL_SEQUENCE__SV
