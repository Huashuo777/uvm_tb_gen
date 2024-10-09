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
//     File for axi_virtual_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_VIRTUAL_SEQUENCER__SV
`define AXI_VIRTUAL_SEQUENCER__SV
class axi_virtual_sequencer extends uvm_virtual_sequencer;

    axi_env_config cfg;
    uvm_event_pool  events;

    axi_master_sequencer  mst_sqr[];
    axi_slave_sequencer   slv_sqr[];

    `uvm_component_utils(axi_virtual_sequencer)

    extern                   function      new(string name, uvm_component parent);
    extern                   function void connect_phase(uvm_phase phase);
endclass : axi_virtual_sequencer

function axi_virtual_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void axi_virtual_sequencer::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (cfg == null)
        `uvm_fatal("connect_phase", "Virtual sequencer cannot get env configuration object")

    events = cfg.events;
endfunction : connect_phase

`endif //AXI_VIRTUAL_SEQUENCER__SV
