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
//     File for dsel_cov_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_COV_MON__SV
`define DSEL_COV_MON__SV
`uvm_analysis_imp_decl(_dsel_loc)
class dsel_cov_mon extends uvm_component;
    dsel_loc_item cov_tr;
    dsel_env_config cfg;
    uvm_event_pool events;
    uvm_analysis_imp_dsel_loc#(dsel_loc_item, dsel_cov_mon) dsel_loc_export;
    `uvm_component_utils(dsel_cov_mon)
    extern         function new(string name, uvm_component parent = null);
    extern virtual function void write_dsel_loc(dsel_loc_item tr);
    extern virtual function void  connect_phase(uvm_phase phase);
    covergroup dsel_cov;
        option.per_instance = 1;
        DATA: coverpoint  cov_tr.c_data;
        ADDR: coverpoint  cov_tr.c_addr;
    endgroup

endclass: dsel_cov_mon

function dsel_cov_mon :: new(string name, uvm_component parent = null);
    super.new(name, parent);
    dsel_cov = new();

    dsel_loc_export = new("dsel_loc_imp", this);
endfunction: new

function void  dsel_cov_mon :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

function void dsel_cov_mon :: write_dsel_loc(dsel_loc_item tr);

    cov_tr = new tr;
    dsel_cov.sample();

endfunction: write_dsel_loc
`endif // DSEL_COV_MON__SV
