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
//     File for cfg_driver.sv                                                       
//----------------------------------------------------------------------------------
class cfg_driver extends uvm_driver #(cfg_item);
    `uvm_component_utils(cfg_driver)
    extern function new(string name ="cfg_driver", uvm_component parent = null);
endclass: cfg_driver

function cfg_driver :: new(string name ="cfg_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction : new
