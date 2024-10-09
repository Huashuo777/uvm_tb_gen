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
//     File for axi_direct_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_DIRECT_TEST__SV
`define AXI_DIRECT_TEST__SV
class axi_master_direct_sequence extends axi_master_sequence_base;
    `uvm_object_utils(axi_master_direct_sequence)
    extern         function new(string name = "axi_master_direct_sequence"); 
    extern virtual task body();
endclass : axi_master_direct_sequence

function axi_master_direct_sequence :: new(string name ="axi_master_direct_sequence");
    super.new(name);
endfunction : new

task axi_master_direct_sequence :: body();
    axi_master_item w_item,r_item;
    axi_data_t w_data,r_data;
    uvm_event trans_fns_evt = events.get($sformatf("%s_trans_fns_evt", cfg.get_name()));
    repeat(2)
    begin
        //write data
        `uvm_create(w_item);
        w_item.randomize with{
            addr_start == 4; 
            direction == WRITE;
            trans_num == 20;
        };
        `uvm_send(w_item);
    end
    trans_fns_evt.wait_trigger();
    repeat(2)
    begin
        //read data
        `uvm_create(w_item);
        w_item.randomize with{
            addr_start == 4; 
            direction == READ;
            trans_num == 20;
        };
        `uvm_send(w_item);
    end
    trans_fns_evt.wait_trigger();
    repeat(2)
    begin
        //write data
        `uvm_create(w_item);
        w_item.randomize with{
            addr_start == 4; 
            direction == WRITE;
            trans_num == 20;
        };
        `uvm_send(w_item);
    end
    #10000ns;
endtask : body


class axi_slave_direct_sequence extends axi_slave_sequence_base;
    `uvm_object_utils(axi_slave_direct_sequence)
    extern         function new(string name = "axi_slave_direct_sequence"); 
    extern virtual task body();
endclass : axi_slave_direct_sequence

function axi_slave_direct_sequence :: new(string name ="axi_slave_direct_sequence");
    super.new(name);
endfunction : new

task axi_slave_direct_sequence :: body();
    axi_slave_item item;
    forever 
    begin
        `uvm_do_with(item,{
            response == OKAY; 
        });
    end
endtask : body

class axi_direct_virtual_sequence extends axi_virtual_sequence;
    `uvm_object_utils(axi_direct_virtual_sequence)
    extern         function new(string name = "axi_direct_virtual_sequence");
    extern virtual task body();
endclass : axi_direct_virtual_sequence

function axi_direct_virtual_sequence :: new(string name = "axi_direct_virtual_sequence");
    super.new(name);
endfunction : new

task axi_direct_virtual_sequence :: body();
    axi_master_direct_sequence mst_seq;
    axi_slave_direct_sequence slv_seq;
    mst_seq = axi_master_direct_sequence::type_id :: create("mst_seq");
    slv_seq = axi_slave_direct_sequence::type_id :: create("slv_seq");
    fork
        mst_seq.start(p_sequencer.mst_sqr[0]);
        slv_seq.start(p_sequencer.slv_sqr[0]);
    join_any
endtask : body

class axi_direct_test extends axi_base_test;
    `uvm_component_utils(axi_direct_test)
    extern         function new(string name = "axi_direct_test", uvm_component parent = null);
    extern  virtual task  run_phase(uvm_phase phase);
endclass : axi_direct_test

function axi_direct_test :: new(string name = "axi_direct_test", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

task axi_direct_test :: run_phase(uvm_phase phase);
    axi_direct_virtual_sequence vseq;
    vseq = axi_direct_virtual_sequence :: type_id:: create("vseq");
    phase.raise_objection(this);
    vseq .start(vsqr);
    #10000ns;
    phase.drop_objection(this);
endtask : run_phase

`endif //AXI_DIRECT_TEST__SV
