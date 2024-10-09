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
//     File for apb_master_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_INCLUDE__SV
`define APB_MASTER_INCLUDE__SV
    `include "apb_master_config.sv"
    `include "apb_master_item.sv"
    `include "apb_master_sequence_base.sv"
    `include "apb_master_sequencer.sv"
    `include "apb_master_driver.sv"
    `include "apb_master_monitor.sv"
    `include "apb_master_cov_monitor.sv"
    `include "apb_master_adapter.sv"
    `include "apb_master_agent.sv"
`endif //APB_MASTER_INCLUDE__SV
