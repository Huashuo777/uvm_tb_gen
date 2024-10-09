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
class dadd_refmodel extends uvm_component;
    `uvm_component_utils(dadd_refmodel)

    uvm_analysis_port #(dadd_item) ap;
    uvm_blocking_get_port #(dadd_item) port;

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
    extern task get_dadd_pkt(output dadd_item item); 
endclass: dadd_refmodel

function dadd_refmodel :: new(string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

task dadd_refmodel :: get_dadd_pkt(output dadd_item item); 
    dadd_item item_tmp;
    port.get(item_tmp);
    item = new item_tmp;
endtask : get_dadd_pkt

function void dadd_refmodel :: build_phase(uvm_phase phase);
    ap = new("ap",this);
    port = new("port", this);
    uvm_config_db#(string)::set(uvm_root::get(),"*","use_uvm_root_get_same_level_set","Config_db use \"uvm_root::get(),same level set\",This is dadd_refmodel"); 
    //uvm_config_db#(string)::set(this,"*","use_this_same_level_set","Config_db use \"this,same level set\",This is dadd_refmodel"); 
endfunction : build_phase

task          dadd_refmodel :: main_phase(uvm_phase phase);
    dadd_item item;
    while(1)
    begin
        get_dadd_pkt(item);
        item.data =item.data+ 1;
        ap.write(item);
    end
endtask: main_phase
