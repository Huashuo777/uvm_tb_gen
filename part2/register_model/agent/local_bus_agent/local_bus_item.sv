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
//     File for local_bus_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_ITEM
`define LOCAL_BUS_ITEM
class local_bus_item extends uvm_sequence_item;
    rand local_bus_addr_t addr;
    rand local_bus_data_t data;
    rand local_bus_direction_e direction;
    
    `uvm_object_utils_begin(local_bus_item)
        `uvm_field_int  (addr       ,UVM_ALL_ON)
        `uvm_field_int  (data       ,UVM_ALL_ON)
        `uvm_field_enum (local_bus_direction_e,direction  ,UVM_ALL_ON)
    `uvm_object_utils_end
    extern function new(string name = "local_bus_item");
endclass : local_bus_item

function local_bus_item :: new(string name = "local_bus_item");
    super.new(name);
endfunction : new
`endif //LOCAL_BUS_ITEM
