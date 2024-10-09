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
class dadd_rand_test extends uvm_test;
    `uvm_component_utils(dadd_rand_test)
    dadd_iagent iagt;
    dadd_oagent oagt;
    dadd_rand_sequence seq;
    dadd_refmodel refmdl;
    dadd_scoreboard scb;
    uvm_tlm_analysis_fifo #(dadd_item) dadd_iagt_to_refmdl_fifo;
    uvm_tlm_analysis_fifo #(dadd_item) dadd_oagt_to_scb_fifo;
    uvm_tlm_analysis_fifo #(dadd_item) dadd_refmdl_to_scb_fifo;
    extern function new(string name ="dadd_rand_test",uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
endclass: dadd_rand_test

function dadd_rand_test :: new(string name ="dadd_rand_test",uvm_component parent = null);
    super.new(name,parent);
    iagt = new("iagt",this);
    oagt = new("oagt",this);
    refmdl = new("refmdl",this);
    scb = new("scb",this);
    seq = new("seq");
    dadd_iagt_to_refmdl_fifo = new("dadd_iagt_to_refmdl_fifo",this);
    dadd_oagt_to_scb_fifo = new("dadd_oagt_to_scb_fifo",this);
    dadd_refmdl_to_scb_fifo = new("dadd_refmdl_to_scb_fifo",this);
    iagt.ap.connect(dadd_iagt_to_refmdl_fifo.analysis_export);                                                                                                                                                          
    refmdl.port.connect(dadd_iagt_to_refmdl_fifo.blocking_get_export);

    oagt.ap.connect(dadd_oagt_to_scb_fifo.analysis_export);                                                                                                                                                          
    scb.act_port.connect(dadd_oagt_to_scb_fifo.blocking_get_export);

    refmdl.ap.connect(dadd_refmdl_to_scb_fifo.analysis_export);
    scb.exp_port.connect(dadd_refmdl_to_scb_fifo.blocking_get_export);
endfunction : new

task dadd_rand_test :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    uvm_top.print_topology();
    phase.raise_objection(this);
    #100ns;
    seq.start(iagt.sqr);
    phase.drop_objection(this);
endtask : main_phase
