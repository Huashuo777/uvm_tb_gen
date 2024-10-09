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
//     File for apb_slave_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_SEQUENCER__SV
`define APB_SLAVE_SEQUENCER__SV
class apb_slave_sequencer extends uvm_sequencer #(apb_slave_item);
    virtual apb_slave_interface vif;
    apb_slave_config cfg;
    uvm_event_pool events;
    `uvm_component_utils(apb_slave_sequencer)

    extern         function new(string name = "apb_slave_sequencer", uvm_component parent);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : apb_slave_sequencer

function apb_slave_sequencer :: new(string name = "apb_slave_sequencer", uvm_component parent);
    super.new(name,parent);
endfunction : new

function void apb_slave_sequencer :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase
`endif //APB_SLAVE_SEQUENCER__SV
