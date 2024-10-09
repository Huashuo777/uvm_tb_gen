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
//     File for dsel_loc_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_CONFIG__SV
`define DSEL_LOC_CONFIG__SV
class dsel_loc_config extends uvm_object;

    uvm_event_pool events;
    virtual dsel_loc_interface vif;
    `uvm_object_utils_begin(dsel_loc_config)
    `uvm_object_utils_end

    uvm_active_passive_enum is_active = UVM_ACTIVE;    

    extern function new(string name = "dsel_loc_config");
endclass : dsel_loc_config

function dsel_loc_config :: new(string name = "dsel_loc_config");
    super.new(name);
endfunction : new
`endif// DSEL_LOC_CONFIG__SV
