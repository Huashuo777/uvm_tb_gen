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
//     File for ral_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef RAL_TEST
`define RAL_TEST

class ral_base_test extends uvm_test;
    reg_model rm;
    ral_environment env;
    local_bus_config cfg;

    `uvm_component_utils(ral_base_test)
    extern function new(string name = "ral_base_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass : ral_base_test

function ral_base_test :: new(string name = "ral_base_test",uvm_component parent = null);
    super.new(name, parent);
endfunction

function void ral_base_test :: build_phase(uvm_phase phase);
    env = ral_environment::type_id::create("env", this);
    cfg = new("cfg");
    rm = reg_model :: type_id :: create("rm");
endfunction : build_phase

function void ral_base_test :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm.build();
    rm.lock_model();
    rm.reset();
    rm.configure(null,"tb_ral.vinfo_inst");
    //rm.set_hdl_path_root("tb_ral.vinfo_inst");
    rm.default_map.set_sequencer(env.local_bus_agt.sqr,env.local_bus_agt.adpt);
endfunction : connect_phase


class ral_auto_test extends ral_base_test;

    `uvm_component_utils(ral_auto_test)
    extern function new(string name = "ral_auto_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    
endclass : ral_auto_test

function ral_auto_test :: new(string name = "ral_auto_test",uvm_component parent = null);
    super.new(name, parent);
endfunction

function void ral_auto_test :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.forecast_mode = AUTO;
    env.cfg  = cfg;
endfunction : build_phase

function void ral_auto_test :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm.default_map.set_auto_predict(1);
endfunction : connect_phase

task ral_auto_test :: main_phase(uvm_phase phase);
    ral_sequence seq = new("seq");
    seq.rm = rm;
    phase.raise_objection(this);
    seq.start(null);
    #1000ns;
    phase.drop_objection(this);
endtask : main_phase

class ral_explicit_test extends ral_base_test;

    `uvm_component_utils(ral_explicit_test)
    extern function new(string name = "ral_explicit_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    
endclass : ral_explicit_test

function ral_explicit_test :: new(string name = "ral_explicit_test",uvm_component parent = null);
    super.new(name, parent);
endfunction

function void ral_explicit_test :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.forecast_mode = EXPLICIT;
    env.cfg  = cfg;
endfunction : build_phase

function void ral_explicit_test :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm.default_map.set_auto_predict(0);
    env.local_bus_agt.pred.map = rm.default_map;
endfunction : connect_phase

task ral_explicit_test :: main_phase(uvm_phase phase);
    ral_sequence seq = new("seq");
    seq.rm = rm;
    phase.raise_objection(this);
    seq.start(null);
    #1000ns;
    phase.drop_objection(this);
endtask : main_phase

class ral_buildin_test extends ral_base_test;

    `uvm_component_utils(ral_buildin_test)
    extern function new(string name = "ral_buildin_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    
endclass : ral_buildin_test

function ral_buildin_test :: new(string name = "ral_buildin_test",uvm_component parent = null);
    super.new(name, parent);
endfunction

function void ral_buildin_test :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.forecast_mode = EXPLICIT;
    env.cfg  = cfg;
    //uvm_resource_db#(bit)::set({"REG::",rm.get_full_name()}, "NO_REG_ACCESS_TEST", 1, this);
endfunction : build_phase

function void ral_buildin_test :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm.default_map.set_auto_predict(0);
    env.local_bus_agt.pred.map = rm.default_map;
endfunction : connect_phase

task ral_buildin_test :: main_phase(uvm_phase phase);
    uvm_reg_access_seq seq = new("seq");
    seq.model = rm;
    phase.raise_objection(this);
    seq.start(null);
    #1000ns;
    phase.drop_objection(this);
endtask : main_phase

`endif //RAL_TEST
