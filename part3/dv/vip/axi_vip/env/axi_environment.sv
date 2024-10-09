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
//     File for axi_environment.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_ENVIRONMENT__SV
`define AXI_ENVIRONMENT__SV

class axi_environment extends uvm_env;
    axi_master_agent      mst_agt[];
    axi_slave_agent       slv_agt[];
    axi_virtual_sequencer vsqr;
    uvm_analysis_port #(axi_master_item) mst_ap[]; 
    uvm_analysis_port #(axi_slave_item) slv_ap[];

    axi_env_config  cfg;
    virtual axi_env_interface vif;

    `uvm_component_utils(axi_environment)

    extern                   function      new(string name, uvm_component parent);
    extern                   function void build_phase(uvm_phase phase);
    extern                   function void connect_phase(uvm_phase phase);
endclass

function axi_environment::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void axi_environment::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
        `uvm_fatal("build_phase", "Get a null env configuration")
    vsqr = axi_virtual_sequencer::type_id::create("vsqr", this);
    
    mst_agt = new[cfg.mst_cfg.size()];
    vsqr.mst_sqr = new[cfg.mst_cfg.size()];
    mst_ap  = new[cfg.mst_cfg.size()];
    foreach(mst_agt[i]) 
    begin
        if (cfg.mst_cfg[i].index != -1) 
        begin
            mst_agt[i] = axi_master_agent::type_id::create($sformatf("master_%s", cfg.mst_cfg[i].get_name()), this);
            mst_agt[i].cfg = cfg.mst_cfg[i];
            mst_agt[i].vif = cfg.vif.get_master_if(i);
        end
    end

    slv_agt = new[cfg.slv_cfg.size()];
    vsqr.slv_sqr = new[cfg.slv_cfg.size()];
    slv_ap = new[cfg.slv_cfg.size()];
    foreach(slv_agt[i]) 
    begin
        if (cfg.slv_cfg[i].index != -1) 
        begin
            slv_agt[i] = axi_slave_agent::type_id::create($sformatf("slave_%s", cfg.slv_cfg[i].get_name()), this);
            slv_agt[i].cfg = cfg.slv_cfg[i];
            slv_agt[i].vif = cfg.vif.get_slave_if(i);
        end
    end

    vsqr.cfg = cfg;
endfunction

function void axi_environment::connect_phase(uvm_phase phase);
    foreach (cfg.mst_cfg[i]) 
    begin
        cfg.mst_cfg[i].events = cfg.events;
        mst_ap[i] = mst_agt[i].ap;
        vsqr.mst_sqr[i] = mst_agt[i].sqr;
    end
    foreach (cfg.slv_cfg[i]) 
    begin
        cfg.slv_cfg[i].events = cfg.events;
        slv_ap[i] = slv_agt[i].ap;
        vsqr.slv_sqr[i] = slv_agt[i].sqr;
    end
endfunction

`endif //AXI_ENVIRONMENT__SV
