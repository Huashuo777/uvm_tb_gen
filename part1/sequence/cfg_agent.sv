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
//     File for cfg_agent.sv                                                       
//----------------------------------------------------------------------------------
class cfg_agent extends uvm_agent;
    `uvm_component_utils(cfg_agent)
    uvm_analysis_port #(cfg_item) layer_ap;

    cfg_sequencer  sqr;
    cfg_driver     drv;
    cfg_monitor   mon;

    extern function new(string name ="cfg_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass: cfg_agent

function cfg_agent :: new(string name ="cfg_agent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void cfg_agent :: build_phase(uvm_phase phase);
    drv = cfg_driver :: type_id :: create("drv",this);
    sqr = cfg_sequencer :: type_id :: create("sqr",this);
    mon = cfg_monitor :: type_id :: create("mon",this);
endfunction : build_phase

function void cfg_agent :: connect_phase(uvm_phase phase);
    layer_ap = sqr.ap;
endfunction : connect_phase
