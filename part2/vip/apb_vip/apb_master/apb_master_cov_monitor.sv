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
//     File for apb_master_cov_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_COV_MONITOR__SV
`define APB_MASTER_COV_MONITOR__SV
`uvm_analysis_imp_decl(_apb_master_cov_mon)
class apb_master_cov_monitor extends uvm_component;
    apb_master_config cfg;
    uvm_event_pool events;
    apb_master_item cov_item;
    uvm_analysis_imp_apb_master_cov_mon #(apb_master_item,apb_master_cov_monitor) imp;
    `uvm_component_utils(apb_master_cov_monitor)

    covergroup apb_master_cov;
        option.per_instance = 1;
        APB_DATA: coverpoint  cov_item.data;
        APB_ADDR: coverpoint  cov_item.addr;
    endgroup
    extern         function new(string name = "apb_master_cov_monitor",uvm_component parent = null);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void write_apb_master_cov_mon(apb_master_item item);
endclass : apb_master_cov_monitor

function apb_master_cov_monitor :: new(string name = "apb_master_cov_monitor",uvm_component parent = null);
    super.new(name,parent);
    apb_master_cov = new();
    imp= new("imp",this);
endfunction : new

function void apb_master_cov_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase

function void apb_master_cov_monitor :: write_apb_master_cov_mon(apb_master_item item);
    cov_item = new item;
    apb_master_cov.sample();
endfunction : write_apb_master_cov_mon
`endif //APB_MASTER_COV_MONITOR__SV
