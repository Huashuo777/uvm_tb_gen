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
//     File for apb_slave_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_INCLUDE__SV
`define APB_SLAVE_INCLUDE__SV
    `include "apb_slave_memory.sv"
    `include "apb_slave_config.sv"
    `include "apb_slave_item.sv"
    `include "apb_slave_sequence_base.sv"
    `include "apb_slave_sequencer.sv"
    `include "apb_slave_driver.sv"
    `include "apb_slave_monitor.sv"
    `include "apb_slave_cov_monitor.sv"
    `include "apb_slave_agent.sv"
`endif //APB_SLAVE_INCLUDE__SV
