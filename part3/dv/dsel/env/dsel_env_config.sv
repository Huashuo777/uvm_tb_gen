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
//     File for dsel_env_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DASEL_ENV_CONFIG__SV
`define DASEL_ENV_CONFIG__SV
class dsel_env_config extends uvm_object;
    
    virtual dsel_loc_interface dsel_loc_vif;
    virtual apb_env_interface dsel_apb_vif;
    virtual axi_env_interface dsel_axi_vif;
    uvm_event_pool events;
    dsel_block rm;
    dsel_loc_config dsel_loc_cfg;
    apb_env_config apb_cfg;
    axi_env_config axi_cfg;
    apb_master_config apb_mst_cfg;
    axi_master_config axi_mst_cfg;
    uvm_active_passive_enum is_active = UVM_ACTIVE; 

    `uvm_object_utils_begin(dsel_env_config)
    `uvm_object_utils_end

    extern          function new(string name = "dsel_env_config");
    extern  virtual function void set_config(bit is_system = 0);
endclass

function dsel_env_config::new(string name = "dsel_env_config");
    super.new(name);
    dsel_loc_cfg = new("dsel_loc_cfg");
    apb_mst_cfg = new("apb_m0");
    apb_cfg = new("apb_cfg");
    axi_mst_cfg = new("axi_m0");
    axi_cfg = new("axi_cfg");
endfunction : new

function void dsel_env_config :: set_config(bit is_system = 0);
    apb_mst_cfg.index = 0;
    axi_mst_cfg.index = 0;
    dsel_loc_cfg.events = events;
    dsel_loc_cfg.vif = dsel_loc_vif;
    apb_cfg.events = events; 
    axi_cfg.events = events;
    apb_cfg.vif = dsel_apb_vif;
    apb_cfg.set_config(apb_mst_cfg);
    axi_cfg.vif = dsel_axi_vif;
    axi_cfg.set_config(axi_mst_cfg);
    if(!is_system)
    begin
        apb_cfg.mst_cfg[0].use_reg_model = apb_env_pkg::True;
        dsel_loc_cfg.is_active = UVM_ACTIVE;
        apb_cfg.mst_cfg[0].is_active = UVM_ACTIVE;
        axi_cfg.mst_cfg[0].is_active = UVM_ACTIVE;
    end
    else
    begin
        apb_cfg.mst_cfg[0].use_reg_model = apb_env_pkg::False;
        dsel_loc_cfg.is_active = UVM_PASSIVE;
        apb_cfg.mst_cfg[0].is_active = UVM_PASSIVE;
        axi_cfg.mst_cfg[0].is_active = UVM_PASSIVE;
    end
endfunction : set_config

`endif // DSEL_ENV_CONFIG__SV
