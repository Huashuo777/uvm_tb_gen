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
//     File for dtc_loc_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_MONITOR__SV
`define DTC_LOC_MONITOR__SV
class dtc_loc_monitor extends uvm_monitor;
    virtual dtc_loc_interface vif;
    dtc_loc_config cfg;
    uvm_event_pool events;
    uvm_analysis_port #(dtc_loc_item) ap; 

    `uvm_component_utils(dtc_loc_monitor)

    extern                      function    new(string name ="dtc_loc_monitor", uvm_component parent);
    extern              virtual function void connect_phase(uvm_phase phase);
    extern              virtual task        main_phase(uvm_phase phase);
    extern  protected   virtual task        collect_input_item();
endclass: dtc_loc_monitor

function dtc_loc_monitor :: new(string name ="dtc_loc_monitor", uvm_component parent);
    super.new(name, parent);
    ap    = new("ap", this);
endfunction: new

function void dtc_loc_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
    vif = cfg.vif;
endfunction : connect_phase

task dtc_loc_monitor :: main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
    fork
        collect_input_item();
        begin
            @(negedge vif.reset_n);
            phase.jump(uvm_reset_phase::get());
        end                                                                                                                                                                                                                       
    join
    `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
endtask: main_phase

task dtc_loc_monitor :: collect_input_item();
    dtc_loc_item item;
    `uvm_info(get_type_name(),"Starting task collect_input_item...", UVM_HIGH)
    @(posedge vif.clk);
    if(vif.pcb.dadd_in_en) begin
        item = new();
        item.direction = DTC_LOC_WRITE;   
        item.c_data = vif.pcb.dadd_in;
        item.c_addr= vif.pcb.dadd_in_addr;
        ap.write(item);
    end
    `uvm_info(get_type_name(),"Finish task collect_input_item...", UVM_HIGH)
endtask: collect_input_item

`endif // DTC_LOC_MONITOR__SV
