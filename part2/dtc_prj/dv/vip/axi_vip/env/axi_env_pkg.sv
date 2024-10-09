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
//     File for axi_env_pkg.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_ENV_PKG__SV
`define AXI_ENV_PKG__SV
`include "axi_define.sv"
`include "axi_env_interface.sv"
package axi_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "axi_common_include.svh"
    `include "axi_master_include.svh"
    `include "axi_slave_include.svh"
    `include "axi_env_config.sv"
    `include "axi_virtual_sequencer.sv"
    `include "axi_virtual_sequence.sv"
    `include "axi_environment.sv"
endpackage : axi_env_pkg
`endif //AXI_ENV_PKG__SV
