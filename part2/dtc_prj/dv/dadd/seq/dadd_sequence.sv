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
//     File for dadd_sequence.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD__SEQUENCE__SV
`define DADD__SEQUENCE__SV
/*************************************************************************************/
/**********************************Base Sequence**************************************/
/*************************************************************************************/
class dadd_virtual_base_sequence extends uvm_sequence;
    dadd_env_config cfg;
    uvm_event_pool events;
    dadd_block rm;
    uvm_status_e status;
    uvm_reg_data_t data;
    virtual dadd_loc_interface vif;
    `uvm_object_utils(dadd_virtual_base_sequence)
    `uvm_declare_p_sequencer(dadd_virtual_sequencer)

    function new(string name = "dadd_virtual_base_sequence");
        super.new(name);
    endfunction : new

    task pre_start();
        `uvm_info(get_type_name(),"Starting task pre_start...", UVM_HIGH)
        cfg = p_sequencer.cfg;
        events = cfg.events;
        rm  = cfg.rm;
        vif = p_sequencer.vif;
        `uvm_info(get_type_name(),"Finish task pre_start...", UVM_HIGH)
    endtask

endclass : dadd_virtual_base_sequence
/*************************************************************************************/
/**********************************Smoke Sequence*************************************/
/*************************************************************************************/
class dadd_loc_smoke_sequence extends dadd_loc_base_sequence;
    `uvm_object_utils(dadd_loc_smoke_sequence)
    dadd_loc_item item;

    function new(string name = "dadd_loc_smoke_sequence");
        super.new(name);
    endfunction
    
    task body();
        if(starting_phase != null)
          starting_phase.raise_objection(this);
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        repeat(100) begin
          `uvm_do(item);
        end
        if(starting_phase != null)
          starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dadd_loc_smoke_sequence

class dadd_smoke_sequence extends dadd_virtual_base_sequence;
    `uvm_object_utils(dadd_smoke_sequence)
    uvm_event reg_cfg_fns_evt;
    dadd_loc_smoke_sequence dadd_loc_smoke_seq;

    function new(string name = "dadd_smoke_sequence");
        super.new(name);
    endfunction : new

    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        dadd_loc_smoke_seq = dadd_loc_smoke_sequence :: type_id :: create("dadd_loc_smoke_seq");
        reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");;
        if(starting_phase != null)
            starting_phase.raise_objection(this);

        #10ns;
        rm.dadd_reg.write(status,5'ha,UVM_FRONTDOOR);
        rm.dadd_reg.read(status,data);
        reg_cfg_fns_evt.trigger();        
        dadd_loc_smoke_seq.start(p_sequencer.loc_sqr);

        #1000ns;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
    
endclass : dadd_smoke_sequence

/*************************************************************************************/
/**********************************Rand Sequence*************************************/
/*************************************************************************************/

class dadd_loc_rand_sequence extends dadd_loc_base_sequence;
    `uvm_object_utils(dadd_loc_rand_sequence)
    dadd_loc_item item;

    function new(string name = "dadd_loc_rand_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        if(starting_phase != null)
          starting_phase.raise_objection(this);
        repeat(100) begin
          `uvm_do(item);
        end
        if(starting_phase != null)
          starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
endclass : dadd_loc_rand_sequence

class dadd_rand_sequence extends dadd_virtual_base_sequence;
    `uvm_object_utils(dadd_rand_sequence)
    bit         add_en_rand;
    bit [4:0]   add_value_rand;
    uvm_event reg_cfg_fns_evt;
    dadd_loc_rand_sequence dadd_loc_rand_seq;

    function new(string name = "dadd_rand_sequence");
        super.new(name);
    endfunction : new
    
    task body();
        `uvm_info(get_type_name(),"Starting task body...", UVM_HIGH)
        dadd_loc_rand_seq = dadd_loc_rand_sequence :: type_id :: create("dadd_loc_rand_seq");
        reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");;
        if(starting_phase != null)
            starting_phase.raise_objection(this);

        #10ns;
        std :: randomize(add_en_rand);
        std :: randomize(add_value_rand);
        rm.dadd_reg.write(status,{add_value_rand,add_en_rand},UVM_FRONTDOOR);
        rm.dadd_reg.read(status,data);
        reg_cfg_fns_evt.trigger();        
        dadd_loc_rand_seq.start(p_sequencer.loc_sqr);

        #1000ns;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
        `uvm_info(get_type_name(),"Finish task body...", UVM_HIGH)
    endtask : body
    
endclass : dadd_rand_sequence

`endif//DADD_SEQUENCE__SV
