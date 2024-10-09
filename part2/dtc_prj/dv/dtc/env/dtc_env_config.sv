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
//     File for dtc_env_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_ENV_CONFIG__SV
`define DTC_ENV_CONFIG__SV
class dtc_env_config extends uvm_object;
    
    virtual dadd_loc_interface dadd_loc_vif;
    virtual dsel_loc_interface dsel_loc_vif;
    virtual apb_env_interface dadd_apb_vif;
    virtual apb_env_interface dsel_apb_vif;
    virtual axi_env_interface dsel_axi_vif;
    virtual dtc_loc_interface dtc_loc_vif;
    virtual apb_env_interface dtc_apb_vif;
    virtual axi_env_interface dtc_axi_vif;
    ral_top_block rm;
    uvm_event_pool events;
    dtc_loc_config dtc_loc_cfg;
    dsel_env_config dsel_env_cfg;
    dadd_env_config dadd_env_cfg;
    apb_master_config apb_mst_cfg;
    axi_master_config axi_mst_cfg;
    apb_env_config apb_cfg;
    axi_env_config axi_cfg;
    uvm_active_passive_enum is_active = UVM_ACTIVE; 

    `uvm_object_utils_begin(dtc_env_config)
    `uvm_object_utils_end

    extern          function new(string name = "dtc_env_config");
    extern  virtual function void set_config();
endclass

function dtc_env_config::new(string name = "dtc_env_config");
    super.new(name);
    dsel_env_cfg = new("dsel_env_cfg");
    dadd_env_cfg = new("dadd_env_cfg");
    dtc_loc_cfg = new("dtc_loc_cfg");
    apb_mst_cfg = new("apb_m0");
    apb_cfg = new("apb_cfg");
    axi_mst_cfg = new("axi_m0");
    axi_cfg = new("axi_cfg");
endfunction : new

function void dtc_env_config :: set_config();
    apb_mst_cfg.index = 0;
    axi_mst_cfg.index = 0;
    apb_cfg.events = events; 
    apb_cfg.vif = dtc_apb_vif;
    axi_cfg.events = events;
    axi_cfg.vif = dtc_axi_vif;
    apb_cfg.set_config(apb_mst_cfg);
    axi_cfg.set_config(axi_mst_cfg);
    apb_cfg.mst_cfg[0].use_reg_model = apb_env_pkg::True;
    dtc_loc_cfg.events = events;
    dtc_loc_cfg.vif = dtc_loc_vif;
    //dadd config
    dadd_env_cfg.events = events;
    dadd_env_cfg.dadd_loc_vif = dadd_loc_vif;
    dadd_env_cfg.dadd_apb_vif = dadd_apb_vif;
    dadd_env_cfg.rm = rm.dadd_blk;

    dadd_env_cfg.set_config(1);
    //dsel config
    dsel_env_cfg.events = events;
    dsel_env_cfg.rm = rm.dsel_blk;
    dsel_env_cfg.dsel_loc_vif = dsel_loc_vif;
    dsel_env_cfg.dsel_apb_vif = dsel_apb_vif;
    dsel_env_cfg.dsel_axi_vif = dsel_axi_vif;
    dsel_env_cfg.set_config(1);

    //dsel_env_cfg.apb_cfg.mst_cfg[0].use_reg_model = apb_env_pkg::False;
    //dsel_env_cfg.dsel_loc_cfg.is_active = UVM_PASSIVE;
    //dsel_env_cfg.apb_cfg.mst_cfg[0].is_active = UVM_PASSIVE;
    //dsel_env_cfg.axi_cfg.mst_cfg[0].is_active = UVM_PASSIVE;
endfunction : set_config

`endif //DTC_ENV_CONFIG__SV
