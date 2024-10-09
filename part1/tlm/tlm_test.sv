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
//     File for tlm_test.sv                                                       
//----------------------------------------------------------------------------------
import uvm_pkg::*;
`include "uvm_macros.svh"
class tlm_item;
    bit [31:0] addr;
    bit [31:0] data;
endclass : tlm_item

class tlm_producer extends uvm_component;

    uvm_analysis_port#(tlm_item) ap_a;
    uvm_analysis_port#(tlm_item) ap_b;
    tlm_item item_a;
    tlm_item item_b;

    function new(string name = "tlm_producer",uvm_component parent = null);
        super.new(name,parent);
        ap_a = new("ap_a",this);
        ap_b = new("ap_b",this);
        item_a = new();
        item_b = new();
    endfunction : new

    task main_phase(uvm_phase phase);
        super.main_phase(phase);
        item_a.addr = 32'h1234;
        item_a.data = 31'h4321;
        item_b.addr = 32'h5678;
        item_b.data = 31'h8765;
        ap_a.write(item_a);
        ap_b.write(item_b);
    endtask : main_phase

endclass : tlm_producer

`uvm_analysis_imp_decl(_consumer)
class tlm_consumer extends uvm_component;
    tlm_item item;
    uvm_analysis_imp_consumer #(tlm_item,tlm_consumer) port_a;
    uvm_blocking_get_port#(tlm_item) port_b;

    function new(string name = "tlm_producer",uvm_component parent = null);
        super.new(name,parent);
        port_a = new("port_a",this);
        port_b = new("port_b",this);
    endfunction : new

    task main_phase(uvm_phase phase);
        super.main_phase(phase);
        port_b.get(item);
        `uvm_info(this.get_name(),$sformatf("port b trans addr = %h,data = %h",item.addr,item.data),UVM_LOW);
    endtask : main_phase

    task write_consumer(tlm_item item);
        tlm_item item_tmp;
        item_tmp = new item;
        `uvm_info(this.get_name(),$sformatf("port a trans addr = %h,data = %h",item_tmp.addr,item_tmp.data),UVM_LOW);
    endtask : write_consumer

endclass : tlm_consumer

class tlm_env extends uvm_env;
    tlm_producer tlm_pdr;
    tlm_consumer tlm_csr;
    uvm_tlm_analysis_fifo #(tlm_item) producer_to_consumer_fifo;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        tlm_pdr = new("tlm_pdr",this);
        tlm_csr = new("tlm_csr",this);
        producer_to_consumer_fifo = new("producer_to_consumer_fifo",this);
        tlm_pdr.ap_a.connect(tlm_csr.port_a);
        tlm_pdr.ap_b.connect(producer_to_consumer_fifo.analysis_export);
        tlm_csr.port_b.connect(producer_to_consumer_fifo.blocking_get_export);
    endfunction : new

    task main_phase(uvm_phase phase);
        super.main_phase(phase);
    endtask : main_phase
endclass : tlm_env

class tlm_test extends uvm_test;
    `uvm_component_utils(tlm_test)
    tlm_env env; 

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        env = new("env",this);
    endfunction : new

    task main_phase(uvm_phase phase);
        super.main_phase(phase);
        phase.raise_objection(this);
        #1000ns;
        phase.drop_objection(this);
    endtask : main_phase

endclass : tlm_test

module tb();
    initial 
    begin
        run_test("tlm_test");
    end
endmodule : tb
