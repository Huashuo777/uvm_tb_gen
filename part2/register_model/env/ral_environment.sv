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
//     File for ral_environment.sv                                                       
//----------------------------------------------------------------------------------
`ifndef RAL_ENVIRONMENT
`define RAL_ENVIRONMENT

class ral_environment extends uvm_env;
    local_bus_agent local_bus_agt;
    uvm_analysis_port #(local_bus_item) ap;
    local_bus_config cfg;

    virtual local_bus_interface vif;

    `uvm_component_utils(ral_environment)

    extern function      new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass

function ral_environment::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void ral_environment::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual local_bus_interface)::get(null, get_full_name(), "vif", vif))
        `uvm_fatal("build_phase", "Cannot get local_bus_vif")

    local_bus_agt = local_bus_agent ::type_id::create("local_bus_agt", this);
    local_bus_agt.cfg = cfg;
    local_bus_agt.vif = vif;
endfunction

function void ral_environment::connect_phase(uvm_phase phase);
    ap = local_bus_agt.ap;
endfunction

`endif //RAL_ENVIRONMENT
