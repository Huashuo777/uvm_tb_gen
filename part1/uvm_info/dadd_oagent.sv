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
//     File for dadd_oagent.sv                                                       
//----------------------------------------------------------------------------------
class dadd_oagent extends uvm_agent;
    `uvm_component_utils(dadd_oagent)
    virtual dadd_interface vif;

    uvm_analysis_port #(dadd_item) ap;
    dadd_omonitor   omon;

    extern function new(string name ="dadd_oagent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass: dadd_oagent

function dadd_oagent :: new(string name ="dadd_oagent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_oagent :: build_phase(uvm_phase phase);
    omon = dadd_omonitor :: type_id :: create("omon",this);
    omon.vif = vif;
endfunction : build_phase

function void dadd_oagent :: connect_phase(uvm_phase phase);
    ap = omon.ap;
endfunction : connect_phase
