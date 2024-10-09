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
//     File for dadd_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_TEST__SV
`define DADD_TEST__SV
class dadd_smoke_test extends bvm_test;
    `bvm_component_utils(dadd_smoke_test)
    dadd_environment env;
    extern function new(string name ="dadd_smoke_test",bvm_component parent = null);
    extern function void build_phase();
    extern task run_phase();
endclass: dadd_smoke_test

function dadd_smoke_test :: new(string name ="dadd_smoke_test",bvm_component parent = null);
    super.new(name,parent);
endfunction : new


function void dadd_smoke_test :: build_phase();
    super.build_phase();

    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase

task dadd_smoke_test :: run_phase();
    dadd_loc_sequence seq;
    super.run_phase();
    seq = new();
    raise_objection();
    seq.start(env.dadd_loc_iagt.sqr);
    #10000ns;
    drop_objection();

endtask : run_phase

`endif //DADD_TEST__SV
