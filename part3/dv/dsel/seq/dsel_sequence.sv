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
//     File for dsel_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_SEQUENCE__SV
`define DSEL_SEQUENCE__SV
/*************************************************************************************/
/**********************************Base Sequence**************************************/
/*************************************************************************************/
class dsel_virtual_base_sequence extends uvm_sequence;
    dsel_block rm;
    dsel_env_config cfg;
    uvm_event_pool events;
    uvm_status_e status; 
    uvm_reg_data_t data; 
    virtual dsel_loc_interface vif;

    `uvm_object_utils(dsel_virtual_base_sequence)
    `uvm_declare_p_sequencer(dsel_virtual_sequencer)

    function new(string name = "dsel_virtual_base_sequence");
        super.new(name);
    endfunction : new

    virtual task pre_start();
        `uvm_info(get_type_name(),"Starting task pre_start...", UVM_HIGH)
        cfg = p_sequencer.cfg;
        vif = p_sequencer.vif;
        events = cfg.events;
        rm =cfg.rm;
        `uvm_info(get_type_name(),"Finish task pre_start...", UVM_HIGH)
    endtask : pre_start
    
endclass : dsel_virtual_base_sequence
/*************************************************************************************/
/**********************************Smoke Sequence*************************************/
/*************************************************************************************/
class dsel_loc_smoke_sequence extends dsel_loc_base_sequence;
    `uvm_object_utils(dsel_loc_smoke_sequence)
    dsel_loc_item item;

    function new(string name = "dsel_loc_smoke_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
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
endclass : dsel_loc_smoke_sequence

class axi_master_write_smoke_sequence extends axi_master_sequence_base;
    `uvm_object_utils(axi_master_write_smoke_sequence)
    function new(string name = "axi_master_write_smoke_sequence"); 
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
endclass : axi_master_write_smoke_sequence

class axi_master_read_smoke_sequence extends axi_master_sequence_base;
    `uvm_object_utils(axi_master_read_smoke_sequence)
    function new(string name = "axi_master_read_smoke_sequence"); 
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
endclass : axi_master_read_smoke_sequence

class dsel_smoke_sequence extends dsel_virtual_base_sequence;
    `uvm_object_utils(dsel_smoke_sequence)
    uvm_event reg_cfg_fns_evt;
    axi_master_write_smoke_sequence axi_write_smoke_seq;
    axi_master_read_smoke_sequence axi_read_smoke_seq;
    dsel_loc_smoke_sequence dsel_loc_smoke_seq;

    function new(string name = "dsel_smoke_sequence");
        super.new(name);
    endfunction : new

    task body();
        uvm_event axi_trans_fns_evt = events.get($sformatf("%s_trans_fns_evt", cfg.axi_mst_cfg.get_name()));
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");
        axi_write_smoke_seq = axi_master_write_smoke_sequence :: type_id :: create("axi_write_smoke_seq");
        axi_read_smoke_seq = axi_master_read_smoke_sequence :: type_id :: create("axi_read_smoke_seq");
        dsel_loc_smoke_seq = dsel_loc_smoke_sequence :: type_id :: create("dsel_loc_smoke_seq");
        if(starting_phase != null)
            starting_phase.raise_objection(this);

        #10ns;
        rm.dsel_reg.write(status,2'h3,UVM_FRONTDOOR);
        rm.dsel_reg.read(status,data);
        reg_cfg_fns_evt.trigger();        
        fork
            axi_write_smoke_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
            dsel_loc_smoke_seq.start(p_sequencer.loc_sqr);
        join
        axi_trans_fns_evt.wait_trigger();
        axi_read_smoke_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
        axi_trans_fns_evt.wait_trigger();

        #1000ns;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
    
endclass : dsel_smoke_sequence

/*************************************************************************************/
/**********************************Direct Sequence*************************************/
/*************************************************************************************/
class dsel_loc_rand_sequence extends dsel_loc_base_sequence;
    `uvm_object_utils(dsel_loc_rand_sequence)
    dsel_loc_item item;

    function new(string name = "dsel_loc_rand_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
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
endclass : dsel_loc_rand_sequence

class axi_master_write_rand_sequence extends axi_master_sequence_base;
    `uvm_object_utils(axi_master_write_rand_sequence)
    function new(string name = "axi_master_write_rand_sequence"); 
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
endclass : axi_master_write_rand_sequence

class axi_master_read_rand_sequence extends axi_master_sequence_base;
    `uvm_object_utils(axi_master_read_rand_sequence)
    function new(string name = "axi_master_read_rand_sequence"); 
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
            burst_num == 20;
        };
        `uvm_send(item);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : axi_master_read_rand_sequence


class dsel_rand_sequence extends dsel_virtual_base_sequence;
    `uvm_object_utils(dsel_rand_sequence)
    bit channel_sel;
    bit data_inv;
    uvm_event reg_cfg_fns_evt;
    axi_master_write_rand_sequence axi_write_rand_seq;
    axi_master_read_rand_sequence axi_read_rand_seq;
    dsel_loc_rand_sequence dsel_loc_rand_seq;

    function new(string name = "dsel_rand_sequence");
        super.new(name);
    endfunction : new

    task body();
        uvm_event axi_trans_fns_evt = events.get($sformatf("%s_trans_fns_evt", cfg.axi_mst_cfg.get_name()));
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");
        axi_write_rand_seq = axi_master_write_rand_sequence :: type_id :: create("axi_write_rand_seq");
        axi_read_rand_seq = axi_master_read_rand_sequence :: type_id :: create("axi_read_rand_seq");
        dsel_loc_rand_seq = dsel_loc_rand_sequence :: type_id :: create("dsel_loc_rand_seq");
        if(starting_phase != null)
            starting_phase.raise_objection(this);

        #10ns;
        std :: randomize(channel_sel);
        std :: randomize(data_inv);
        rm.dsel_reg.write(status,{data_inv,channel_sel},UVM_FRONTDOOR);
        rm.dsel_reg.read(status,data);
        reg_cfg_fns_evt.trigger();        
        fork
            axi_write_rand_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
            dsel_loc_rand_seq.start(p_sequencer.loc_sqr);
        join
        axi_trans_fns_evt.wait_trigger();
        axi_read_rand_seq.start(p_sequencer.axi_vsqr.mst_sqr[0]);
        axi_trans_fns_evt.wait_trigger();

        #1000ns;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
    
endclass : dsel_rand_sequence

`endif//DSEL_SEQUENCE__SV
