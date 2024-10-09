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
//     File for dsel_loc_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_SEQUENCER__SV
`define DSEL_LOC_SEQUENCER__SV
class dsel_loc_sequencer extends uvm_sequencer #(dsel_loc_item);
    dsel_loc_config cfg;
    uvm_event_pool events;
    virtual dsel_loc_interface vif;
    `uvm_component_utils(dsel_loc_sequencer)
    extern          function new(string name ="dsel_loc_sequencer", uvm_component parent);
    extern virtual  function void connect_phase(uvm_phase phase);

endclass: dsel_loc_sequencer

function dsel_loc_sequencer :: new(string name ="dsel_loc_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dsel_loc_sequencer :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase
`endif // DSEL_LOC_SEQUENCER__SV
