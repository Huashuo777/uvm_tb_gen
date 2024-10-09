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
//     File for apb_reset_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_RESET_TEST__SV
`define APB_RESET_TEST__SV
class apb_master_reset_sequence extends apb_master_sequence_base;
    `uvm_object_utils(apb_master_reset_sequence)
    extern         function new(string name = "apb_master_reset_sequence"); 
    extern virtual task body();
    extern virtual task assert_reset();
endclass : apb_master_reset_sequence

function apb_master_reset_sequence :: new(string name ="apb_master_reset_sequence");
    super.new(name);
endfunction : new

task apb_master_reset_sequence :: body();
    apb_master_item w_item,r_item;
    apb_data_t w_data,r_data;
    //write data
    repeat(5)
    begin
        `uvm_do_with(w_item,{
            direction == WRITE;
            addr      == 32'h1000;
        });
    end
    begin
        assert_reset();
    end
    `uvm_do_with(w_item,{
        direction == WRITE;
        addr      == 32'h1000;
    });
endtask : body

task apb_master_reset_sequence :: assert_reset();
    #32ns;
    uvm_hdl_force("top.rst_n",0);
    #200ns;
    uvm_hdl_force("top.rst_n",1);
endtask : assert_reset

class apb_slave_reset_sequence extends apb_slave_sequence_base;
    `uvm_object_utils(apb_slave_reset_sequence)
    extern         function new(string name = "apb_slave_reset_sequence"); 
    extern virtual task body();
endclass : apb_slave_reset_sequence

function apb_slave_reset_sequence :: new(string name ="apb_slave_reset_sequence");
    super.new(name);
endfunction : new

task apb_slave_reset_sequence :: body();
    apb_slave_item item;
    forever 
    begin
        `uvm_do_with(item,{
            response == OKAY;
        });
    end
endtask : body

class apb_reset_virtual_sequence extends apb_virtual_sequence;
    `uvm_object_utils(apb_reset_virtual_sequence)
    extern         function new(string name = "apb_reset_virtual_sequence");
    extern virtual task body();
endclass : apb_reset_virtual_sequence

function apb_reset_virtual_sequence :: new(string name = "apb_reset_virtual_sequence");
    super.new(name);
endfunction : new

task apb_reset_virtual_sequence :: body();
    apb_master_reset_sequence mst_seq;
    apb_slave_reset_sequence slv_seq;
    mst_seq = apb_master_reset_sequence::type_id :: create("mst_seq");
    slv_seq = apb_slave_reset_sequence::type_id :: create("slv_seq");
    fork
        mst_seq.start(p_sequencer.mst_sqr[0]);
        slv_seq.start(p_sequencer.slv_sqr[0]);
    join_any
    disable fork;
endtask : body

class apb_reset_test extends apb_base_test;
    `uvm_component_utils(apb_reset_test)
    extern         function new(string name = "apb_reset_test", uvm_component parent = null);
    extern virtual task  run_phase(uvm_phase phase);
endclass : apb_reset_test

function apb_reset_test :: new(string name = "apb_reset_test", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

task apb_reset_test :: run_phase(uvm_phase phase);
    apb_reset_virtual_sequence vseq;
    vseq = apb_reset_virtual_sequence :: type_id:: create("vseq");
    phase.raise_objection(this);
    vseq.start(vsqr);
    #1000ns;
    phase.drop_objection(this);
endtask : run_phase

`endif //APB_RESET_TEST__SV
