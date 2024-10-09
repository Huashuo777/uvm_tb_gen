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
//     File for axi_reset_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_RESET_TEST__SV
`define AXI_RESET_TEST__SV
class axi_master_reset_sequence extends axi_master_sequence_base;
    `uvm_object_utils(axi_master_reset_sequence)
    extern         function new(string name = "axi_master_reset_sequence"); 
    extern virtual task body();
    extern virtual task assert_reset();
endclass : axi_master_reset_sequence

function axi_master_reset_sequence :: new(string name ="axi_master_reset_sequence");
    super.new(name);
endfunction : new

task axi_master_reset_sequence :: body();
    axi_master_item w_item,r_item;
    axi_data_t w_data,r_data;
    uvm_event trans_fns_evt = events.get($sformatf("%s_trans_fns_evt", cfg.get_name()));
    //write
    `uvm_create(w_item)
    w_item.direction = READ;
    for(int burst_num = 0;burst_num < 10;burst_num ++)
    begin
        w_item.id_arr[burst_num] = 2;
        w_item.size_arr[burst_num] = 2;
        w_item.burst_len_arr[burst_num] = $urandom_range(1,15);
        w_item.addr_arr[burst_num] = burst_num * 2**w_item.size_arr[burst_num]*(w_item.burst_len_arr[burst_num] + 1);
        for(int data_num = 0;data_num < w_item.burst_len_arr[burst_num]+1;data_num++)
        begin
            w_item.data_arr[burst_num][data_num] = $urandom();
            w_item.strb_arr[burst_num][data_num] ='hf;
        end
    end
    `uvm_send(w_item);
    assert_reset();
    `uvm_create(w_item)
    w_item.direction = WRITE;
    for(int burst_num = 0;burst_num < 10;burst_num ++)
    begin
        w_item.id_arr[burst_num] = 2;
        w_item.size_arr[burst_num] = 2;
        w_item.burst_len_arr[burst_num] = $urandom_range(1,15);
        w_item.addr_arr[burst_num] = burst_num * 2**w_item.size_arr[burst_num]*(w_item.burst_len_arr[burst_num] + 1);
        for(int data_num = 0;data_num < w_item.burst_len_arr[burst_num]+1;data_num++)
        begin
            w_item.data_arr[burst_num][data_num] = $urandom();
            w_item.strb_arr[burst_num][data_num] ='hf;
        end
    end
    `uvm_send(w_item);
endtask : body

task axi_master_reset_sequence :: assert_reset();
    #1000ns;
    uvm_hdl_force("top.rst_n",0);
    #2000ns;
    uvm_hdl_force("top.rst_n",1);
endtask : assert_reset

class axi_slave_reset_sequence extends axi_slave_sequence_base;
    `uvm_object_utils(axi_slave_reset_sequence)
    extern         function new(string name = "axi_slave_reset_sequence"); 
    extern virtual task body();
endclass : axi_slave_reset_sequence

function axi_slave_reset_sequence :: new(string name ="axi_slave_reset_sequence");
    super.new(name);
endfunction : new

task axi_slave_reset_sequence :: body();
    axi_slave_item item;
    forever 
    begin
        `uvm_do_with(item,{
            response == OKAY;
        });
    end
endtask : body

class axi_reset_virtual_sequence extends axi_virtual_sequence;
    `uvm_object_utils(axi_reset_virtual_sequence)
    extern         function new(string name = "axi_reset_virtual_sequence");
    extern virtual task body();
endclass : axi_reset_virtual_sequence

function axi_reset_virtual_sequence :: new(string name = "axi_reset_virtual_sequence");
    super.new(name);
endfunction : new

task axi_reset_virtual_sequence :: body();
    axi_master_reset_sequence mst_seq;
    axi_slave_reset_sequence slv_seq;
    mst_seq = axi_master_reset_sequence::type_id :: create("mst_seq");
    slv_seq = axi_slave_reset_sequence::type_id :: create("slv_seq");
    fork
        mst_seq.start(p_sequencer.mst_sqr[0]);
        slv_seq.start(p_sequencer.slv_sqr[0]);
    join_any
    disable fork;
endtask : body

class axi_reset_test extends axi_base_test;
    `uvm_component_utils(axi_reset_test)
    extern         function new(string name = "axi_reset_test", uvm_component parent = null);
    extern virtual task  run_phase(uvm_phase phase);
endclass : axi_reset_test

function axi_reset_test :: new(string name = "axi_reset_test", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

task axi_reset_test :: run_phase(uvm_phase phase);
    axi_reset_virtual_sequence vseq;
    vseq = axi_reset_virtual_sequence :: type_id:: create("vseq");
    phase.raise_objection(this);
    vseq.start(vsqr);
    #1000ns;
    phase.drop_objection(this);
endtask : run_phase


`endif //AXI_RESET_TEST__SV
