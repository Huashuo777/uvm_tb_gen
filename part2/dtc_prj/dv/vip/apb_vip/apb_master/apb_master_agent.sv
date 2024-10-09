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
//     File for apb_master_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_AGENT__SV
`define APB_MASTER_AGENT__SV
typedef uvm_reg_predictor #(apb_master_item) apb_master_predictor;
class apb_master_agent extends uvm_component;
    `uvm_component_utils(apb_master_agent)
    virtual apb_master_interface vif;
    apb_master_config cfg;

    apb_master_driver drv;
    apb_master_monitor mon;
    apb_master_sequencer sqr;
    apb_master_cov_monitor cov_mon;
    apb_master_adapter adpt;
    apb_master_predictor pred;
    uvm_analysis_port #(apb_master_item) ap;

    extern         function new(string name = "apb_master_agent",uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : apb_master_agent

function apb_master_agent :: new(string name = "apb_master_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void apb_master_agent :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mon = apb_master_monitor :: type_id :: create("mon",this);
    mon.cfg = cfg;
    mon.vif = vif;

    if(cfg.is_active == UVM_ACTIVE) 
    begin
        sqr = apb_master_sequencer :: type_id :: create("sqr",this);
        drv = apb_master_driver :: type_id :: create("drv",this);
        sqr.cfg = cfg;
        drv.cfg = cfg;
        sqr.vif = vif;
        drv.vif = vif;
    end

    if(cfg.coverage_enable) 
    begin
        cov_mon = apb_master_cov_monitor :: type_id :: create("cov_mon",this);
        cov_mon.cfg = cfg;
    end

    if(cfg.use_reg_model)
    begin
        adpt = apb_master_adapter :: type_id :: create("adpt",this);
        adpt.cfg = cfg;

        pred = apb_master_predictor :: type_id :: create("pred",this);
        pred.adapter = adpt;
    end
endfunction : build_phase

function void apb_master_agent :: connect_phase(uvm_phase phase);
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

`endif //APB_MASTER_AGENT__SV
