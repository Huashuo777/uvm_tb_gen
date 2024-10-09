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
//     File for dtc_loc_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_SEQUENCER__SV
`define DTC_LOC_SEQUENCER__SV
class dtc_loc_sequencer extends uvm_sequencer #(dtc_loc_item);
    virtual dtc_loc_interface vif;
    dtc_loc_config cfg;
    uvm_event_pool events;
    `uvm_component_utils(dtc_loc_sequencer)

    extern         function new(string name = "dtc_loc_sequencer", uvm_component parent);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : dtc_loc_sequencer

function dtc_loc_sequencer :: new(string name = "dtc_loc_sequencer", uvm_component parent);
    super.new(name,parent);
endfunction : new

function void dtc_loc_sequencer :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase
`endif //AXI_MASERR_SEQUENCER__SV
