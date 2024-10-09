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
//     File for apb_master_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_ITEM__SV
`define APB_MASTER_ITEM__SV
class apb_master_item extends apb_base_item;
    
    `uvm_object_utils_begin(apb_master_item)
    `uvm_object_utils_end
    extern function new(string name = "apb_master_item");
endclass : apb_master_item

function apb_master_item :: new(string name = "apb_master_item");
    super.new(name);
endfunction : new
`endif //APB_MASTER_ITEM__SV
