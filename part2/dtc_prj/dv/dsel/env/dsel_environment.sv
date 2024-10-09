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
//     File for dsel_environment.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_ENVIRONMENT__SV
`define DSEL_ENVIRONMENT__SV

class dsel_environment extends uvm_env;
    axi_environment axi_env;
    apb_environment apb_env;
    dsel_loc_agent dsel_loc_agt;
    dsel_refmodel      refmdl;
    dsel_scoreboard    scb;
    dsel_cov_mon    cov_mon;
    dsel_env_config cfg;
    dsel_virtual_sequencer vsqr;


    uvm_tlm_analysis_fifo #(dsel_loc_item) dsel_loc_agt_ref_fifo;
    uvm_tlm_analysis_fifo #(dsel_loc_item) dsel_loc_ref_scb_fifo;

    uvm_tlm_analysis_fifo #(axi_master_item) axi_master_agt_refmdl_fifo;

    uvm_tlm_analysis_fifo #(axi_master_item) axi_master_agt_scb_fifo;

    `uvm_component_utils(dsel_environment)

    extern         function new(string name ="dsel_environment", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase); 

endclass: dsel_environment

function dsel_environment:: new(string name ="dsel_environment", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dsel_environment::build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_env = axi_environment :: type_id :: create("axi_env",this);
    apb_env = apb_environment :: type_id :: create("apb_env",this);

    dsel_loc_agt = dsel_loc_agent::type_id::create("dsel_loc_agt", this);
    refmdl = dsel_refmodel::type_id::create("refmdl",  this);
    scb    = dsel_scoreboard::type_id::create("scb", this);
    cov_mon = dsel_cov_mon::type_id::create("cov_mon", this);
    vsqr = dsel_virtual_sequencer :: type_id :: create("vsqr",this);

    dsel_loc_agt_ref_fifo = new("dsel_loc_agt_ref_fifo", this);
    axi_master_agt_scb_fifo = new("axi_master_agt_scb_fifo", this);
    dsel_loc_ref_scb_fifo = new("dsel_loc_ref_scb_fifo", this);
    axi_master_agt_refmdl_fifo = new("axi_master_agt_refmdl_fifo",this);

    if(cfg == null)
    begin
        `uvm_fatal("build_phase", "Get a null configuration")
    end
    dsel_loc_agt.cfg = cfg.dsel_loc_cfg;
    apb_env.cfg = cfg.apb_cfg;
    axi_env.cfg = cfg.axi_cfg;
    refmdl.cfg = cfg;
    scb.cfg = cfg;
    cov_mon.cfg = cfg;
    vsqr.cfg = cfg;

endfunction: build_phase

function void dsel_environment::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    vsqr.apb_vsqr = apb_env.vsqr ;
    vsqr.axi_vsqr = axi_env.vsqr ;
    vsqr.loc_sqr = dsel_loc_agt.sqr;

    dsel_loc_agt.ap.connect(dsel_loc_agt_ref_fifo.analysis_export);
    refmdl.dsel_loc_port.connect(dsel_loc_agt_ref_fifo.blocking_get_export);
    refmdl.dsel_loc_ap.connect(dsel_loc_ref_scb_fifo.analysis_export);
    scb.dsel_loc_exp_port.connect(dsel_loc_ref_scb_fifo.blocking_get_export);
    scb.axi_mst_act_port.connect(axi_master_agt_scb_fifo.blocking_get_export);

    refmdl.axi_mst_port.connect(axi_master_agt_refmdl_fifo.blocking_get_export);

    axi_env.mst_ap[0].connect(axi_master_agt_refmdl_fifo.analysis_export);

    axi_env.mst_ap[0].connect(axi_master_agt_scb_fifo.analysis_export);

    dsel_loc_agt.ap.connect(cov_mon.dsel_loc_export);

endfunction: connect_phase

task dsel_environment :: reset_phase(uvm_phase phase);
    dsel_loc_agt_ref_fifo.flush();
    dsel_loc_ref_scb_fifo.flush();
    axi_master_agt_refmdl_fifo.flush();
    axi_master_agt_scb_fifo.flush();
endtask : reset_phase

`endif // DSEL_ENVIRONMENT__SV
