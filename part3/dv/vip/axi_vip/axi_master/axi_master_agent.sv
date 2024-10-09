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
//     File for axi_master_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_AGENT__SV
`define AXI_MASTER_AGENT__SV
typedef uvm_reg_predictor #(axi_master_item) axi_master_predictor;
class axi_master_agent extends uvm_component;
    `uvm_component_utils(axi_master_agent)
    virtual axi_master_interface vif;
    axi_master_config cfg;

    axi_master_driver drv;
    axi_master_monitor mon;
    axi_master_sequencer sqr;
    axi_master_cov_monitor cov_mon;
    axi_master_adapter adpt;
    axi_master_predictor pred;
    uvm_analysis_port #(axi_master_item) ap;

    extern         function new(string name = "axi_master_agent",uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : axi_master_agent

function axi_master_agent :: new(string name = "axi_master_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void axi_master_agent :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mon = axi_master_monitor :: type_id :: create("mon",this);
    mon.cfg = cfg;
    mon.vif = vif;

    if(cfg.is_active == UVM_ACTIVE) 
    begin
        sqr = axi_master_sequencer :: type_id :: create("sqr",this);
        drv = axi_master_driver :: type_id :: create("drv",this);
        sqr.cfg = cfg;
        drv.cfg = cfg;
        sqr.vif = vif;
        drv.vif = vif;
    end

    if(cfg.coverage_enable) 
    begin
        cov_mon = axi_master_cov_monitor :: type_id :: create("cov_mon",this);
        cov_mon.cfg = cfg;
    end

    if(cfg.use_reg_model)
    begin
        adpt = axi_master_adapter :: type_id :: create("adpt",this);
        adpt.cfg = cfg;

        pred = axi_master_predictor :: type_id :: create("pred",this);
        pred.adapter = adpt;
    end
endfunction : build_phase

function void axi_master_agent :: connect_phase(uvm_phase phase);
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

    if(cfg.use_reg_model)
    begin
        mon.ap.connect(pred.bus_in);
    end
endfunction : connect_phase

`endif //AXI_MASTER_AGENT__SV
