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
//     File for axi_slave_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_INCLUDE__SV
`define AXI_SLAVE_INCLUDE__SV
    `include "axi_slave_memory.sv"
    `include "axi_slave_config.sv"
    `include "axi_slave_item.sv"
    `include "axi_slave_sequence_base.sv"
    `include "axi_slave_sequencer.sv"
    `include "axi_slave_driver.sv"
    `include "axi_slave_monitor.sv"
    `include "axi_slave_cov_monitor.sv"
    `include "axi_slave_agent.sv"
`endif //AXI_SLAVE_INCLUDE__SV
