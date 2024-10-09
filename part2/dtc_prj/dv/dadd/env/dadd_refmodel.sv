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
//     File for dadd_refmodel.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_REFMODEL__SV
`define DADD_REFMODEL__SV
class dadd_refmodel extends uvm_component;

    dadd_block rm;
    uvm_blocking_get_port #(dadd_loc_item) dadd_loc_port;
    uvm_analysis_port     #(dadd_loc_item) dadd_loc_ap;

    dadd_env_config cfg;
    uvm_event_pool events;
    bit       add_en;
    bit [4:0] addend_val;
    `uvm_component_utils(dadd_refmodel)

    extern           function new(string name, uvm_component parent);
    extern           virtual function void build_phase(uvm_phase phase);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern           virtual task main_phase(uvm_phase phase);
    extern protected virtual task get_dadd_loc_pkt(output dadd_loc_item item); 
endclass: dadd_refmodel

function dadd_refmodel :: new(string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_refmodel :: build_phase(uvm_phase phase);
    super.build_phase(phase);

    dadd_loc_port = new("dadd_loc_port", this);
    dadd_loc_ap   = new("dadd_loc_ap",   this);

endfunction: build_phase

function void dadd_refmodel :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
    rm = cfg.rm;
endfunction : connect_phase

task dadd_refmodel :: main_phase(uvm_phase phase);
    dadd_loc_item dadd_item;
    uvm_event reg_cfg_fns_evt;
    reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");;
    `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
    reg_cfg_fns_evt.wait_trigger();
    forever
    begin
        get_dadd_loc_pkt(dadd_item);
        add_en = rm.dadd_reg.dadd_en_field.get();
        addend_val = rm.dadd_reg.daddend_value_field.get();
        if(add_en)
        begin
            dadd_item.data = dadd_item.data+ addend_val;
            $display("add_en  = %h,addend_val = %h",add_en,addend_val);
        end
        dadd_loc_ap.write(dadd_item);
    end
    `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
endtask: main_phase

task dadd_refmodel :: get_dadd_loc_pkt(output dadd_loc_item item); 
    dadd_loc_item item_tmp;
    `uvm_info(get_type_name(),"Starting task get_dadd_loc_pkt...", UVM_HIGH)
    while(1)
    begin
        dadd_loc_port.get(item_tmp);
        if(item_tmp.direction == DADD_LOC_WRITE)
        begin
            item = new item_tmp;
            break;
        end
    end
    `uvm_info(get_type_name(),"Finish task get_dadd_loc_pkt...", UVM_HIGH)
endtask : get_dadd_loc_pkt

`endif // DADD_REFMODEL__SV
