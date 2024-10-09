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
//     File for dadd_sequencer.sv                                                       
//----------------------------------------------------------------------------------
class dadd_sequencer extends uvm_sequencer #(dadd_item);
    `uvm_component_utils(dadd_sequencer)
    uvm_blocking_get_port #(cfg_item) port;
    cfg_item cfg_que[$];
    extern function new(string name ="dadd_sequencer", uvm_component parent);
    extern task          main_phase(uvm_phase phase);
    extern task          get_cfg_pkt(output cfg_item item);
endclass: dadd_sequencer

function dadd_sequencer :: new(string name ="dadd_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction: new

task dadd_sequencer :: get_cfg_pkt(output cfg_item item); 
    cfg_item item_tmp;
    port.get(item_tmp);
    item = new item_tmp;
endtask : get_cfg_pkt

task  dadd_sequencer :: main_phase(uvm_phase phase);
    cfg_item item;
    while(1)
    begin
        get_cfg_pkt(item);
        cfg_que.push_back(item);
    end
endtask : main_phase
