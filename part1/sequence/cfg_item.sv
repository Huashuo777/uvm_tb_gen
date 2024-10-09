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
//     File for cfg_item.sv                                                       
//----------------------------------------------------------------------------------
class cfg_item extends uvm_sequence_item;
     rand bit [31:0] cfg_info;
    `uvm_object_utils(cfg_item)
    constraint cfg_info_cst {
        cfg_info inside {32'h5a5a,32'ha5a5,1}; 
    }
    extern function new(string name ="cfg_item");
endclass: cfg_item

function cfg_item :: new(string name ="cfg_item");
    super.new(name);
endfunction: new
