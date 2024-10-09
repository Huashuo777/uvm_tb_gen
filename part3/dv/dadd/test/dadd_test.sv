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
//     File for dadd_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_TEST__SV
`define DADD_TEST__SV
/*************************************************************************************/
/**********************************Base Test******************************************/
/*************************************************************************************/
class dadd_base_test extends uvm_test;
    `uvm_component_utils(dadd_base_test)

    uvm_event_pool events;
    virtual dadd_loc_interface dadd_loc_vif;
    dadd_env_config dadd_env_cfg;
    virtual apb_env_interface dadd_apb_vif;
    dadd_block rm;

    dadd_environment dadd_env;

    function new(string name ="dadd_base_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        if(!uvm_config_db #(virtual dadd_loc_interface) :: get(this,"","dadd_loc_vif",dadd_loc_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db #(virtual apb_env_interface) :: get(this,"","dadd_apb_vif",dadd_apb_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");

        rm = dadd_block:: type_id :: create("rm");
        dadd_env = dadd_environment :: type_id :: create("dadd_env",this);
        rm.build(); 
        rm.lock_model();
        rm.reset();
        rm.configure(null,"");
        rm.set_hdl_path_root("tb_dadd.dadd_inst");

        events = new("events");
        dadd_env_cfg = new("dadd_env_cfg");
        dadd_env_cfg.events = events;
        dadd_env_cfg.rm = rm;
        dadd_env_cfg.dadd_loc_vif = dadd_loc_vif;
        dadd_env_cfg.dadd_apb_vif = dadd_apb_vif;
        dadd_env_cfg.set_config();

        dadd_env.cfg = dadd_env_cfg;
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        dadd_env.apb_env.mst_agt[0].pred.map = rm.default_map;
        rm.default_map.set_sequencer(dadd_env.vsqr.apb_vsqr.mst_sqr[0],dadd_env.apb_env.mst_agt[0].adpt);
        rm.default_map.set_auto_predict(0);
    endfunction : connect_phase
    
    virtual function void  report_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : report_phase

endclass: dadd_base_test

/*************************************************************************************/
/**********************************Smoke Test*****************************************/
/*************************************************************************************/
class dadd_smoke_test extends dadd_base_test;
  `uvm_component_utils(dadd_smoke_test)

    function new(string name ="dadd_smoke_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task main_phase(uvm_phase phase);
        dadd_smoke_sequence dadd_smoke_seq;
        `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
        super.main_phase(phase);
        phase.raise_objection(this);
        dadd_smoke_seq = dadd_smoke_sequence :: type_id :: create("dadd_smoke_seq");
        dadd_smoke_seq.start(dadd_env.vsqr);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
    endtask : main_phase
endclass : dadd_smoke_test

/*************************************************************************************/
/**********************************Random Test*****************************************/
/*************************************************************************************/
class dadd_rand_test extends dadd_base_test;
  `uvm_component_utils(dadd_rand_test)

    function new(string name ="dadd_rand_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task main_phase(uvm_phase phase);
        dadd_rand_sequence dadd_rand_seq;
        `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
        super.main_phase(phase);
        phase.raise_objection(this);
        dadd_rand_seq = dadd_rand_sequence :: type_id :: create("dadd_rand_seq");
        dadd_rand_seq.start(dadd_env.vsqr);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
    endtask : main_phase

endclass : dadd_rand_test
/*************************************************************************************/
/**********************************Reset Test*****************************************/
/*************************************************************************************/
class dadd_reset_test extends dadd_base_test;
  `uvm_component_utils(dadd_reset_test)

    function new(string name ="dadd_reset_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(100) @(posedge dadd_loc_vif.clk);
        dadd_loc_vif.force_reset_low();
        dadd_env.vsqr.loc_sqr.stop_sequences();
        rm.reset();
        phase.drop_objection(this);
    endtask : run_phase

    task main_phase(uvm_phase phase);
        dadd_rand_sequence dadd_rand_seq;
        `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
        super.main_phase(phase);
        phase.raise_objection(this);
        dadd_rand_seq = dadd_rand_sequence :: type_id :: create("dadd_rand_seq");
        dadd_rand_seq.start(dadd_env.vsqr);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
    endtask : main_phase

endclass : dadd_reset_test

`endif //DADD_TEST__SV
