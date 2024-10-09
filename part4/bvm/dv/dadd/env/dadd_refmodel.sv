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
class dadd_refmodel extends bvm_component;

    `bvm_component_utils(dadd_refmodel)

    extern         function new(string name, bvm_component parent);
    extern         function void build_phase();
    extern         task run_phase();
    extern virtual task get_dadd_loc_pkt(output dadd_loc_item item); 
endclass: dadd_refmodel

function dadd_refmodel :: new(string name, bvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_refmodel :: build_phase();
    super.build_phase();

endfunction: build_phase

task dadd_refmodel :: run_phase();
    dadd_loc_item item;
    while(1)
    begin
        get_dadd_loc_pkt(item);
        item.data =item.data+ 1;
        ref2scb_box.put(item);
    end
endtask: run_phase

task dadd_refmodel :: get_dadd_loc_pkt(output dadd_loc_item item); 
    dadd_loc_item item_tmp;
    bvm_sequence_item bvm_item;
    imon2ref_box.get(bvm_item);
    $cast(item_tmp,bvm_item);
    item = new item_tmp;
endtask : get_dadd_loc_pkt

`endif // DADD_REFMODEL__SV
