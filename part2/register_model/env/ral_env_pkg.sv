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
//     File for ral_env_pkg.sv                                                       
//----------------------------------------------------------------------------------
`ifndef RAL_ENV_PKG
`define RAL_ENV_PKG
`include "local_bus_interface.sv"
package ral_env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "local_bus_include.svh"
    `include "reg_model.sv"
    `include "ral_environment.sv"
    `include "ral_sequence.sv"
    `include "ral_test.sv"
endpackage : ral_env_pkg
`endif //RAL_ENV_PKG
