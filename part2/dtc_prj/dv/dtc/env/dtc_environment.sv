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
//     File for dtc_environment.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_ENVIRONMENT__SV
`define DTC_ENVIRONMENT__SV
class dtc_environment extends uvm_env;
    `uvm_component_utils(dtc_environment)
    dadd_environment dadd_env;
    dsel_environment dsel_env;
    axi_environment axi_env;
    apb_environment apb_env;
    dtc_loc_agent dtc_loc_agt;
    dtc_virtual_sequencer vsqr;
    dtc_env_config cfg;


    extern          function new(string name = "dtc_environment",uvm_component parent = null);
    extern virtual  function void build_phase(uvm_phase phase);
    extern virtual  function void connect_phase(uvm_phase phase);
endclass

function dtc_environment:: new(string name = "dtc_environment",uvm_component parent = null);
    super.new(name,parent);
endfunction


function void dtc_environment:: build_phase(uvm_phase phase);
    super.build_phase(phase);

    dadd_env = dadd_environment :: type_id :: create("dadd_env",this);
    dsel_env = dsel_environment :: type_id :: create("dsel_env",this);
    apb_env = apb_environment :: type_id :: create("apb_env",this);
    axi_env = axi_environment :: type_id :: create("axi_env",this);
    dtc_loc_agt = dtc_loc_agent :: type_id :: create("dtc_loc_agt",this);
    vsqr = dtc_virtual_sequencer :: type_id :: create("vsqr",this);

    if(cfg == null)
    begin
        `uvm_fatal("build_phase", "Get a null configuration")
    end
    axi_env.cfg = cfg.axi_cfg;
    apb_env.cfg = cfg.apb_cfg;
    dadd_env.cfg = cfg.dadd_env_cfg;
    dsel_env.cfg = cfg.dsel_env_cfg;
    dtc_loc_agt.cfg = cfg.dtc_loc_cfg;
    vsqr.cfg = cfg;

endfunction : build_phase

function void dtc_environment::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vsqr.apb_vsqr = apb_env.vsqr ;
    vsqr.axi_vsqr = axi_env.vsqr ;
    vsqr.loc_sqr = dtc_loc_agt.sqr;

endfunction : connect_phase

`endif //DTC_ENVIRONMENT__SV
