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
//     File for dadd_iagent.sv                                                       
//----------------------------------------------------------------------------------
class dadd_iagent extends uvm_agent;
    `uvm_component_utils(dadd_iagent)
    uvm_blocking_get_port #(cfg_item) layer_port;

    uvm_analysis_port #(dadd_item) ap;
    dadd_sequencer  sqr;
    dadd_driver     drv;
    dadd_imonitor   imon;

    extern function new(string name ="dadd_iagent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass: dadd_iagent

function dadd_iagent :: new(string name ="dadd_iagent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_iagent :: build_phase(uvm_phase phase);
    drv = dadd_driver :: type_id :: create("drv",this);
    sqr = dadd_sequencer :: type_id :: create("sqr",this);
    imon = dadd_imonitor :: type_id :: create("imon",this);
    layer_port = new("layer_port",this);
endfunction : build_phase

function void dadd_iagent :: connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    ap = imon.ap;
    sqr.port = layer_port;
endfunction : connect_phase
