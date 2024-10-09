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
//     File for dtc_pkg.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_PKG__SV
`define DTC_PKG__SV

`timescale 1ns/100ps

`include "dtc_loc_interface.sv"
package dtc_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import dadd_pkg::*;
    import dsel_pkg::*;
    import apb_env_pkg::*;
    import axi_env_pkg::*;
    import ral_top_pkg::*;
    `include "dtc_loc_include.svh"
    `include "dtc_env_config.sv"
    `include "dtc_virtual_sequencer.sv"
    `include "dtc_environment.sv"
    `include "dtc_sequence.sv"
    `include "dtc_test.sv"
endpackage: dtc_pkg
`endif // DTC_PKG__SV
