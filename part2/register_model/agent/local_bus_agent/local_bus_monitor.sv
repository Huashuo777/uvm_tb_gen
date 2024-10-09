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
//     File for local_bus_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_MONITOR__SV
`define LOCAL_BUS_MONITOR__SV
class local_bus_monitor extends uvm_monitor;
    virtual local_bus_interface vif;

    uvm_analysis_port #(local_bus_item) ap; 
    protected local_bus_item item_collected;

    `uvm_component_utils(local_bus_monitor)

    extern                   function new(string name ="local_bus_monitor", uvm_component parent);
    extern                   task main_phase(uvm_phase phase);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern protected virtual task collect_seq_item();
endclass : local_bus_monitor

function local_bus_monitor :: new(string name ="local_bus_monitor", uvm_component parent);
    super.new(name, parent);
    ap    = new("ap", this);
    item_collected = new();
endfunction : new

function void local_bus_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction : connect_phase

task local_bus_monitor :: main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"Starting main_phase...", UVM_HIGH)
    forever
    begin
        wait(vif.reset_n);
        collect_seq_item();
    end
endtask : main_phase

task local_bus_monitor :: collect_seq_item();
    local_bus_item item;
    item = new();
    @(vif.pcb iff (vif.reset_n && vif.pcb.addr_en));
    if(vif.pcb.rw_direction)
    begin
        item.direction= WRITE;
        item.addr     = vif.pcb.addr;
        item.data     = vif.pcb.wdata;
    end
    else
    begin
        @(vif.pcb);
        item.direction= READ;
        item.addr     = vif.pcb.addr;
        while(!vif.mcb.rvalid)
        begin
            @(vif.mcb);
        end
        item.data     = vif.pcb.rdata;
    end
    ap.write(item);
    `uvm_info("LOCAL_BUS_MON", $sformatf("collected sequence item is:%0s", item.sprint()), UVM_LOW)
endtask : collect_seq_item

`endif // LOCAL_BUS_MONITOR__SV
