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
//     File for axi_master_sequence_base.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_SEQUENCE_LIB__SV
`define AXI_MASTER_SEQUENCE_LIB__SV

typedef class axi_master_sequencer;
class axi_master_sequence_base extends uvm_sequence #(axi_master_item);
    virtual axi_master_interface vif;

    axi_master_config cfg;
    uvm_event_pool events;

    `uvm_object_utils(axi_master_sequence_base)
    `uvm_declare_p_sequencer(axi_master_sequencer)
    extern         function new(string name = "axi_master_sequence_base");
    extern virtual task pre_start();
endclass

function axi_master_sequence_base :: new(string name = "axi_master_sequence_base");
    super.new(name);
endfunction : new

task axi_master_sequence_base :: pre_start();
    cfg = p_sequencer.cfg;
    events = cfg.events;
endtask : pre_start

`endif //AXI_MASTER_SEQUENCE_LIB__SV
