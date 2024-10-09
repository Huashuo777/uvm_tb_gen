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
//     File for apb_master_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_DRIVER__SV
`define APB_MASTER_DRIVER__SV
class apb_master_driver extends uvm_driver #(apb_master_item);
    `uvm_component_utils(apb_master_driver)
    virtual apb_master_interface vif;
    apb_master_config cfg;
    uvm_event_pool events;
    protected process processes[string];

    extern                   function new(string name = "apb_master_driver",uvm_component parent = null);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern           virtual task run_phase(uvm_phase phase); 
    extern protected virtual task get_and_drive();
    extern protected virtual task reset_signal();
    extern protected virtual task wait_reset();
endclass : apb_master_driver

function apb_master_driver :: new(string name = "apb_master_driver",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void apb_master_driver :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task apb_master_driver :: run_phase(uvm_phase phase);
    process proc_drive;
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Starting task run_phase...", UVM_HIGH)
    reset_signal();
    forever
    begin
        fork
            forever
            begin
                wait(vif.preset_n);
                proc_drive = process::self();
                processes["proc_drive"] = proc_drive;
                get_and_drive();
            end
            wait_reset();
        join_any
        disable fork;
    end
    `uvm_info(get_type_name(),"Finish task run_phase...", UVM_HIGH)
endtask : run_phase

task apb_master_driver :: get_and_drive();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task get_and_drive...", UVM_HIGH)

    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Get transaction:%0s", req.sprint()), UVM_HIGH)
    get_req_evt.trigger();
    @(vif.mcb)
    vif.mcb.paddr    <= req.addr;
    vif.mcb.pwrite   <= bit'(req.direction);
    vif.mcb.psel     <= 1'b1;
    if (req.direction == WRITE)
        vif.mcb.pwdata   <= req.data;
    @(vif.mcb)
    vif.mcb.penable  <= 1'b1;
    @(vif.mcb)
    while(vif.mcb.pready !== 1'b1) begin
        @(vif.mcb);
    end
    if (req.direction == READ) begin
        req.data = vif.mcb.prdata;
    end
    vif.mcb.psel     <= 1'b0;
    vif.mcb.penable  <= 1'b0;
    vif.mcb.pwrite   <= 1'b0;
    vif.mcb.paddr    <= 'h0;
    vif.mcb.pwdata   <= 'h0;
    seq_item_port.item_done();
    get_req_evt.reset();
    `uvm_info(get_type_name(),"Finish task get_and_drive...", UVM_HIGH)
endtask : get_and_drive

task apb_master_driver :: reset_signal();
    vif.mcb.paddr   <= 'h0;
    vif.mcb.penable <= 'h0;
    vif.mcb.pwrite  <= 'h0;
    vif.mcb.pwdata  <= 'h0;
    vif.mcb.psel    <= 'h0;
    @(vif.mcb);
endtask : reset_signal

task apb_master_driver :: wait_reset();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.preset_n);
        `uvm_warning("wait reset",$sformatf("Reset signal is asserted in time %t",$time));
        if(get_req_evt.is_on())
        begin
            seq_item_port.item_done();
        end
        foreach (processes[i])
            processes[i].kill();
        reset_signal();
        break;
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

`endif //APB_MASTER_DRIVER__SV
