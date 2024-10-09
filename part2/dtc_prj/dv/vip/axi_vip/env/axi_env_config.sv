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
//     File for axi_env_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_ENV_CONFIG__SV
`define AXI_ENV_CONFIG__SV
class axi_env_config extends uvm_object;

    virtual axi_env_interface vif;
    axi_master_config mst_cfg[$];
    axi_slave_config  slv_cfg[$];
    uvm_event_pool events;


    `uvm_object_utils_begin(axi_env_config)
        `uvm_field_queue_object (mst_cfg,UVM_ALL_ON)
        `uvm_field_queue_object (slv_cfg,UVM_ALL_ON)
    `uvm_object_utils_end

    extern         function      new(string name = "axi_env_config");
    extern virtual function void set_config(axi_base_config cfg);
endclass

function axi_env_config::new(string name = "axi_env_config");
    super.new(name);
endfunction : new

function void axi_env_config::set_config(axi_base_config cfg);
    axi_master_config m_cfg;
    axi_slave_config  s_cfg;

    if (cfg == null)
        `uvm_fatal("set_config", "Which axi agent config set is null")

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
        `uvm_fatal("set_config", "Invalid axi agent configure object type")
endfunction : set_config

`endif //AXI_ENV_CONFIG__SV
