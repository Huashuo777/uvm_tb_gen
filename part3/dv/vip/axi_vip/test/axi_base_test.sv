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
//     File for axi_base_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_BASE_TEST__SV
`define AXI_BASE_TEST__SV
import uvm_pkg::*;
`include "uvm_macros.svh"
import axi_env_pkg::*;

class axi_base_test extends uvm_test;
    virtual axi_env_interface vif;
    axi_environment env;
    axi_env_config cfg;
    axi_virtual_sequencer vsqr;

    `uvm_component_utils(axi_base_test)
    extern function new(string name = "axi_base_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass : axi_base_test

function axi_base_test :: new(string name = "axi_base_test",uvm_component parent = null);
    super.new(name, parent);
endfunction

function void axi_base_test :: build_phase(uvm_phase phase);
    cfg = new("cfg");
    cfg.events = new("events");

    if(!uvm_config_db#(virtual axi_env_interface)::get(null, get_full_name(), "vif", vif))
        `uvm_fatal("build_phase", "Cannot get axi_env_vif.")
    cfg.vif = vif;
    begin
        axi_master_config m_cfg = new("e0_m0");
        m_cfg.index = 0;
        cfg.set_config(m_cfg);
    end
    begin
        axi_slave_config  s_cfg = new("e0_s0");
        s_cfg.index = 0;
        cfg.set_config(s_cfg);
    end

    env = axi_environment::type_id::create("env", this);
    env.cfg = cfg;

endfunction : build_phase

function void axi_base_test :: connect_phase(uvm_phase phase);
    vsqr = env.vsqr;

endfunction

`endif //AXI_BASE_TEST__SV
