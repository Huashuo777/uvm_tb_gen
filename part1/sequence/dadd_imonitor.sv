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
//     File for dadd_imonitor.sv                                                       
//----------------------------------------------------------------------------------
class dadd_imonitor extends uvm_monitor;
    `uvm_component_utils(dadd_imonitor)
    uvm_analysis_port #(dadd_item) ap;
    extern function new(string name ="dadd_imonitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_imonitor

function dadd_imonitor :: new(string name ="dadd_imonitor", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dadd_imonitor :: build_phase(uvm_phase phase);
    ap = new("ap",this);
endfunction : build_phase
task          dadd_imonitor :: reset_phase(uvm_phase phase);
    wait(tb_dadd.dadd_if.reset_n);
endtask : reset_phase

task          dadd_imonitor :: main_phase(uvm_phase phase);
    dadd_item item;
    fork
        forever 
        begin
            @(posedge tb_dadd.dadd_if.clk);
            if(tb_dadd.dadd_if.pcb.dadd_in_en)
            begin
                item = new();
                item.data_en = tb_dadd.dadd_if.pcb.dadd_in_en;
                item.data    = tb_dadd.dadd_if.pcb.dadd_in;
                item.addr    = tb_dadd.dadd_if.pcb.dadd_in_addr;
                ap.write(item);
            end
        end
        begin
            @(negedge tb_dadd.dadd_if.reset_n);
            phase.jump(uvm_reset_phase::get());
        end
    join
endtask: main_phase
