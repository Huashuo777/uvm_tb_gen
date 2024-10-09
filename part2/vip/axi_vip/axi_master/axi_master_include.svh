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
//     File for axi_master_include.svh                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_INCLUDE__SV
`define AXI_MASTER_INCLUDE__SV
    `include "axi_master_config.sv"
    `include "axi_master_item.sv"
    `include "axi_master_sequence_base.sv"
    `include "axi_master_sequencer.sv"
    `include "axi_master_driver.sv"
    `include "axi_master_monitor.sv"
    `include "axi_master_cov_monitor.sv"
    `include "axi_master_adapter.sv"
    `include "axi_master_agent.sv"
`endif //AXI_MASTER_INCLUDE__SV
