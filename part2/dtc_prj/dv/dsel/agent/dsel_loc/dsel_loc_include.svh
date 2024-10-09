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
//     File for dsel_loc_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_INCLUDE__SV
`define DSEL_LOC_INCLUDE__SV
    `include "dsel_loc_define.sv"
    `include "dsel_loc_type.sv"
    `include "dsel_loc_config.sv"
    `include "dsel_loc_item.sv"
    `include "dsel_loc_base_sequence.sv"
    `include "dsel_loc_sequencer.sv"
    `include "dsel_loc_driver.sv"
    `include "dsel_loc_monitor.sv"
    `include "dsel_loc_agent.sv"
`endif // DSEL_LOC_INCLUDE__SV
