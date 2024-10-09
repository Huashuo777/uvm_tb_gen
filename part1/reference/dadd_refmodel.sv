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

    uvm_blocking_get_port #(dadd_item) port;

    extern function new(string name, uvm_component parent);
    extern task main_phase(uvm_phase phase);
    extern task get_dadd_pkt(output dadd_item item); 
endclass: dadd_refmodel

function dadd_refmodel :: new(string name, uvm_component parent);
    super.new(name, parent);
    port = new("port", this);
endfunction: new

task dadd_refmodel :: main_phase(uvm_phase phase);
    dadd_item item;
    while(1)
    begin
        get_dadd_pkt(item);
        item.data =item.data+ 1;
        $display("dadd_refmodel item.addr = %h, item.data = %h",item.addr,item.data);
    end
endtask: main_phase

task dadd_refmodel :: get_dadd_pkt(output dadd_item item); 
    dadd_item item_tmp;
    port.get(item_tmp);
    item = new item_tmp;
endtask : get_dadd_pkt
