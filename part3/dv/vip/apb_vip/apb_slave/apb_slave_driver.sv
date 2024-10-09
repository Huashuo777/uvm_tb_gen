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
//     File for apb_slave_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_DRIVER__SV
`define APB_SLAVE_DRIVER__SV
class apb_slave_driver extends uvm_driver#(apb_slave_item);
    `uvm_component_utils(apb_slave_driver)
    virtual apb_slave_interface vif;
    apb_slave_config cfg;
    uvm_event_pool events;
    protected process processes[string];
    protected apb_slave_memory m_mem;

    extern                   function new(string name = "apb_slave_driver",uvm_component parent = null);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern           virtual task run_phase(uvm_phase phase); 
    extern protected virtual task get_and_drive();
    extern protected virtual task reset_signal();
    extern protected virtual task wait_reset();
    extern protected virtual function void init_mem();
endclass : apb_slave_driver

function apb_slave_driver :: new(string name = "apb_slave_driver",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void apb_slave_driver :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task apb_slave_driver :: run_phase(uvm_phase phase);
    process proc_drive;
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Starting task run_phase...", UVM_HIGH)
    reset_signal();
    init_mem();
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

task apb_slave_driver :: get_and_drive();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task get_and_drive...", UVM_HIGH)

    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Get transaction:%0s", req.sprint()), UVM_HIGH)
    get_req_evt.trigger();
    wait(vif.scb.psel === 1'b1);
    req.addr =vif.scb.paddr;
    req.direction = apb_direction_e'(vif.scb.pwrite);
    vif.scb.pready <= 1'b0;
    repeat(req.wait_ready_cycle) @(posedge vif.pclk);
    vif.scb.pready <= 1'b1;
    if (req.direction == WRITE) begin
        req.data = vif.scb.pwdata;
        m_mem.write(req.addr,req.data);
    end
    else if(req.direction == READ)
    begin
        apb_data_t data;
        m_mem.read(req.addr,data);
        vif.scb.prdata <= data;
        req.data = data;
    end
    else
    begin
        vif.scb.prdata <= 0;
        req.data = 0;
    end
    if(req.response == ERROR)
    begin
        vif.scb.pslverr <= 1'b1;
    end
    @(posedge vif.pclk);
    vif.scb.pslverr <= 1'b0;
    seq_item_port.item_done();
    get_req_evt.reset();
    `uvm_info(get_type_name(),"Finish task get_and_drive...", UVM_HIGH)
endtask : get_and_drive

task apb_slave_driver :: reset_signal();
    vif.scb.prdata  <= 'h0;
    vif.scb.pready  <= 'h0;
    vif.scb.pslverr <= 'h0;
endtask : reset_signal

task apb_slave_driver :: wait_reset();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.preset_n);
        `uvm_warning("wait reset",$sformatf("Reset signal is asserted in time %t",$time));
        if(get_req_evt.is_on())
            seq_item_port.item_done();
        foreach (processes[i])
            processes[i].kill();
        reset_signal();
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

function void apb_slave_driver :: init_mem();
    if(!uvm_config_db #(apb_slave_memory) :: get(null,get_full_name(),"mem",m_mem))
    begin
        m_mem = new();
    end
endfunction : init_mem

`endif //APB_SLAVE_DRIVER__SV
