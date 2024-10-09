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
//     File for axi_master_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_ITEM__SV
`define AXI_MASTER_ITEM__SV
class axi_master_item extends axi_base_item;

    `uvm_object_utils_begin(axi_master_item)
    `uvm_object_utils_end
    extern function new(string name = "axi_master_item");
endclass : axi_master_item

function axi_master_item :: new(string name = "axi_master_item");
    super.new(name);
endfunction : new
`endif //AXI_MASTER_ITEM__SV
