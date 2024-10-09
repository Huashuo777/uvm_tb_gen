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
//     File for dtc_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_TEST__SV
`define DTC_TEST__SV
/*************************************************************************************/
/**********************************Base Test******************************************/
/*************************************************************************************/
class dtc_base_test extends uvm_test;
    `uvm_component_utils(dtc_base_test)

    ral_top_block rm;
    uvm_event_pool events;
    virtual dadd_loc_interface dadd_loc_vif;
    virtual dsel_loc_interface dsel_loc_vif;
    virtual apb_env_interface dadd_apb_vif;
    virtual apb_env_interface dsel_apb_vif;
    virtual axi_env_interface dsel_axi_vif;
    virtual dtc_loc_interface dtc_loc_vif;
    virtual apb_env_interface dtc_apb_vif;
    virtual axi_env_interface dtc_axi_vif;

    dtc_env_config dtc_env_cfg;
    dtc_environment dtc_env;

    function new(string name = "dtc_base_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction:new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual dadd_loc_interface)::get(this,"","dadd_loc_vif", dadd_loc_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db#(virtual dsel_loc_interface)::get(this,"","dsel_loc_vif", dsel_loc_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db #(virtual apb_env_interface) :: get(this,"","dadd_apb_vif",dadd_apb_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db #(virtual apb_env_interface) :: get(this,"","dsel_apb_vif",dsel_apb_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db #(virtual axi_env_interface) :: get(this,"","dsel_axi_vif",dsel_axi_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db#(virtual dtc_loc_interface)::get(this,"","dtc_loc_vif", dtc_loc_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db#(virtual apb_env_interface)::get(this,"","dtc_apb_vif", dtc_apb_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db #(virtual axi_env_interface) :: get(this,"","dtc_axi_vif",dtc_axi_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");


        events = new("events");
        dtc_env_cfg = new("dtc_env_cfg");
        dtc_env_cfg.events = events;
        rm = ral_top_block:: type_id :: create("rm");
        rm.build(); 
        rm.lock_model();
        rm.reset();
        rm.configure(null,"");
        rm.set_hdl_path_root("tb_dtc.dtc_inst");

        dtc_env_cfg.dsel_env_cfg.dsel_loc_cfg.is_active = UVM_PASSIVE;
        dtc_env_cfg.rm = rm;
        dtc_env_cfg.dadd_loc_vif = dadd_loc_vif;
        dtc_env_cfg.dsel_loc_vif = dsel_loc_vif;
        dtc_env_cfg.dadd_apb_vif = dadd_apb_vif;
        dtc_env_cfg.dsel_apb_vif = dsel_apb_vif;
        dtc_env_cfg.dsel_axi_vif = dsel_axi_vif;
        dtc_env_cfg.dtc_loc_vif  = dtc_loc_vif ;
        dtc_env_cfg.dtc_apb_vif  = dtc_apb_vif ;
        dtc_env_cfg.dtc_axi_vif  = dtc_axi_vif ;

        dtc_env_cfg.set_config();
        dtc_env = dtc_environment :: type_id :: create("dtc_env",this);
        dtc_env.cfg = dtc_env_cfg;
        
    endfunction:build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        rm.default_map.set_sequencer(dtc_env.vsqr.apb_vsqr.mst_sqr[0],dtc_env.apb_env.mst_agt[0].adpt);
        rm.default_map.set_auto_predict(0);
        dtc_env.apb_env.mst_agt[0].pred.map = rm.default_map;
   endfunction : connect_phase

    virtual function void  report_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : report_phase

endclass:dtc_base_test

/*************************************************************************************/
/**********************************Smoke Test*****************************************/
/*************************************************************************************/

class dtc_smoke_test extends dtc_base_test;
    `uvm_component_utils(dtc_smoke_test)

    dtc_smoke_sequence dtc_smoke_seq;
    function new(string name ="dtc_smoke_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase );
        super.build_phase(phase);
    endfunction : build_phase

   task main_phase(uvm_phase phase); 
        `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
        phase.raise_objection(this);
        dtc_smoke_seq = dtc_smoke_sequence :: type_id :: create("dtc_smoke_seq");
        dtc_smoke_seq.start(dtc_env.vsqr);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
   endtask :main_phase

endclass : dtc_smoke_test
/*************************************************************************************/
/**********************************Rand Test*****************************************/
/*************************************************************************************/

class dtc_rand_test extends dtc_base_test;
    `uvm_component_utils(dtc_rand_test)

    dtc_rand_sequence dtc_rand_seq;
    function new(string name ="dtc_rand_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase );
        super.build_phase(phase);
    endfunction : build_phase

    task main_phase(uvm_phase phase); 
         `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
         phase.raise_objection(this);
         dtc_rand_seq = dtc_rand_sequence :: type_id :: create("dtc_rand_seq");
         dtc_rand_seq.start(dtc_env.vsqr);
         phase.drop_objection(this);
         `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
    endtask :main_phase

endclass : dtc_rand_test
/*************************************************************************************/
/**********************************Reset Test*****************************************/
/*************************************************************************************/

class dtc_reset_test extends dtc_base_test;
    `uvm_component_utils(dtc_reset_test)

    dtc_rand_sequence dtc_rand_seq;
    function new(string name ="dtc_reset_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase );
        super.build_phase(phase);
    endfunction : build_phase

    task run_phase(uvm_phase phase); 
        phase.raise_objection(this);
        repeat(100) @(posedge dtc_loc_vif.clk);
        dtc_loc_vif.force_reset_low();
        dtc_env.vsqr.loc_sqr.stop_sequences();
        rm.reset();
        phase.drop_objection(this);
    endtask : run_phase

    task main_phase(uvm_phase phase); 
         `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
         phase.raise_objection(this);
         dtc_rand_seq = dtc_rand_sequence :: type_id :: create("dtc_rand_seq");
         dtc_rand_seq.start(dtc_env.vsqr);
         phase.drop_objection(this);
         `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
    endtask :main_phase

endclass : dtc_reset_test

`endif //DTC_TEST__SV
