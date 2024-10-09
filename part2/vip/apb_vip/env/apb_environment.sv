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
//     File for apb_environment.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_ENVIRONMENT__SV
`define APB_ENVIRONMENT__SV

class apb_environment extends uvm_env;
    apb_master_agent      mst_agt[];
    apb_slave_agent       slv_agt[];
    apb_virtual_sequencer vsqr;
    uvm_analysis_port #(apb_master_item) mst_ap[];
    uvm_analysis_port #(apb_slave_item) slv_ap[];

    apb_env_config  cfg;
    virtual apb_env_interface vif;

    `uvm_component_utils(apb_environment)

    extern                   function      new(string name, uvm_component parent);
    extern                   function void build_phase(uvm_phase phase);
    extern                   function void connect_phase(uvm_phase phase);
endclass

function apb_environment::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void apb_environment::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
        `uvm_fatal("build_phase", "Get a null env configuration")

    vsqr = apb_virtual_sequencer::type_id::create("vsqr", this);
    
    mst_agt = new[cfg.mst_cfg.size()];
    mst_ap = new[cfg.mst_cfg.size()];
    vsqr.mst_sqr = new[cfg.mst_cfg.size()];
    foreach(mst_agt[i]) 
    begin
        if (cfg.mst_cfg[i].index != -1) 
        begin
            mst_agt[i] = apb_master_agent::type_id::create($sformatf("master_%s", cfg.mst_cfg[i].get_name()), this);
            mst_agt[i].cfg = cfg.mst_cfg[i];
            mst_agt[i].vif = cfg.vif.get_master_if(i);
        end
    end

    slv_agt = new[cfg.slv_cfg.size()];
    slv_ap = new[cfg.slv_cfg.size()];
    vsqr.slv_sqr = new[cfg.slv_cfg.size()];
    foreach(slv_agt[i]) 
    begin
        if (cfg.slv_cfg[i].index != -1) 
        begin
            slv_agt[i] = apb_slave_agent::type_id::create($sformatf("slave_%s", cfg.slv_cfg[i].get_name()), this);
            slv_agt[i].cfg = cfg.slv_cfg[i];
            slv_agt[i].vif = cfg.vif.get_slave_if(i);
        end
    end

    vsqr.cfg = cfg;
endfunction

function void apb_environment::connect_phase(uvm_phase phase);
    foreach (cfg.mst_cfg[i]) 
    begin
        cfg.mst_cfg[i].events = cfg.events;
        vsqr.mst_sqr[i] = mst_agt[i].sqr;
        mst_ap[i] = mst_agt[i].ap;
    end
    foreach (cfg.slv_cfg[i]) 
    begin
        cfg.slv_cfg[i].events = cfg.events;
        vsqr.slv_sqr[i] = slv_agt[i].sqr;
        slv_ap[i] = slv_agt[i].ap;
    end
endfunction

`endif //APB_ENVIRONMENT__SV
