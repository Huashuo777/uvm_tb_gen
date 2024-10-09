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
//     File for apb_slave_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_CONFIG__SV
`define APB_SLAVE_CONFIG__SV
class apb_slave_config extends apb_base_config;
    `uvm_object_utils_begin(apb_slave_config)
    `uvm_object_utils_end
    extern function new(string name = "apb_slave_config");
endclass : apb_slave_config

function apb_slave_config :: new(string name = "apb_slave_config");
    super.new(name);
endfunction : new
`endif //APB_SLAVE_CONFIG__SV
