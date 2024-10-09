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
//     File for local_bus_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_INCLUDE
`define LOCAL_BUS_INCLUDE
    `include "local_bus_define.sv"
    `include "local_bus_type.sv"
    `include "local_bus_config.sv"
    `include "local_bus_item.sv"
    `include "local_bus_sequence_lib.sv"
    `include "local_bus_sequencer.sv"
    `include "local_bus_driver.sv"
    `include "local_bus_monitor.sv"
    `include "local_bus_adapter.sv"
    `include "local_bus_agent.sv"
`endif //LOCAL_BUS_INCLUDE
