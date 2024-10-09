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
//     File for dtc_virtual_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_VIRTUAL_SEQUENCER__SV
`define DTC_VIRTUAL_SEQUENCER__SV
class dtc_virtual_sequencer extends uvm_virtual_sequencer;
    `uvm_component_utils(dtc_virtual_sequencer)
    apb_virtual_sequencer apb_vsqr;
    axi_virtual_sequencer axi_vsqr;
    dtc_loc_sequencer loc_sqr;
    virtual dtc_loc_interface vif;
    dtc_env_config cfg;

    extern function      new(string name, uvm_component parent);
endclass : dtc_virtual_sequencer

function dtc_virtual_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

`endif //DTC_VIRTUAL_SEQUENCER__SV
