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
//     File for axi_master_monitor.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_MONITOR__SV
`define AXI_MASTER_MONITOR__SV
class axi_master_monitor extends uvm_monitor;
    bit w_is_start_addr=1;
    bit [7:0] w_number_bytes;
    axi_addr_t w_pre_addr;
    bit r_is_start_addr=1;
    bit [7:0] r_number_bytes;
    axi_addr_t r_pre_addr;
    waddr_info_s waddr_info_q[$];  
    waddr_info_s waddr_info_id_jdg_q[$];  
    raddr_info_s raddr_info_q[$];  
    wdata_info_s wdata_info_q[$];
    rdata_info_s rdata_info_q[$];
    wresp_info_s wresp_info_q[$];
    virtual axi_master_interface vif;
    axi_master_config cfg;
    uvm_event_pool events;
    protected process processes[string];

    uvm_analysis_port #(axi_master_item) ap; 
    protected axi_master_item item_collected;

    `uvm_component_utils(axi_master_monitor)

    extern                   function new(string name ="axi_master_monitor", uvm_component parent);
    extern                   task run_phase(uvm_phase phase);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern protected virtual task collect_seq_item();
    extern protected virtual task collect_axi_write_addr();
    extern protected virtual task collect_axi_write_data();
    extern protected virtual task collect_axi_write_resp();
    extern protected virtual task collect_axi_read_addr();
    extern protected virtual task collect_axi_read_data();
    extern protected virtual task write_cal_and_put();
    extern protected virtual task read_cal_and_put();
    extern protected virtual task write_response_id_judge();
    extern protected virtual task reset_global_val();
    extern protected virtual task wait_reset();
endclass : axi_master_monitor

function axi_master_monitor :: new(string name ="axi_master_monitor", uvm_component parent);
    super.new(name, parent);
    ap    = new("ap", this);
    item_collected = new();
endfunction : new

function void axi_master_monitor :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task axi_master_monitor :: run_phase(uvm_phase phase);
    process proc_monitor;
    `uvm_info(get_type_name(),"Starting task run_phase...", UVM_HIGH)
    forever 
    begin
        reset_global_val();
        wait(vif.areset_n);
        @(vif.pcb);
        fork
            forever
            begin
                proc_monitor = process::self();
                processes["proc_monitor"] = proc_monitor;
                collect_seq_item();
            end
            wait_reset();
        join_any
        disable fork;
    end
    `uvm_info(get_type_name(),"Finish task run_phase...", UVM_HIGH)
endtask : run_phase

task axi_master_monitor :: collect_seq_item();
    `uvm_info(get_type_name(),"Starting task collect_seq_item...", UVM_HIGH)
    fork
        forever collect_axi_write_addr();
        forever collect_axi_write_data();
        forever collect_axi_write_resp();
        forever write_cal_and_put();
        forever collect_axi_read_addr();
        forever collect_axi_read_data();
        forever read_cal_and_put();
        forever write_response_id_judge();
    join
    `uvm_info(get_type_name(),"Finish task collect_seq_item...", UVM_HIGH)
endtask : collect_seq_item

task axi_master_monitor :: collect_axi_write_addr();
    waddr_info_s waddr_info; 
    @(vif.pcb);
    if(vif.pcb.awvalid && vif.pcb.awready)
    begin
        waddr_info.id_info          = vif.pcb.awid    ;
        waddr_info.size_info        = vif.pcb.awsize   ;
        waddr_info.addr_info        = vif.pcb.awaddr  ;
        waddr_info.burst_len_info   = vif.pcb.awlen   ;
        waddr_info_q.push_back(waddr_info);
        waddr_info_id_jdg_q.push_back(waddr_info);  
    end
endtask : collect_axi_write_addr

task axi_master_monitor :: collect_axi_read_addr();
    raddr_info_s raddr_info; 
    @(vif.pcb);
    if(vif.pcb.arvalid && vif.pcb.arready)
    begin
        raddr_info.id_info          = vif.pcb.arid    ;
        raddr_info.size_info        = vif.pcb.arsize   ;
        raddr_info.addr_info        = vif.pcb.araddr  ;
        raddr_info.burst_len_info   = vif.pcb.arlen   ;
        raddr_info_q.push_back(raddr_info);
    end
endtask : collect_axi_read_addr

task axi_master_monitor :: collect_axi_write_data();
    wdata_info_s wdata_info; 
    @(vif.pcb);
    if(vif.pcb.wvalid && vif.pcb.wready)
    begin
        wdata_info.data_info        = vif.pcb.wdata;
        wdata_info.strb_info        = vif.pcb.wstrb;
        wdata_info.is_last_info     = vif.pcb.wlast;
        wdata_info_q.push_back(wdata_info);
    end
endtask : collect_axi_write_data

task axi_master_monitor :: collect_axi_read_data();
    rdata_info_s rdata_info; 
    @(vif.pcb);
    if(vif.pcb.rvalid && vif.pcb.rready)
    begin
        rdata_info.id_info          = vif.pcb.rid;
        rdata_info.data_info        = vif.pcb.rdata;
        rdata_info.is_last_info     = vif.pcb.rlast;
        rdata_info_q.push_back(rdata_info);
    end
