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
//     File for apb_master_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_MONITOR__SV
`define APB_MASTER_MONITOR__SV
class apb_master_monitor extends uvm_monitor;
    virtual apb_master_interface vif;
    apb_master_config cfg;
    uvm_event_pool events;
    protected process processes[string];

    uvm_analysis_port #(apb_master_item) ap; 
    protected apb_master_item item_collected;

    `uvm_component_utils(apb_master_monitor)

    extern                   function new(string name ="apb_master_monitor", uvm_component parent);
    extern                   task run_phase(uvm_phase phase);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern protected virtual task collect_seq_item();
    extern protected virtual task wait_reset();
endclass : apb_master_monitor

function apb_master_monitor :: new(string name ="apb_master_monitor", uvm_component parent);
    super.new(name, parent);
    ap    = new("ap", this);
    item_collected = new();
endfunction : new

function void apb_master_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task apb_master_monitor :: run_phase(uvm_phase phase);
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

task apb_master_monitor :: collect_seq_item();
    apb_master_item item;
    `uvm_info(get_type_name(),"Starting task collect_seq_item...", UVM_HIGH)
    item = new();
    @(vif.pcb iff (vif.preset_n && vif.pcb.psel && vif.pcb.penable && vif.pcb.pready && !vif.pcb.pslverr));
    if(vif.pcb.pwrite)
    begin
        item.direction= WRITE;
        item.addr     = vif.pcb.paddr;
        item.data     = vif.pcb.pwdata;
    end
    else
    begin
        item.direction= READ;
        item.addr     = vif.pcb.paddr;
        item.data     = vif.pcb.prdata;
    end
    ap.write(item);
    `uvm_info("APB_MASTER_MON", $sformatf("collected sequence item is:%0s", item.sprint()), UVM_HIGH)
    `uvm_info(get_type_name(),"Finish task collect_seq_item...", UVM_HIGH)
endtask : collect_seq_item

task apb_master_monitor :: wait_reset();
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.preset_n);
        foreach (processes[i])
            processes[i].kill();
        @(posedge vif.preset_n);
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

`endif // APB_MASTER_MONITOR__SV
