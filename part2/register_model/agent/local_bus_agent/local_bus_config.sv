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
//     File for local_bus_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_CONFIG
`define LOCAL_BUS_CONFIG
class local_bus_config extends uvm_object;

    forecast_mode_e forecast_mode; 
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    `uvm_object_utils_begin(local_bus_config)
        `uvm_field_enum(forecast_mode_e,forecast_mode,UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "local_bus_config");
        super.new(name);
    endfunction

endclass : local_bus_config
`endif //LOCAL_BUS_CONFIG
