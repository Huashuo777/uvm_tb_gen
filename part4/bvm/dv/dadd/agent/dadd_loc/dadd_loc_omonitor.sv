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
//     File for dadd_loc_omonitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_OMONITOR__SV
`define DADD_LOC_OMONITOR__SV
class dadd_loc_omonitor extends bvm_monitor;
    virtual dadd_loc_interface vif;


    `bvm_component_utils(dadd_loc_omonitor)

    extern  function new(string name ="dadd_loc_omonitor", bvm_component parent);
    extern  task run_phase();
    extern  task collect_input_item();
    extern  task collect_item();
endclass: dadd_loc_omonitor

function dadd_loc_omonitor :: new(string name ="dadd_loc_omonitor", bvm_component parent);
    super.new(name, parent);
endfunction: new

task dadd_loc_omonitor :: run_phase();
    forever
    begin
        wait(vif.reset_n);
        collect_item();
    end
endtask: run_phase

task dadd_loc_omonitor :: collect_item();
    dadd_loc_item tr;
    @(posedge vif.clk);
    if(vif.pcb.dadd_out_en) begin
        tr = new();
        tr.data = vif.pcb.dadd_out;
        tr.addr= vif.pcb.dadd_out_addr;
        omon2scb_box.put(tr);
    end
endtask: collect_item

`endif // DADD_LOC_OMONITOR__SV
