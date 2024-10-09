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
//     File for dadd_sequence.sv                                                       
//----------------------------------------------------------------------------------
class dadd_rand_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_rand_sequence)
    dadd_item item;
    function new(string name = "dadd_rand_sequence");
        super.new(name);
    endfunction : new
    
    task body();
        repeat(100) begin
            item = new();
            item.randomize();
            `uvm_send(item)
        end
    endtask : body
endclass : dadd_rand_sequence
