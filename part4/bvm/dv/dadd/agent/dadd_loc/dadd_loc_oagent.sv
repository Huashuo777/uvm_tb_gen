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
//     File for dadd_loc_oagent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_OAGENT__SV
`define DADD_LOC_OAGENT__SV
class dadd_loc_oagent extends bvm_agent;
    virtual dadd_loc_interface vif;
    dadd_loc_omonitor   mon;

    `bvm_component_utils(dadd_loc_oagent)
    extern function new(string name ="dadd_loc_oagent", bvm_component parent);
    extern function void build_phase();
endclass: dadd_loc_oagent

function dadd_loc_oagent :: new(string name ="dadd_loc_oagent", bvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_loc_oagent :: build_phase();
    super.build_phase();

    mon = dadd_loc_omonitor::type_id::create("mon", this);
    mon.vif = this.vif;

endfunction: build_phase

`endif // DADD_LOC_OAGENT__SV
