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
//     File for dadd_loc_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_ITEM__SV
`define DADD_LOC_ITEM__SV
class dadd_loc_item extends uvm_sequence_item;

    rand dadd_loc_direction_e    direction;
    rand bit             data_en;
    rand dadd_loc_data_t data;
    rand dadd_loc_addr_t addr;


    `uvm_object_utils_begin(dadd_loc_item)
        `uvm_field_int(data,UVM_ALL_ON)
        `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name ="dadd_loc_item");
endclass: dadd_loc_item

function dadd_loc_item :: new(string name ="dadd_loc_item");
    super.new(name);
endfunction: new

`endif // DADD_LOC_ITEM__SV
