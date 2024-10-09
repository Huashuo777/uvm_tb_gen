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
//     File for dadd_env_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_ENV_CONFIG__SV
`define DADD_ENV_CONFIG__SV
class dadd_env_config extends uvm_object;

    virtual dadd_loc_interface dadd_loc_vif;
    virtual apb_env_interface dadd_apb_vif;
    apb_master_config m_cfg;
    apb_env_config apb_cfg;
    dadd_loc_config dadd_loc_cfg;
    uvm_event_pool events;
    dadd_block rm;
    uvm_active_passive_enum is_active = UVM_ACTIVE; 

    `uvm_object_utils_begin(dadd_env_config)
    `uvm_object_utils_end

    extern          function new(string name = "dadd_env_config");
    extern  virtual function void set_config(bit is_system = 0);
endclass : dadd_env_config

function dadd_env_config::new(string name = "dadd_env_config");
    super.new(name);
    dadd_loc_cfg = new("dadd_loc_cfg");
    m_cfg = new("e0_m0");
    apb_cfg = new("apb_cfg");
endfunction : new

function void dadd_env_config :: set_config(bit is_system = 0);
    m_cfg.index = 0;
    dadd_loc_cfg.events = events;
    apb_cfg.events = events; 
    dadd_loc_cfg.vif = dadd_loc_vif;
    apb_cfg.vif = dadd_apb_vif;
    apb_cfg.set_config(m_cfg);
    if(!is_system)
    begin
        dadd_loc_cfg.is_active = UVM_ACTIVE;
        apb_cfg.mst_cfg[0].is_active = UVM_ACTIVE;
        apb_cfg.mst_cfg[0].use_reg_model = apb_env_pkg::True;
    end
    else
    begin
        dadd_loc_cfg.is_active = UVM_PASSIVE;
        apb_cfg.mst_cfg[0].is_active = UVM_PASSIVE;
        apb_cfg.mst_cfg[0].use_reg_model = apb_env_pkg::False;
    end
endfunction: set_config

`endif // DADD_ENV_CONFIG__SV
