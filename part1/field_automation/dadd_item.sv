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
//     File for dadd_item.sv                                                       
//----------------------------------------------------------------------------------
class dadd_item extends uvm_sequence_item;

    `uvm_object_utils_begin(dadd_item)
        `uvm_field_int(data,UVM_ALL_ON)
        `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_object_utils_end

    rand bit        data_en;
    rand bit [31:0] data;
    rand bit [31:0] addr;
    extern function new(string name ="dadd_item");
endclass: dadd_item

function dadd_item :: new(string name ="dadd_item");
    super.new(name);
endfunction: new