endtask : collect_axi_read_data


task axi_master_monitor :: collect_axi_write_resp();
    wresp_info_s wresp_info; 
    @(vif.pcb);
    if(vif.pcb.bvalid && vif.pcb.bready)
    begin
        wresp_info.bresp_info    = vif.pcb.bresp;
        wresp_info.id_info      = vif.pcb.bid;
        wresp_info_q.push_back(wresp_info);
    end
endtask : collect_axi_write_resp

task axi_master_monitor :: write_cal_and_put();
    axi_master_item item;
    waddr_info_s waddr_info_tmp; 
    wdata_info_s wdata_info_tmp;
    if(wdata_info_q.size() != 0)
    begin
        if(waddr_info_q.size() != 0)
        begin
            item = new();
            wdata_info_tmp = wdata_info_q.pop_front(); 
            waddr_info_tmp = waddr_info_q[0];
            if(w_is_start_addr)
            begin
                item.c_addr = waddr_info_tmp.addr_info;
                w_pre_addr =  item.c_addr;
                w_number_bytes = 2**waddr_info_tmp.size_info;
                w_is_start_addr = 0;
            end
            else
            begin
                item.c_addr = w_pre_addr + w_number_bytes;
                w_pre_addr = item.c_addr;
            end
            if(wdata_info_tmp.is_last_info)
            begin
                waddr_info_q.delete(0);
                w_is_start_addr = 1;
            end
            item.direction = WRITE;
            item.c_burst_len = waddr_info_tmp.burst_len_info;
            item.c_id = waddr_info_tmp.id_info;
            item.c_size = waddr_info_tmp.size_info;
            item.c_strb = wdata_info_tmp.strb_info;
            item.c_data = wdata_info_tmp.data_info;
            item.c_is_last = wdata_info_tmp.is_last_info;
            ap.write(item);
            `uvm_info("AXI_MASTER_MON", $sformatf("collected write sequence item is:%0s", item.sprint()), UVM_HIGH)
        end
    end
    @(vif.pcb);
endtask : write_cal_and_put

task axi_master_monitor :: read_cal_and_put();
    axi_master_item item;
    raddr_info_s raddr_info_tmp; 
    rdata_info_s rdata_info_tmp;
    if(rdata_info_q.size() != 0)
    begin
        if(raddr_info_q.size() != 0)
        begin
            item = new();
            rdata_info_tmp = rdata_info_q.pop_front(); 
            raddr_info_tmp = raddr_info_q[0];
            if(r_is_start_addr)
            begin
                item.c_addr = raddr_info_tmp.addr_info;
                r_pre_addr =  item.c_addr;
                r_number_bytes = 2**raddr_info_tmp.size_info;
                r_is_start_addr = 0;
            end
            else
            begin
                item.c_addr = r_pre_addr + r_number_bytes;
                r_pre_addr = item.c_addr;
            end
            if(rdata_info_tmp.is_last_info)
            begin
                //raddr_info_q.pop_front();
                raddr_info_q.delete(0);
                r_is_start_addr = 1;
            end
            item.direction = READ;
            item.c_burst_len = raddr_info_tmp.burst_len_info;
            item.c_id = raddr_info_tmp.id_info;
            item.c_data = rdata_info_tmp.data_info;
            item.c_is_last = rdata_info_tmp.is_last_info;
            if(raddr_info_tmp.id_info != rdata_info_tmp.id_info)
            begin
                `uvm_error("AXI_MASTER_MON",$sformatf("The raddr id is not match rdata id,raddr id = %h,rdata id = %h",raddr_info_tmp.id_info,rdata_info_tmp.id_info));
            end
            ap.write(item);
            `uvm_info("AXI_MASTER_MON", $sformatf("collected read sequence item is:%0s", item.sprint()), UVM_HIGH)
        end
    end
    @(vif.pcb);
endtask : read_cal_and_put

task axi_master_monitor :: write_response_id_judge();
    wresp_info_s wresp_info_tmp;
    waddr_info_s waddr_info_tmp;
    wait(wresp_info_q.size() != 0);
    wait(waddr_info_id_jdg_q.size() != 0);
    wresp_info_tmp = wresp_info_q.pop_front();
    waddr_info_tmp = waddr_info_id_jdg_q.pop_front();
    if(wresp_info_tmp.id_info != waddr_info_tmp.id_info)
    begin
        `uvm_error("AXI_MASTER_MON",$sformatf("The waddr id is not match wresp id,waddr id = %h,wresp id = %h",wresp_info_tmp.id_info,waddr_info_tmp.id_info));
    end
endtask : write_response_id_judge


task axi_master_monitor :: reset_global_val();
    w_is_start_addr=1;
    r_is_start_addr=1;
    waddr_info_q.delete();  
    raddr_info_q.delete();  
    wdata_info_q.delete();
    rdata_info_q.delete();
    wresp_info_q.delete();
    waddr_info_id_jdg_q.delete();
endtask : reset_global_val

task axi_master_monitor :: wait_reset();
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.areset_n);
        foreach (processes[i])
            processes[i].kill();
        break;
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

`endif // AXI_MASTER_MONITOR__SV
