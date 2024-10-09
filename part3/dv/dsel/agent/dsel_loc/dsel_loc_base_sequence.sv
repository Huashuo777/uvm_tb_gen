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
//     File for dsel_loc_base_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_BASE_SEQUENCE__SV
`define DSEL_LOC_BASE_SEQUENCE__SV
typedef class dsel_loc_sequencer;
class dsel_loc_base_sequence extends uvm_sequence #(dsel_loc_item);
    virtual dsel_loc_interface vif;

    dsel_loc_config cfg;
    uvm_event_pool events;

    `uvm_object_utils(dsel_loc_base_sequence)
    `uvm_declare_p_sequencer(dsel_loc_sequencer)
    extern         function new(string name = "dsel_loc_base_sequence");
    extern virtual task pre_start();
endclass

function dsel_loc_base_sequence :: new(string name = "dsel_loc_base_sequence");
    super.new(name);
endfunction : new

task dsel_loc_base_sequence :: pre_start();
    `uvm_info(get_type_name(),"Starting task pre_start...", UVM_HIGH)
    cfg = p_sequencer.cfg;
    events = cfg.events;
    `uvm_info(get_type_name(),"Finish task pre_start...", UVM_HIGH)
endtask : pre_start

`endif //DSEL_LOC_BASE_SEQUENCE__SV
