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
//     File for dadd_loc_iagent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_IAGENT__SV
`define DADD_LOC_IAGENT__SV

class dadd_loc_iagent extends bvm_agent;
    virtual dadd_loc_interface vif;
    dadd_loc_sequencer  sqr;
    dadd_loc_driver     drv;
    dadd_loc_imonitor   mon;

    `bvm_component_utils(dadd_loc_iagent)
    extern function new(string name ="dadd_loc_iagent", bvm_component parent);
    extern function void build_phase();
endclass: dadd_loc_iagent

function dadd_loc_iagent :: new(string name ="dadd_loc_iagent", bvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_loc_iagent :: build_phase();
    super.build_phase();


    sqr = dadd_loc_sequencer::type_id::create("sqr", this);
    drv = dadd_loc_driver::type_id::create("drv", this);
    mon = dadd_loc_imonitor::type_id::create("mon", this);
    drv.vif = this.vif;
    mon.vif = this.vif;

endfunction: build_phase


`endif // DADD_LOC_IAGENT__SV
