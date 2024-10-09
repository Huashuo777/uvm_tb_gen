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
//     File for apb_base_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_BASE_ITEM__SV
`define APB_BASE_ITEM__SV
class apb_base_item extends uvm_sequence_item;
    rand apb_addr_t         addr;
    rand apb_data_t         data;
    rand apb_direction_e    direction;
    rand apb_response_e     response;
    
    `uvm_object_utils_begin(apb_base_item)
        `uvm_field_int  (addr       ,UVM_ALL_ON)
        `uvm_field_int  (data       ,UVM_ALL_ON)
        `uvm_field_enum (apb_direction_e,direction  ,UVM_ALL_ON)
        `uvm_field_enum (apb_response_e ,response   ,UVM_ALL_ON)
    `uvm_object_utils_end
    extern function new(string name = "apb_base_item");
endclass

function apb_base_item :: new(string name = "apb_base_item");
    super.new(name);
endfunction

`endif//APB_BASE_ITEM__SV
