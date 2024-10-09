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
//     File for dsel_loc_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_AGENT__SV
`define DSEL_LOC_AGENT__SV
class dsel_loc_agent extends uvm_agent;
    dsel_loc_config     cfg;
    dsel_loc_sequencer  sqr;
    dsel_loc_driver     drv;
    dsel_loc_monitor    mon;

    uvm_analysis_port #(dsel_loc_item) ap;
    `uvm_component_utils(dsel_loc_agent)

    extern         function new(string name ="dsel_loc_agent", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass: dsel_loc_agent

function dsel_loc_agent :: new(string name ="dsel_loc_agent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dsel_loc_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(cfg == null)
    begin
        `uvm_fatal("build_phase", "Get a null configuration")
    end

    mon = dsel_loc_monitor::type_id::create("mon", this);
    mon.cfg = this.cfg;

    if(cfg.is_active == UVM_ACTIVE)
    begin
        sqr = dsel_loc_sequencer::type_id::create("sqr", this);
        sqr.cfg = this.cfg;
        drv = dsel_loc_driver::type_id::create("drv", this);
        drv.cfg = this.cfg;
    end

endfunction: build_phase

function void dsel_loc_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(cfg.is_active == UVM_ACTIVE)
    begin
        drv.seq_item_port.connect(sqr.seq_item_export);
    end

    this.ap = mon.ap;
endfunction: connect_phase
`endif // DSEL_LOC_AGENT__SV
