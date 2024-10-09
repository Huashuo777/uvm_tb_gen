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
//     File for dadd_pkg.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_PKG__SV
`define DADD_PKG__SV
`timescale 1ns/100ps
`include "dadd_loc_interface.sv"
package dadd_pkg;
    import uvm_pkg::*;
    import apb_env_pkg::*;
    import ral_top_pkg::*;
    `include "uvm_macros.svh"
    `include "dadd_loc_include.svh"
    `include "dadd_env_config.sv"
    `include "dadd_refmodel.sv"
    `include "dadd_scoreboard.sv"
    `include "dadd_cov_monitor.sv"
    `include "dadd_virtual_sequencer.sv"
    `include "dadd_environment.sv"
    `include "dadd_sequence.sv"
    `include "dadd_test.sv"
endpackage: dadd_pkg
`endif // DADD_PKG__SV
