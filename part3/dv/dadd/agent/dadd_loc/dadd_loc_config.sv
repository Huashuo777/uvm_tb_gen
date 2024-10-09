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
//     File for dadd_loc_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_CONFIG__SV
`define DADD_LOC_CONFIG__SV
class dadd_loc_config extends uvm_object;

    uvm_event_pool events;
    virtual dadd_loc_interface vif;
    `uvm_object_utils_begin(dadd_loc_config)
    `uvm_object_utils_end

    uvm_active_passive_enum is_active = UVM_ACTIVE;    

    extern function new(string name = "dadd_loc_config");
endclass : dadd_loc_config

function dadd_loc_config :: new(string name = "dadd_loc_config");
    super.new(name);
endfunction : new
`endif// DADD_LOC_CONFIG__SV
