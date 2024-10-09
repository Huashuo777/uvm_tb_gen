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
//     File for axi_master_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_SEQUENCER__SV
`define AXI_MASTER_SEQUENCER__SV
class axi_master_sequencer extends uvm_sequencer #(axi_master_item);
    virtual axi_master_interface vif;
    axi_master_config cfg;
    uvm_event_pool events;
    `uvm_component_utils(axi_master_sequencer)

    extern         function new(string name = "axi_master_sequencer", uvm_component parent);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : axi_master_sequencer

function axi_master_sequencer :: new(string name = "axi_master_sequencer", uvm_component parent);
    super.new(name,parent);
endfunction : new

function void axi_master_sequencer :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase
`endif //AXI_MASERR_SEQUENCER__SV
