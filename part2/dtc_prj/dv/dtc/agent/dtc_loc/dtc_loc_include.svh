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
//     File for dtc_loc_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_INCLUDE__SV
`define DTC_LOC_INCLUDE__SV
    `include "dtc_loc_define.sv"
    `include "dtc_loc_type.sv"
    `include "dtc_loc_config.sv"
    `include "dtc_loc_item.sv"
    `include "dtc_loc_base_sequence.sv"
    `include "dtc_loc_sequencer.sv"
    `include "dtc_loc_driver.sv"
    `include "dtc_loc_monitor.sv"
    `include "dtc_loc_agent.sv"
`endif // DTC_LOC_INCLUDE__SV
