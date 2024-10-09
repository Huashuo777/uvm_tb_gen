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
//     File for dadd_loc_sequencer.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_SEQUENCER__SV
`define DADD_LOC_SEQUENCER__SV
class dadd_loc_sequencer extends bvm_sequencer;
    virtual dadd_loc_interface vif;
    `bvm_component_utils(dadd_loc_sequencer)
    extern function new(string name ="dadd_loc_sequencer", bvm_component parent);
endclass: dadd_loc_sequencer

function dadd_loc_sequencer :: new(string name ="dadd_loc_sequencer", bvm_component parent);
    super.new(name, parent);
endfunction: new
`endif // DADD_LOC_SEQUENCER__SV
