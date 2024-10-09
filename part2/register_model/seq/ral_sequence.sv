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
//     File for ral_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef RAL_SEQUENCE
`define RAL_SEQUENCE

class ral_sequence extends uvm_sequence;
    `uvm_object_utils(ral_sequence)
    reg_model rm;
    extern         function new(string name = "ral_sequence");
    extern virtual task body();
endclass : ral_sequence

function ral_sequence :: new(string name = "ral_sequence");
    super.new(name);
endfunction : new

task ral_sequence :: body();
    ral_sequence seq;
    uvm_status_e status;
    uvm_reg_data_t data;
    seq = ral_sequence::type_id :: create("seq");
    `uvm_info("ral_sequence","Staring ral_sequence...",UVM_LOW);
    //rm.version_info.write(status,32'h2234);
    rm.version_info.set(32'h1233);
    //data = rm.version_info.version.get();
    //$display("The data = %h",data);
    //#1000ns;
    rm.update(status,UVM_BACKDOOR,.parent(this));
    rm.version_info.read(status,data);
    //data = rm.version_info.version.get();
    $display("The data = %h",data);
endtask : body

`endif //RAL_SEQUENCE
