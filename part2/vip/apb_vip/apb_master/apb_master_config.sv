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
//     File for apb_master_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_CONFIG__SV
`define APB_MASTER_CONFIG__SV
class apb_master_config extends apb_base_config;
    bool use_reg_model = False;
    `uvm_object_utils_begin(apb_master_config)
         `uvm_field_enum(bool,use_reg_model,UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "apb_master_config");
endclass : apb_master_config

function apb_master_config :: new(string name = "apb_master_config");
    super.new(name);
endfunction : new
`endif// APB_MASTER_CONFIG__SV
