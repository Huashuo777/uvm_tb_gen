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
//     File for dsel_virtual_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_VIRTUAL_SEQUENCER__SV
`define DSEL_VIRTUAL_SEQUENCER__SV
class dsel_virtual_sequencer extends uvm_virtual_sequencer;
    dsel_loc_sequencer loc_sqr;
    apb_virtual_sequencer apb_vsqr;
    axi_virtual_sequencer axi_vsqr;
    dsel_env_config cfg;
    virtual dsel_loc_interface vif;
    `uvm_component_utils(dsel_virtual_sequencer)

    extern function      new(string name, uvm_component parent);
endclass : dsel_virtual_sequencer

function dsel_virtual_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

`endif //DSEL_VIRTUAL_SEQUENCER__SV
