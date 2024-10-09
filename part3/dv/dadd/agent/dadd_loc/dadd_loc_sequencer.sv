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
//     File for dadd_loc_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_SEQUENCER__SV
`define DADD_LOC_SEQUENCER__SV
class dadd_loc_sequencer extends uvm_sequencer #(dadd_loc_item);
    virtual dadd_loc_interface vif;
    dadd_loc_config cfg;
    uvm_event_pool events;
    `uvm_component_utils(dadd_loc_sequencer)
    extern         function new(string name = "dadd_loc_sequencer", uvm_component parent);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : dadd_loc_sequencer

function dadd_loc_sequencer :: new(string name = "dadd_loc_sequencer", uvm_component parent);
    super.new(name,parent);
endfunction : new

function void dadd_loc_sequencer :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase
`endif //AXI_MASERR_SEQUENCER__SV
