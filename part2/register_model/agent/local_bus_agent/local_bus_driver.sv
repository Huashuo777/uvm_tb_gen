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
//     File for local_bus_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_DRIVER
`define LOCAL_BUS_DRIVER
class local_bus_driver extends uvm_driver #(local_bus_item);
    `uvm_component_utils(local_bus_driver)
    virtual local_bus_interface vif;

    extern                   function new(string name = "local_bus_driver",uvm_component parent = null);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern           virtual task main_phase(uvm_phase phase); 
    extern protected virtual task get_and_drive();
    extern protected virtual task reset_signal();
endclass : local_bus_driver

function local_bus_driver :: new(string name = "local_bus_driver",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void local_bus_driver :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction : connect_phase

task local_bus_driver :: main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(),"Starting main_phase...", UVM_LOW)
    reset_signal();
    forever
    begin
        wait(vif.reset_n);
        get_and_drive();
    end
endtask : main_phase

task local_bus_driver :: get_and_drive();

    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Get transaction:%0s", req.sprint()), UVM_LOW)
    @(vif.mcb)
    vif.mcb.addr    <= req.addr;
    vif.mcb.addr_en<= 1;
    vif.mcb.rw_direction<= bit'(req.direction);
    if (req.direction == WRITE)
    begin
        vif.mcb.wdata   <= req.data;
    end
    if (req.direction == READ) 
    begin
        @(vif.mcb);
        vif.mcb.addr_en  <= 1'b0;
        vif.mcb.rw_direction<= 1'b0;
        while(!vif.mcb.rvalid)
        begin
            @(vif.mcb);
        end
        req.data = vif.mcb.rdata;
    end
    @(vif.mcb);
    vif.mcb.addr_en  <= 1'b0;
    vif.mcb.rw_direction<= 1'b0;
    seq_item_port.item_done();
endtask : get_and_drive

task local_bus_driver :: reset_signal();
    vif.mcb.addr        <= 'h0;
    vif.mcb.addr_en   <= 'h0;
    vif.mcb.rw_direction<= 'h0;
    vif.mcb.wdata       <= 'h0;
    @(vif.mcb);
endtask : reset_signal

`endif //LOCAL_BUS_DRIVER
