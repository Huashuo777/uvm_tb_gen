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
//     File for dadd_omonitor.sv                                                       
//----------------------------------------------------------------------------------
class dadd_omonitor extends uvm_monitor;
    `uvm_component_utils(dadd_omonitor)
    uvm_event an_event;
    uvm_event_pool event_pool;
    virtual dadd_interface vif;
    uvm_analysis_port #(dadd_item) ap;
    extern function new(string name ="dadd_omonitor", uvm_component parent = null);
    extern task          reset_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_omonitor

function dadd_omonitor :: new(string name ="dadd_omonitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap",this);
endfunction: new

task          dadd_omonitor :: reset_phase(uvm_phase phase);
    wait(vif.reset_n);
endtask : reset_phase

task          dadd_omonitor :: main_phase(uvm_phase phase);
    dadd_item item;
    bit [31:0] pkt_cnt;
    bit [31:0] pre_cnt;
    an_event = event_pool.get("an_event");

    fork
        forever 
        begin
            @(posedge vif.clk);
            if(vif.pcb.dadd_out_en)
            begin
                item = new();
                item.data_en = vif.pcb.dadd_out_en;
                item.data    = vif.pcb.dadd_out;
                item.addr    = vif.pcb.dadd_out_addr;
                ap.write(item);
                pkt_cnt ++ ;
            end
        end
        begin
            wait(vif.pcb.dadd_out_en);
            forever //Control simulation finish  
            begin
                pre_cnt = pkt_cnt;
                repeat(10) @(posedge tb_dadd.dadd_if.clk);
                if(pre_cnt == pkt_cnt)
                begin
                    an_event.trigger();
                end
            end
        end
    join
endtask: main_phase
