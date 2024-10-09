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
//     File for dtc_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_SEQUENCE__SV
`define DTC_SEQUENCE__SV
/*************************************************************************************/
/**********************************Base Sequence**************************************/
/*************************************************************************************/
class dtc_virtual_base_sequence extends uvm_sequence;
    dtc_env_config cfg;
    virtual dtc_loc_interface vif;
    ral_top_block rm ;
    uvm_event_pool events;
    uvm_status_e status;
    uvm_reg_data_t data;

    `uvm_object_utils(dtc_virtual_base_sequence)
    `uvm_declare_p_sequencer(dtc_virtual_sequencer)

    function new(string name = "dtc_virtual_base_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        `uvm_info(get_type_name(),"Starting task pre_start...", UVM_HIGH)
        cfg = p_sequencer.cfg;
        vif = p_sequencer.vif;
        rm = cfg.rm;
        events = cfg.events;
        `uvm_info(get_type_name(),"Finish task pre_start...", UVM_HIGH)
    endtask

endclass : dtc_virtual_base_sequence
/*************************************************************************************/
/**********************************Smoke Sequence*************************************/
/*************************************************************************************/
class dtc_loc_smoke_sequence extends dtc_loc_base_sequence;
    `uvm_object_utils(dtc_loc_smoke_sequence)
    dtc_loc_item item;

    function new(string name = "dtc_loc_smoke_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        if(starting_phase != null)
          starting_phase.raise_objection(this);

        if(starting_phase != null)
          starting_phase.raise_objection(this);
        `uvm_create(item);
        item.randomize() with {
            addr_start == 0; 
            direction == 1;
            trans_num == 20;

        };
        `uvm_send(item);

        if(starting_phase != null)
          starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dtc_loc_smoke_sequence

class dtc_axi_master_write_smoke_sequence extends axi_master_sequence_base;
    `uvm_object_utils(dtc_axi_master_write_smoke_sequence)
    function new(string name = "dtc_axi_master_write_smoke_sequence"); 
        super.new(name);
    endfunction : new
    task body();
        axi_master_item item;
        axi_data_t w_data,r_data;
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        //write data
        `uvm_create(item);
        item.randomize with{
            addr_start == 0; 
            direction == 1;
            trans_num == 20;
        };
        `uvm_send(item);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dtc_axi_master_write_smoke_sequence

class dtc_axi_master_read_smoke_sequence extends axi_master_sequence_base;
    `uvm_object_utils(dtc_axi_master_read_smoke_sequence)
    function new(string name = "dtc_axi_master_read_smoke_sequence"); 
        super.new(name);
    endfunction : new
    task body();
        axi_master_item item;
        axi_data_t w_data,r_data;
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        //read data
        `uvm_create(item);
        item.randomize with{
            addr_start == 0; 
            direction == 0;
            trans_num == 13;
        };
        `uvm_send(item);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dtc_axi_master_read_smoke_sequence

class dtc_smoke_sequence extends dtc_virtual_base_sequence;
    `uvm_object_utils(dtc_smoke_sequence)
    uvm_event reg_cfg_fns_evt;
    dtc_loc_smoke_sequence dtc_loc_smoke_seq;
    dtc_axi_master_write_smoke_sequence dtc_axi_write_smoke_seq;
    dtc_axi_master_read_smoke_sequence dtc_axi_read_smoke_seq;

    function new(string name = "dtc_smoke_sequence");
        super.new(name);
    endfunction : new

    task body();
        reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        dtc_loc_smoke_seq = dtc_loc_smoke_sequence :: type_id :: create("dtc_loc_smoke_seq");
        dtc_axi_write_smoke_seq = dtc_axi_master_write_smoke_sequence :: type_id :: create("dtc_axi_write_smoke_seq");
        dtc_axi_read_smoke_seq = dtc_axi_master_read_smoke_sequence :: type_id :: create("dtc_axi_read_smoke_seq");

        if(starting_phase != null)
            starting_phase.raise_objection(this);
        rm.dadd_blk.dadd_reg.dadd_en_field.set(1'h1);
        rm.dadd_blk.dadd_reg.daddend_value_field.set(5'h2);
        rm.dsel_blk.dsel_reg.channel_sel_field.set(1'h1);
        rm.dsel_blk.dsel_reg.data_inv_field.set(1'h1);
        rm.update(status,UVM_FRONTDOOR);
        reg_cfg_fns_evt.trigger();        
        fork
            dtc_axi_write_smoke_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
            dtc_loc_smoke_seq.start(p_sequencer.loc_sqr);
        join
        dtc_axi_read_smoke_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);

        #1000ns;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
    
endclass : dtc_smoke_sequence
/*************************************************************************************/
/**********************************Rand Sequence*************************************/
/*************************************************************************************/
class dtc_loc_rand_sequence extends dtc_loc_base_sequence;
    `uvm_object_utils(dtc_loc_rand_sequence)
    dtc_loc_item item;

    function new(string name = "dtc_loc_rand_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        if(starting_phase != null)
          starting_phase.raise_objection(this);

        if(starting_phase != null)
          starting_phase.raise_objection(this);
        `uvm_create(item);
        item.randomize() with {
            addr_start == 0; 
            direction == 1;
            trans_num == 20;

        };
        `uvm_send(item);

        if(starting_phase != null)
          starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dtc_loc_rand_sequence

class dtc_axi_master_write_rand_sequence extends axi_master_sequence_base;
    `uvm_object_utils(dtc_axi_master_write_rand_sequence)
    function new(string name = "dtc_axi_master_write_rand_sequence"); 
        super.new(name);
    endfunction : new
    task body();
        axi_master_item item;
        axi_data_t w_data,r_data;
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        //write data
        `uvm_create(item);
        item.randomize with{
            addr_start == 0; 
            direction == 1;
            trans_num == 20;
        };
        `uvm_send(item);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dtc_axi_master_write_rand_sequence

class dtc_axi_master_read_rand_sequence extends axi_master_sequence_base;
    `uvm_object_utils(dtc_axi_master_read_rand_sequence)
    function new(string name = "dtc_axi_master_read_rand_sequence"); 
        super.new(name);
    endfunction : new
    task body();
        axi_master_item item;
        axi_data_t w_data,r_data;
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        //read data
        `uvm_create(item);
        item.randomize with{
            addr_start == 0; 
            direction == 0;
            trans_num == 20;
        };
        `uvm_send(item);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dtc_axi_master_read_rand_sequence


class dtc_rand_sequence extends dtc_virtual_base_sequence;
    `uvm_object_utils(dtc_rand_sequence)
    uvm_event reg_cfg_fns_evt;
    dtc_loc_rand_sequence dtc_loc_rand_seq;
    dtc_axi_master_write_rand_sequence dtc_axi_write_rand_seq;
    dtc_axi_master_read_rand_sequence dtc_axi_read_rand_seq;

    function new(string name = "dtc_rand_sequence");
        super.new(name);
    endfunction : new

    task body();
        uvm_event axi_trans_fns_evt = events.get($sformatf("%s_trans_fns_evt", cfg.axi_mst_cfg.get_name()));
        reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        dtc_loc_rand_seq = dtc_loc_rand_sequence :: type_id :: create("dtc_loc_rand_seq");
        dtc_axi_write_rand_seq = dtc_axi_master_write_rand_sequence :: type_id :: create("dtc_axi_write_rand_seq");
        dtc_axi_read_rand_seq = dtc_axi_master_read_rand_sequence :: type_id :: create("dtc_axi_read_rand_seq");

        if(starting_phase != null)
            starting_phase.raise_objection(this);
        //assert(rm.randomize());
        rm.dadd_blk.dadd_reg.dadd_en_field.set(1'h1);
        rm.dadd_blk.dadd_reg.daddend_value_field.set(5'h2);
        rm.dsel_blk.dsel_reg.channel_sel_field.set(1'h1);
        rm.dsel_blk.dsel_reg.data_inv_field.set(1'h0);
        rm.update(status,UVM_FRONTDOOR);
        reg_cfg_fns_evt.trigger();        
        fork
            dtc_axi_write_rand_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
            dtc_loc_rand_seq.start(p_sequencer.loc_sqr);
        join
        axi_trans_fns_evt.wait_trigger();
        dtc_axi_read_rand_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
        axi_trans_fns_evt.wait_trigger();

        #1000ns;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
    
endclass : dtc_rand_sequence

`endif//DTC_SEQUENCE__SV
