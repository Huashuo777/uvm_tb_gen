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
class dadd_loc_item extends bvm_sequence_item;

    rand bit        data_en;
    rand bit [31:0] data;
    rand bit [31:0] addr;
endclass: dadd_loc_item

`endif // DADD_LOC_ITEM__SV
