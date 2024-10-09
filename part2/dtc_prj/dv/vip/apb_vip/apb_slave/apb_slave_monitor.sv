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
//     File for apb_slave_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_MONITOR__SV
`define APB_SLAVE_MONITOR__SV
class apb_slave_monitor extends uvm_monitor;
    virtual apb_slave_interface vif;
    apb_slave_config cfg;
    uvm_event_pool events;
    protected process processes[string];

    uvm_analysis_port #(apb_slave_item) ap; 
    protected apb_slave_item item_collected;

    `uvm_component_utils(apb_slave_monitor)

    extern                   function new(string name ="apb_slave_monitor", uvm_component parent);
    extern                   task run_phase(uvm_phase phase);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern protected virtual task collect_seq_item();
    extern protected virtual task wait_reset();
endclass : apb_slave_monitor

function apb_slave_monitor :: new(string name ="apb_slave_monitor", uvm_component parent);
    super.new(name, parent);
    ap    = new("ap", this);
    item_collected = new();
endfunction : new

function void apb_slave_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task apb_slave_monitor :: run_phase(uvm_phase phase);
    process proc_monitor;
    `uvm_info(get_type_name(),"Starting task run_phase...", UVM_HIGH)
    fork
        forever
        begin
            wait(vif.preset_n);
            fork
                begin
                    proc_monitor = process::self();
                    processes["proc_monitor"] = proc_monitor;
                    collect_seq_item();
                end
            join
        end
        wait_reset();
    join
    `uvm_info(get_type_name(),"Finish task run_phase...", UVM_HIGH)
endtask : run_phase

task apb_slave_monitor :: collect_seq_item();
    apb_slave_item item;
    `uvm_info(get_type_name(),"Starting task collect_seq_item...", UVM_HIGH)
    item = new();
    while(vif.pcb.psel !== 1'b1)
        @(posedge vif.pclk)
    item.addr = vif.pcb.paddr;
    item.direction = apb_direction_e'(vif.pcb.pwrite);
    if(item.direction == WRITE)
        item.data = vif.pcb.pwdata;
    while(vif.pcb.penable !== 1'b1)
        @(posedge vif.pclk)
    while(vif.pcb.pready !== 1'b1)
        @(posedge vif.pclk)
    if(item.direction == READ)
        item.data = vif.pcb.prdata;
    ap.write(item);
    `uvm_info("APB_SLAVE_MON", $sformatf("collected sequence item is:%0s", item.sprint()), UVM_HIGH)
    @(posedge vif.pclk) ;
    `uvm_info(get_type_name(),"Finish task collect_seq_item...", UVM_HIGH)
endtask : collect_seq_item

task apb_slave_monitor :: wait_reset();
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.preset_n);
        foreach (processes[i])
            processes[i].kill();
        @(posedge vif.preset_n);
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

`endif // APB_SLAVE_MONITOR__SV
