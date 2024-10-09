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
//     File for dadd_cov_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_COV_MON__SV
`define DADD_COV_MON__SV
`uvm_analysis_imp_decl(_dadd_loc)
class dadd_cov_mon extends uvm_component;
    uvm_analysis_imp_dadd_loc#(dadd_loc_item, dadd_cov_mon) dadd_loc_export;
    dadd_loc_item cov_item;
    dadd_env_config cfg;
    `uvm_component_utils(dadd_cov_mon)

    extern         function new(string name, uvm_component parent = null);
    extern virtual function void write_dadd_loc(dadd_loc_item item);
    covergroup dadd_cov;
        option.per_instance = 1;
        DATA: coverpoint  cov_item.data;
        ADDR: coverpoint  cov_item.addr;
    endgroup
endclass: dadd_cov_mon

function dadd_cov_mon :: new(string name, uvm_component parent = null);
    super.new(name, parent);
    dadd_cov = new();
    dadd_loc_export = new("dadd_loc_imp", this);
endfunction: new

function void dadd_cov_mon :: write_dadd_loc(dadd_loc_item item);
    cov_item = new item;
    dadd_cov.sample();
endfunction: write_dadd_loc

`endif // DADD_COV_MON__SV
