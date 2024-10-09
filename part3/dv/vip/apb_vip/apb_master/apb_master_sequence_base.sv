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
//     File for apb_master_sequence_base.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_SEQUENCE_LIB__SV
`define APB_MASTER_SEQUENCE_LIB__SV

typedef class apb_master_sequencer;
class apb_master_sequence_base extends uvm_sequence #(apb_master_item);
    virtual apb_master_interface vif;

    apb_master_config cfg;
    uvm_event_pool events;

    `uvm_object_utils(apb_master_sequence_base)
    `uvm_declare_p_sequencer(apb_master_sequencer)
    extern         function new(string name = "apb_master_sequence_base");
    extern virtual task pre_start();
endclass

function apb_master_sequence_base :: new(string name = "apb_master_sequence_base");
    super.new(name);
endfunction : new

task apb_master_sequence_base :: pre_start();
    cfg = p_sequencer.cfg;
    events = cfg.events;
endtask : pre_start

`endif //APB_MASTER_SEQUENCE_LIB__SV

