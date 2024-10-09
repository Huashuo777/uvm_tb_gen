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
//     File for local_bus_sequence_lib.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_SEQUENCE_LIB_SV
`define LOCAL_BUS_SEQUENCE_LIB_SV

typedef class local_bus_sequencer;
class local_bus_sequence_base extends uvm_sequence #(local_bus_item);
    virtual local_bus_interface vif;

    `uvm_object_utils(local_bus_sequence_base)
    `uvm_declare_p_sequencer(local_bus_sequencer)
    extern         function new(string name = "local_bus_sequence_base");
    extern virtual task pre_start();
endclass

function local_bus_sequence_base :: new(string name = "local_bus_sequence_base");
    super.new(name);
endfunction : new

task local_bus_sequence_base :: pre_start();
endtask : pre_start

`endif //LOCAL_BUS_SEQUENCE_LIB_SV

