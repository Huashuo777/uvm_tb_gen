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
//     File for apb_env_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_ENV_CONFIG__SV
`define APB_ENV_CONFIG__SV
class apb_env_config extends uvm_object;

    virtual apb_env_interface vif;
    uvm_event_pool events;
    apb_master_config mst_cfg[$];
    apb_slave_config  slv_cfg[$];


    `uvm_object_utils_begin(apb_env_config)
        `uvm_field_queue_object (mst_cfg,UVM_ALL_ON)
        `uvm_field_queue_object (slv_cfg,UVM_ALL_ON)
    `uvm_object_utils_end

    extern         function      new(string name = "apb_env_config");
    extern virtual function void set_config(apb_base_config cfg);
endclass

function apb_env_config::new(string name = "apb_env_config");
    super.new(name);
endfunction : new

function void apb_env_config::set_config(apb_base_config cfg);
    apb_master_config m_cfg;
    apb_slave_config  s_cfg;

    if (cfg == null)
        `uvm_fatal("set_config", "Which apb agent config set is null")

    cfg.events = events;
    if ($cast(m_cfg, cfg)) 
    begin
        mst_cfg.push_back(m_cfg);
    end
    else if ($cast(s_cfg, cfg))
    begin
        slv_cfg.push_back(s_cfg);
    end
    else
        `uvm_fatal("set_config", "Invalid apb agent configure object type")
endfunction : set_config

`endif //APB_ENV_CONFIG__SV
