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
//     File for dtc_loc_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_AGENT__SV
`define DTC_LOC_AGENT__SV
class dtc_loc_agent extends uvm_agent;
    dtc_loc_config     cfg;
    dtc_loc_sequencer  sqr;
    dtc_loc_driver     drv;
    dtc_loc_monitor    mon;

    uvm_analysis_port #(dtc_loc_item) ap;

    `uvm_component_utils(dtc_loc_agent)
    extern function new(string name ="dtc_loc_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass: dtc_loc_agent

function dtc_loc_agent :: new(string name ="dtc_loc_agent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dtc_loc_agent :: build_phase(uvm_phase phase);

    super.build_phase(phase);
    
    if(cfg == null)
    begin
        `uvm_fatal("build_phase", "Get a null configuration")
    end

    mon = dtc_loc_monitor::type_id::create("mon", this);
    mon.cfg = this.cfg;

    if(cfg.is_active == UVM_ACTIVE)
    begin
        sqr = dtc_loc_sequencer::type_id::create("sqr", this);
        sqr.cfg = this.cfg;
        drv = dtc_loc_driver::type_id::create("drv", this);
        drv.cfg = this.cfg;
    end
endfunction: build_phase

function void dtc_loc_agent :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(cfg.is_active == UVM_ACTIVE)
    begin
        drv.seq_item_port.connect(sqr.seq_item_export);
    end

    this.ap = mon.ap;
endfunction: connect_phase

`endif // DTC_LOC_AGENT__SV
