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
//     File for apb_base_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_BASE_CONFIG__SV
`define APB_BASE_CONFIG__SV
class apb_base_config extends uvm_object;
    uvm_event_pool events;

    int index = -1;
    real clk_period = 10.0;
    bool coverage_enable = False;
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    `uvm_object_utils_begin(apb_base_config)
        `uvm_field_enum(bool,coverage_enable,UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "apb_base_config");
        super.new(name);
    endfunction

endclass : apb_base_config
`endif //APB_BASE_CONFIG__SV
