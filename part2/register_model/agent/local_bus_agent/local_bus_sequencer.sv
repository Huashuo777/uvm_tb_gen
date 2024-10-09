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
//     File for local_bus_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_SEQUENCER
`define LOCAL_BUS_SEQUENCER
class local_bus_sequencer extends uvm_sequencer #(local_bus_item);
    virtual local_bus_interface vif;
    `uvm_component_utils(local_bus_sequencer)

    extern         function new(string name = "local_bus_sequencer", uvm_component parent);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : local_bus_sequencer

function local_bus_sequencer :: new(string name = "local_bus_sequencer", uvm_component parent);
    super.new(name,parent);
endfunction : new

function void local_bus_sequencer :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction : connect_phase
`endif //LOCAL_BUS_MASERR_SEQUENCER

