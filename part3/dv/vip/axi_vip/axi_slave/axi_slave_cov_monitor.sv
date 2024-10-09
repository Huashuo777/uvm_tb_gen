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
//     File for axi_slave_cov_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_COV_MONITOR__SV
`define AXI_SLAVE_COV_MONITOR__SV
`uvm_analysis_imp_decl(_axi_slave_cov_mon)
class axi_slave_cov_monitor extends uvm_component;
    axi_slave_config cfg;
    uvm_event_pool events;
    axi_slave_item cov_item;
    uvm_analysis_imp_axi_slave_cov_mon #(axi_slave_item,axi_slave_cov_monitor) imp;
    `uvm_component_utils(axi_slave_cov_monitor)

    covergroup axi_slave_cov;
        option.per_instance = 1;
        AXI_DATA: coverpoint  cov_item.c_data;
        AXI_ADDR: coverpoint  cov_item.c_addr;
    endgroup
    extern         function new(string name = "axi_slave_cov_monitor",uvm_component parent = null);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void write_axi_slave_cov_mon(axi_slave_item item);
endclass : axi_slave_cov_monitor

function axi_slave_cov_monitor :: new(string name = "axi_slave_cov_monitor",uvm_component parent = null);
    super.new(name,parent);
    axi_slave_cov = new();
    imp= new("imp",this);
endfunction : new

function void axi_slave_cov_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.events = cfg.events;
endfunction : connect_phase

function void axi_slave_cov_monitor :: write_axi_slave_cov_mon(axi_slave_item item);
    cov_item = new item;
    axi_slave_cov.sample();
endfunction : write_axi_slave_cov_mon
`endif //AXI_SLAVE_COV_MONITOR__SV
