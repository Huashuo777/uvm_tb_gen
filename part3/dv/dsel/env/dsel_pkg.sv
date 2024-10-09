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
//     File for dsel_pkg.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_PKG__SV
`define DSEL_PKG__SV

`timescale 1ns/100ps

`include "dsel_loc_interface.sv"
package dsel_pkg;
    import uvm_pkg::*;
    import apb_env_pkg::*;
    import axi_env_pkg::*;
    import ral_top_pkg::*;
    `include "uvm_macros.svh"
    `include "dsel_loc_include.svh"
    `include "dsel_env_config.sv"
    `include "dsel_refmodel.sv"
    `include "dsel_scoreboard.sv"
    `include "dsel_cov_monitor.sv"
    `include "dsel_virtual_sequencer.sv"
    `include "dsel_environment.sv"
    `include "dsel_sequence.sv"
    `include "dsel_test.sv"
endpackage: dsel_pkg
`endif // DSEL_PKG__SV
