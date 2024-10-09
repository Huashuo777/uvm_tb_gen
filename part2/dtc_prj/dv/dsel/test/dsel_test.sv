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
//     File for dsel_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_TEST__SV
`define DSEL_TEST__SV
/*************************************************************************************/
/**********************************Base Test******************************************/
/*************************************************************************************/
class dsel_base_test extends uvm_test;
    `uvm_component_utils(dsel_base_test)

    uvm_event_pool events;
    virtual dsel_loc_interface dsel_loc_vif;
    virtual apb_env_interface dsel_apb_vif;
    virtual axi_env_interface dsel_axi_vif;

    dsel_env_config dsel_env_cfg;

    dsel_environment dsel_env;
    dsel_block rm ;

    function new(string name ="dsel_base_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        rm.default_map.set_sequencer(dsel_env.vsqr.apb_vsqr.mst_sqr[0],dsel_env.apb_env.mst_agt[0].adpt);
        rm.default_map.set_auto_predict(0);
        dsel_env.apb_env.mst_agt[0].pred.map = rm.default_map;
    endfunction : connect_phase
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual dsel_loc_interface)::get(this,"","dsel_loc_vif", dsel_loc_vif))
            `uvm_fatal("NOVIF", {"Virtual interface must be set for:", get_full_name(), {".vif"}})
        if(!uvm_config_db #(virtual apb_env_interface) :: get(this,"","dsel_apb_vif",dsel_apb_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");
        if(!uvm_config_db #(virtual axi_env_interface) :: get(this,"","dsel_axi_vif",dsel_axi_vif))
            `uvm_fatal(get_type_name(),"The interface is not get !!!");

        rm = dsel_block:: type_id :: create("rm");
        rm.build(); 
        rm.lock_model();                                                                                                                                                                                                          
        rm.reset();
        rm.configure(null,"");
        rm.set_hdl_path_root("tb_dsel.dsel_inst");

        events = new("events");
        dsel_env_cfg = new("dsel_env_cfg");
        dsel_env_cfg.events = events;
        dsel_env_cfg.rm = rm;
        dsel_env_cfg.dsel_loc_vif = dsel_loc_vif;
        dsel_env_cfg.dsel_apb_vif = dsel_apb_vif;
        dsel_env_cfg.dsel_axi_vif = dsel_axi_vif;
        dsel_env_cfg.set_config();
        dsel_env = dsel_environment :: type_id :: create("dsel_env",this);
        dsel_env.cfg = dsel_env_cfg;
    endfunction : build_phase
    
    virtual function void  report_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : report_phase

endclass: dsel_base_test

/*************************************************************************************/
/**********************************Smoke Test*****************************************/
/*************************************************************************************/
class dsel_smoke_test extends dsel_base_test;
    dsel_smoke_sequence dsel_smoke_seq;
    `uvm_component_utils(dsel_smoke_test)

    function new(string name ="dsel_smoke_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

   task main_phase(uvm_phase phase); 
        `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
        phase.raise_objection(this);
        dsel_smoke_seq = dsel_smoke_sequence :: type_id :: create("dsel_smoke_seq");
        dsel_smoke_seq.start(dsel_env.vsqr);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
   endtask :main_phase
endclass : dsel_smoke_test
/*************************************************************************************/
/**********************************Rand Test*****************************************/
/*************************************************************************************/
class dsel_rand_test extends dsel_base_test;
    dsel_rand_sequence dsel_rand_seq;
    `uvm_component_utils(dsel_rand_test)

    function new(string name ="dsel_rand_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

   task main_phase(uvm_phase phase); 
        `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
        phase.raise_objection(this);
        dsel_rand_seq = dsel_rand_sequence :: type_id :: create("dsel_rand_seq");
        dsel_rand_seq.start(dsel_env.vsqr);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
   endtask :main_phase
endclass : dsel_rand_test
/*************************************************************************************/
/**********************************Reset Test*****************************************/
/*************************************************************************************/
class dsel_reset_test extends dsel_base_test;
    dsel_rand_sequence dsel_rand_seq;
    `uvm_component_utils(dsel_reset_test)

    function new(string name ="dsel_reset_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    task run_phase(uvm_phase phase); 
        phase.raise_objection(this);
        repeat(100) @(posedge dsel_loc_vif.clk);
        dsel_loc_vif.force_reset_low();
        dsel_env.vsqr.loc_sqr.stop_sequences();
        rm.reset();
        phase.drop_objection(this);
    endtask : run_phase

    task main_phase(uvm_phase phase); 
         `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
         phase.raise_objection(this);
         dsel_rand_seq = dsel_rand_sequence :: type_id :: create("dsel_rand_seq");
         dsel_rand_seq.start(dsel_env.vsqr);
         phase.drop_objection(this);
         `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
    endtask :main_phase
endclass : dsel_reset_test

`endif //DSEL_TEST__SV
