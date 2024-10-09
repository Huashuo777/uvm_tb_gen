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
//     File for dtc_loc_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_CONFIG__SV
`define DTC_LOC_CONFIG__SV
class dtc_loc_config extends uvm_object;

    virtual dtc_loc_interface vif;
    uvm_event_pool events;
    `uvm_object_utils_begin(dtc_loc_config)
    `uvm_object_utils_end

    uvm_active_passive_enum is_active = UVM_ACTIVE;    

    extern function new(string name = "dtc_loc_config");
endclass : dtc_loc_config

function dtc_loc_config :: new(string name = "dtc_loc_config");
    super.new(name);
endfunction : new
`endif// DTC_LOC_CONFIG__SV
