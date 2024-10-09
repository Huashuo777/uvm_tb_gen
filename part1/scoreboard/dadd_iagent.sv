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

    uvm_analysis_port #(dadd_item) ap;
    dadd_sequencer  sqr;
    dadd_driver     drv;
    dadd_imonitor   imon;

    extern function new(string name ="dadd_iagent", uvm_component parent);
endclass: dadd_iagent

function dadd_iagent :: new(string name ="dadd_iagent", uvm_component parent);
    super.new(name, parent);
    drv = new("drv",this);
    sqr = new("sqr",this);
    imon = new("imon",this);
    drv.seq_item_port.connect(sqr.seq_item_export);
    ap = imon.ap;
endfunction: new
