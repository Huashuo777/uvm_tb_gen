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
//     File for dadd_loc_agent.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_AGENT__SV
`define DADD_LOC_AGENT__SV
class dadd_loc_agent extends uvm_agent;
    dadd_loc_config     cfg;
    dadd_loc_sequencer  sqr;
    dadd_loc_driver     drv;
    dadd_loc_monitor    mon;

    uvm_analysis_port #(dadd_loc_item) ap;

    `uvm_component_utils(dadd_loc_agent)
    extern function new(string name ="dadd_loc_agent", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase); 
endclass: dadd_loc_agent

function dadd_loc_agent :: new(string name ="dadd_loc_agent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_loc_agent :: start_of_simulation_phase(uvm_phase phase); 
    super.start_of_simulation_phase(phase); 
endfunction: start_of_simulation_phase

function void dadd_loc_agent :: build_phase(uvm_phase phase);

    super.build_phase(phase);
    
    if(cfg == null)
    begin
        `uvm_fatal("build_phase", "Get a null configuration")
    end

    mon = dadd_loc_monitor::type_id::create("mon", this);
    mon.cfg = this.cfg;

    if(cfg.is_active == UVM_ACTIVE)
    begin
        sqr = dadd_loc_sequencer::type_id::create("sqr", this);
        sqr.cfg = this.cfg;
        drv = dadd_loc_driver::type_id::create("drv", this);
        drv.cfg = this.cfg;
    end
endfunction: build_phase

function void dadd_loc_agent :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(cfg.is_active == UVM_ACTIVE)
    begin
        drv.seq_item_port.connect(sqr.seq_item_export);
    end

    this.ap = mon.ap;
endfunction: connect_phase

`endif // DADD_LOC_AGENT__SV
