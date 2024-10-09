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
//     File for dadd_environment.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_ENVIRONMENT__SV
`define DADD_ENVIRONMENT__SV
class dadd_environment extends uvm_env;
    apb_environment apb_env;

    dadd_loc_agent dadd_loc_agt;
    dadd_refmodel   refmdl;
    dadd_scoreboard scb;
    dadd_cov_mon    cov_mon;
    dadd_env_config cfg;
    dadd_virtual_sequencer vsqr;


    uvm_tlm_analysis_fifo #(dadd_loc_item) dadd_loc_agt_refmdl_fifo;
    uvm_tlm_analysis_fifo #(dadd_loc_item) dadd_loc_agt_scb_fifo;
    uvm_tlm_analysis_fifo #(dadd_loc_item) dadd_loc_refmdl_scb_fifo;

    `uvm_component_utils(dadd_environment)

    extern function new(string name ="dadd_environment", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase); 
    extern function void connect_phase(uvm_phase phase);
endclass: dadd_environment

function dadd_environment :: new(string name ="dadd_environment", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_environment :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_env = apb_environment :: type_id :: create("apb_env",this);

    dadd_loc_agt = dadd_loc_agent::type_id::create("dadd_loc_agt", this);
    refmdl = dadd_refmodel::type_id::create("refmdl",  this);
    scb = dadd_scoreboard::type_id::create("scb", this);
    vsqr = dadd_virtual_sequencer :: type_id :: create("vsqr",this);
    cov_mon = dadd_cov_mon::type_id::create("cov_mon", this);

    dadd_loc_agt_refmdl_fifo = new("dadd_loc_agt_refmdl_fifo", this);
    dadd_loc_agt_scb_fifo = new("dadd_loc_agt_scb_fifo", this);
    dadd_loc_refmdl_scb_fifo = new("dadd_loc_refmdl_scb_fifo", this);

    if(cfg == null)
    begin
        `uvm_fatal("build_phase", "Get a null configuration")
    end
    dadd_loc_agt.cfg = cfg.dadd_loc_cfg;
    apb_env.cfg = cfg.apb_cfg;
    dadd_loc_agt.is_active = cfg.is_active;
    refmdl.cfg = cfg;
    scb.cfg = cfg;
    cov_mon.cfg = cfg;
    vsqr.cfg = cfg;

endfunction: build_phase

function void dadd_environment :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    vsqr.loc_sqr = dadd_loc_agt.sqr;
    vsqr.apb_vsqr = apb_env.vsqr;

    dadd_loc_agt.ap.connect(dadd_loc_agt_refmdl_fifo.analysis_export);
    dadd_loc_agt.ap.connect(dadd_loc_agt_scb_fifo.analysis_export);
    refmdl.dadd_loc_port.connect(dadd_loc_agt_refmdl_fifo.blocking_get_export);
    refmdl.dadd_loc_ap.connect(dadd_loc_refmdl_scb_fifo.analysis_export);
    scb.dadd_loc_exp_port.connect(dadd_loc_refmdl_scb_fifo.blocking_get_export);
    scb.dadd_loc_act_port.connect(dadd_loc_agt_scb_fifo.blocking_get_export);

    dadd_loc_agt.ap.connect(cov_mon.dadd_loc_export);

endfunction: connect_phase

task dadd_environment :: reset_phase(uvm_phase phase);
    dadd_loc_agt_refmdl_fifo.flush();
    dadd_loc_agt_scb_fifo.flush();
    dadd_loc_refmdl_scb_fifo.flush();
endtask : reset_phase

`endif // DADD_ENVIRONMENT__SV
