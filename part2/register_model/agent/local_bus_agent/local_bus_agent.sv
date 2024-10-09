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
//     File for local_bus_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_AGENT
`define LOCAL_BUS_AGENT
typedef uvm_reg_predictor #(local_bus_item) local_bus_predictor;
class local_bus_agent extends uvm_component;
    `uvm_component_utils(local_bus_agent)
    virtual local_bus_interface vif;

    local_bus_config cfg;
    local_bus_predictor pred;
    local_bus_driver drv;
    local_bus_monitor mon;
    local_bus_sequencer sqr;
    local_bus_adapter adpt;
    uvm_analysis_port #(local_bus_item) ap;

    extern         function new(string name = "local_bus_agent",uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass : local_bus_agent

function local_bus_agent :: new(string name = "local_bus_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void local_bus_agent :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mon = local_bus_monitor :: type_id :: create("mon",this);
    mon.vif = vif;

    sqr = local_bus_sequencer :: type_id :: create("sqr",this);
    drv = local_bus_driver :: type_id :: create("drv",this);
    sqr.vif = vif;
    drv.vif = vif;


    adpt = local_bus_adapter :: type_id :: create("adpt",this);
    if(cfg.forecast_mode == EXPLICIT)
    begin
        pred = local_bus_predictor :: type_id :: create("pred",this);
        pred.adapter = adpt;
    end

endfunction : build_phase

function void local_bus_agent :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ap = mon.ap;

    drv.seq_item_port.connect(sqr.seq_item_export);
    if(cfg.forecast_mode == EXPLICIT)
    begin
        mon.ap.connect(pred.bus_in);
    end


endfunction : connect_phase

`endif //LOCAL_BUS_AGENT
