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
//     File for dadd_loc_base_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_BASE_SEQUENCE__SV
`define DADD_LOC_BASE_SEQUENCE__SV

class dadd_loc_base_sequence extends bvm_sequence;
    dadd_loc_item item;
    extern task body();
endclass : dadd_loc_base_sequence

task dadd_loc_base_sequence :: body();
    repeat(100) begin
        item = new();
        seq2sqr_box.put(item);
    end
endtask : body
    
`endif//DADD_LOC_BASE_SEQUENCE__SV
