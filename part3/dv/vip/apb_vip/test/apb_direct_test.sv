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
//     File for apb_direct_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_DIRECT_TEST__SV
`define APB_DIRECT_TEST__SV
class apb_master_direct_sequence extends apb_master_sequence_base;
    `uvm_object_utils(apb_master_direct_sequence)
    extern         function new(string name = "apb_master_direct_sequence"); 
    extern virtual task body();
endclass : apb_master_direct_sequence

function apb_master_direct_sequence :: new(string name ="apb_master_direct_sequence");
    super.new(name);
endfunction : new

task apb_master_direct_sequence :: body();
    apb_master_item w_item,r_item;
    apb_data_t w_data,r_data;
    repeat(10)
    begin
        //write data
        `uvm_do_with(w_item ,{
            direction == WRITE;
            addr      == 32'h1000;
        });
        w_data = w_item.data; 
        //read data
        `uvm_do_with(r_item,{
            direction == READ;
            addr      == 32'h1000;
        });
        r_data = r_item.data;
        if(r_data !== w_data)
        begin
            `uvm_error("apb_master_direct_sequence",$sformatf("Error,the write data is %h,read data is %h",w_data,r_data));
        end
        else 
        begin
            `uvm_info("apb_master_direct_sequence",$sformatf("Compare pass"),UVM_LOW);
        end
    end
endtask : body

class apb_slave_direct_sequence extends apb_slave_sequence_base;
    `uvm_object_utils(apb_slave_direct_sequence)
    extern         function new(string name = "apb_slave_direct_sequence"); 
    extern virtual task body();
endclass : apb_slave_direct_sequence

function apb_slave_direct_sequence :: new(string name ="apb_slave_direct_sequence");
    super.new(name);
endfunction : new

task apb_slave_direct_sequence :: body();
    apb_slave_item item;
    forever 
    begin
        `uvm_do_with(item,{
            response == OKAY;
        });
    end
endtask : body

class apb_direct_virtual_sequence extends apb_virtual_sequence;
    `uvm_object_utils(apb_direct_virtual_sequence)
    extern         function new(string name = "apb_direct_virtual_sequence");
    extern virtual task body();
endclass : apb_direct_virtual_sequence

function apb_direct_virtual_sequence :: new(string name = "apb_direct_virtual_sequence");
    super.new(name);
endfunction : new

task apb_direct_virtual_sequence :: body();
    apb_master_direct_sequence mst_seq;
    apb_slave_direct_sequence slv_seq;
    mst_seq = apb_master_direct_sequence::type_id :: create("mst_seq");
    slv_seq = apb_slave_direct_sequence::type_id :: create("slv_seq");
    fork
        mst_seq.start(p_sequencer.mst_sqr[0]);
        slv_seq.start(p_sequencer.slv_sqr[0]);
    join_any
endtask : body

class apb_direct_test extends apb_base_test;
    `uvm_component_utils(apb_direct_test)
    extern         function new(string name = "apb_direct_test", uvm_component parent = null);
    extern  virtual task  run_phase(uvm_phase phase);
endclass : apb_direct_test

function apb_direct_test :: new(string name = "apb_direct_test", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

task apb_direct_test :: run_phase(uvm_phase phase);
    apb_direct_virtual_sequence vseq;
    vseq = apb_direct_virtual_sequence :: type_id:: create("vseq");
    phase.raise_objection(this);
    vseq .start(vsqr);
    #1000ns;
    phase.drop_objection(this);
endtask : run_phase

`endif //APB_DIRECT_TEST__SV
