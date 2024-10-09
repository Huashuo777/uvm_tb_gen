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
//     File for axi_slave_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_AGENT__SV
`define AXI_SLAVE_AGENT__SV
class axi_slave_agent extends uvm_component;
    `uvm_component_utils(axi_slave_agent)
    virtual axi_slave_interface vif;
    axi_slave_config cfg;

    axi_slave_driver drv;
    axi_slave_monitor mon;
    axi_slave_sequencer sqr;
    axi_slave_cov_monitor cov_mon;
    uvm_analysis_port #(axi_slave_item) ap;

    extern         function new(string name = "axi_slave_agent",uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : axi_slave_agent

function axi_slave_agent :: new(string name = "axi_slave_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void axi_slave_agent :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mon = axi_slave_monitor :: type_id :: create("mon",this);
    mon.cfg = cfg;
    mon.vif = vif;

    if(cfg.is_active == UVM_ACTIVE) 
    begin
        sqr = axi_slave_sequencer :: type_id :: create("sqr",this);
        drv = axi_slave_driver :: type_id :: create("drv",this);
        sqr.cfg = cfg;
        drv.cfg = cfg;
        sqr.vif = vif;
        drv.vif = vif;
    end

    if(cfg.coverage_enable) 
    begin
        cov_mon = axi_slave_cov_monitor :: type_id :: create("cov_mon",this);
        cov_mon.cfg = cfg;
    end

endfunction : build_phase

function void axi_slave_agent :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ap = mon.ap;

    if(cfg.is_active == UVM_ACTIVE) 
    begin
        drv.seq_item_port.connect(sqr.seq_item_export);
    end
    if(cfg.coverage_enable)
    begin
        mon.ap .connect(cov_mon.imp);
    end

endfunction : connect_phase

`endif //AXI_SLAVE_AGENT__SV
