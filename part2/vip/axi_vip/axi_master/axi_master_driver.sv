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
//     File for axi_master_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_DRIVER__SV
`define AXI_MASTER_DRIVER__SV
class axi_master_driver extends uvm_driver #(axi_master_item);
    `uvm_component_utils(axi_master_driver)
    axi_master_item w_item_q[$];
    axi_master_item r_item_q[$];
    virtual axi_master_interface vif;
    axi_master_config cfg;
    uvm_event_pool events;
    int write_underway_num = 0;
    int read_underway_num = 0;
    int burst_num = 0;
    bit wdata_first;
    protected process processes[string];

    extern                   function new(string name = "axi_master_driver",uvm_component parent = null);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern           virtual task run_phase(uvm_phase phase); 
    extern protected virtual task get_and_drive();
    extern protected virtual task driver_write_addr(axi_master_item item);
    extern protected virtual task driver_write_data(axi_master_item item);
    extern protected virtual task driver_write_response();
    extern protected virtual task driver_read_addr(axi_master_item item);
    extern protected virtual task driver_read_data();
    extern protected virtual task get_write_outstanding_num();
    extern protected virtual task get_read_outstanding_num();
    extern protected virtual task trigger_finish();
    extern protected virtual task wdata_first_judge(axi_master_config cfg);
    extern protected virtual task reset_global_val();
    extern protected virtual task reset_signal();
    extern protected virtual task wait_reset();
endclass : axi_master_driver

function axi_master_driver :: new(string name = "axi_master_driver",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void axi_master_driver :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task axi_master_driver :: run_phase(uvm_phase phase);
    process proc_drive;
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Starting task run_phase...", UVM_HIGH)
    reset_signal();
    wdata_first_judge(cfg);
    forever
    begin
        reset_global_val();
        wait(vif.areset_n);
        @(vif.mcb);
        fork
            forever
            begin
                proc_drive = process::self();
                processes["proc_drive"] = proc_drive;
                get_and_drive();
            end
            forever get_write_outstanding_num();
            forever get_read_outstanding_num();
            forever driver_write_response();
            forever driver_read_data();
            wait_reset();
        join_any
        disable fork;
    end
    `uvm_info(get_type_name(),"Finish task run_phase...", UVM_HIGH)
endtask : run_phase

task axi_master_driver :: get_and_drive();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task get_and_drive...", UVM_HIGH)
    fork
        forever 
        begin
            seq_item_port.get_next_item(req);
            get_req_evt.trigger();
            `uvm_info(get_type_name(), $sformatf("Get transaction:%0s", req.sprint()), UVM_HIGH)
            burst_num = burst_num + req.burst_len_arr.size();
            if(req.direction == WRITE)
            begin
                w_item_q.push_back(req);
            end
            else if(req.direction == READ)
            begin
                r_item_q.push_back(req);
            end
            seq_item_port.item_done();
            get_req_evt.reset();
        end
        forever 
        begin
            axi_master_item item_tmp;
            wait(w_item_q.size() != 0);
            item_tmp = w_item_q.pop_front();
            fork
                driver_write_addr(item_tmp);
                driver_write_data(item_tmp);
            join
        end
        forever 
        begin
            axi_master_item item_tmp;
            wait(r_item_q.size() != 0);
            item_tmp = r_item_q.pop_front();
            driver_read_addr(item_tmp);
        end
        forever
        begin
            trigger_finish();
        end
    join
    `uvm_info(get_type_name(),"Finish task get_and_drive...", UVM_HIGH)

endtask : get_and_drive

task axi_master_driver :: reset_global_val();
    write_underway_num = 0;
    read_underway_num = 0;
    burst_num = 0;
    w_item_q.delete();
    r_item_q.delete();
endtask : reset_global_val

task axi_master_driver :: trigger_finish();
    uvm_event trans_fns_evt = events.get($sformatf("%s_trans_fns_evt", cfg.get_name()));
    if(((vif.pcb.bvalid && vif.pcb.bready) && (w_item_q.size() == 0) &&( burst_num == 0)) || ((vif.pcb.rvalid && vif.pcb.rready) && (r_item_q.size() == 0) &&( burst_num == 0)))
    begin
        trans_fns_evt.trigger();
    end
    @(vif.pcb);

endtask : trigger_finish

task axi_master_driver :: reset_signal();
    vif.mcb.awid    <= 0;
    vif.mcb.awaddr  <= 0;
    vif.mcb.awregion<= 0;
    vif.mcb.awlen   <= 0;
    vif.mcb.awsize  <= 0;
    vif.mcb.awburst <= 0;
    vif.mcb.awlock  <= 0;
    vif.mcb.awcache <= 0;
    vif.mcb.awprot  <= 0;
    vif.mcb.awqos   <= 0;
    vif.mcb.awvalid <= 0;
    vif.mcb.wdata   <= 0;
    vif.mcb.wstrb   <= 0;
    vif.mcb.wlast   <= 0;
    vif.mcb.wvalid  <= 0;
    vif.mcb.bready  <= 0;
    vif.mcb.awuser  <= 0;
    vif.mcb.wuser   <= 0;
    vif.mcb.buser   <= 0;
    vif.mcb.arid    <= 0;
    vif.mcb.araddr  <= 0;
    vif.mcb.arregion<= 0;
    vif.mcb.arlen   <= 0;
    vif.mcb.arsize  <= 0;
    vif.mcb.arburst <= 0;
    vif.mcb.arlock  <= 0;
    vif.mcb.arcache <= 0;
    vif.mcb.arprot  <= 0;
    vif.mcb.arqos   <= 0;
    vif.mcb.arvalid <= 0;
    vif.mcb.rready  <= 0;
    vif.mcb.awuser  <= 0;
    vif.mcb.wuser   <= 0;
    vif.mcb.aruser  <= 0;
    vif.mcb.ruser   <= 0;
    vif.mcb.buser   <= 0;
endtask : reset_signal

task axi_master_driver :: driver_write_addr(axi_master_item item);
    int trans_num;
    axi_master_item item_tmp;
    item_tmp = new item;
    @(vif.mcb);
    if(wdata_first) 
    begin
        repeat($urandom_range(1,10)) @(vif.mcb);
    end
    trans_num = item_tmp.addr_arr.size();
    for(int i=0;i<trans_num;)
    begin
        if(write_underway_num<`AXI_WRITE_OUTSTANDING_MAX)
        begin
            vif.mcb.awid    <= item_tmp.id_arr[i];
            vif.mcb.awsize  <= item_tmp.size_arr[i];
            vif.mcb.awaddr  <= item_tmp.addr_arr[i];
            vif.mcb.awburst <= item_tmp.burst_type;
            vif.mcb.awlen   <= item_tmp.burst_len_arr[i];
            vif.mcb.awvalid <= 1;
            @(vif.mcb iff vif.mcb.awready);
            vif.mcb.awvalid <= 0;
            vif.mcb.awaddr  <= 0;
            vif.mcb.awlen   <= 0;
            vif.mcb.awsize  <= 0;
            vif.mcb.awid    <= 0;
            write_underway_num ++;
            i++;
        end
        else
        begin
            @(vif.mcb);
        end
    end
endtask : driver_write_addr

task axi_master_driver :: driver_read_addr(axi_master_item item);
    int trans_num;
    axi_master_item item_tmp;
    item_tmp = new item;
    trans_num = item_tmp.addr_arr.size();
    @(vif.mcb);
    for(int i=0;i<trans_num;)
    begin
        if(read_underway_num<`AXI_READ_OUTSTANDING_MAX)
        begin
            vif.mcb.arid    <= item_tmp.id_arr[i];
            vif.mcb.arsize  <= item_tmp.size_arr[i];
            vif.mcb.araddr  <= item_tmp.addr_arr[i];
            vif.mcb.arburst <= item_tmp.burst_type;
            vif.mcb.arlen   <= item_tmp.burst_len_arr[i];
            vif.mcb.arvalid <= 1;
            @(vif.mcb iff vif.mcb.arready);
            vif.mcb.arvalid <= 0;
            vif.mcb.araddr  <= 0;
            vif.mcb.arid    <= 0;
            vif.mcb.arsize  <= 0;
            vif.mcb.arburst <= 0;
            vif.mcb.arlen   <= 0;
            read_underway_num ++;
            i++;
        end
        else
        begin
            @(vif.mcb);
        end
    end
endtask : driver_read_addr


task axi_master_driver :: driver_read_data();
    bit ready;
    std::randomize(ready) with {
        ready dist {1:/cfg.rdata_ready_sparsity,0:/(100-cfg.rdata_ready_sparsity)}; 
    };
    vif.mcb.rready <= ready;
    @(vif.mcb);
endtask : driver_read_data

task axi_master_driver :: driver_write_data(axi_master_item item);
    int trans_num;
    axi_master_item item_tmp;
    item_tmp = new item;
    @(vif.mcb);
    if(!wdata_first) 
    begin
        repeat($urandom_range(1,10)) @(vif.mcb);
    end
    trans_num = item_tmp.data_arr.size();
    for(int i=0;i<trans_num;i++)
    begin
        for(int j=0;j<(item_tmp.burst_len_arr[i]+1);j++)
        begin
            vif.mcb.wdata  <= item_tmp.data_arr[i][j];
            vif.mcb.wstrb  <= item_tmp.strb_arr[i][j];
            vif.mcb.wvalid <= 1'b1;
            if(j == item_tmp.burst_len_arr[i])
            begin
                vif.mcb.wlast <= 1'b1;
            end
            @(vif.mcb iff vif.mcb.wready);
            vif.mcb.wvalid <= 1'b0;
            vif.mcb.wlast  <= 1'b0;
            vif.mcb.wdata  <=  'b0;
            vif.mcb.wstrb  <=  'b0;
        end
    end
endtask : driver_write_data

task axi_master_driver :: driver_write_response();
    bit ready;
    std::randomize(ready) with {
        ready dist {1:/cfg.wresponse_ready_sparsity,0:/(100-cfg.wresponse_ready_sparsity)}; 
    };
    vif.mcb.bready <= ready;
    @(vif.mcb);
endtask : driver_write_response

task axi_master_driver :: get_write_outstanding_num();
    if(vif.pcb.bvalid && vif.pcb.bready)
    begin
        write_underway_num -- ;
        burst_num -- ;
        if(write_underway_num < 0)
        begin
            `uvm_fatal(get_type_name(), $sformatf("Write data outstanding error!!!"))
        end
    end
    @(vif.pcb);
endtask : get_write_outstanding_num

task axi_master_driver :: get_read_outstanding_num();
    if(vif.pcb.rvalid && vif.pcb.rready && vif.pcb.rlast)
    begin
        read_underway_num -- ;
        burst_num -- ;
        if(read_underway_num < 0)
        begin
            #500ns;
            `uvm_fatal(get_type_name(), $sformatf("Read data outstanding error!!!"))
        end
    end
    @(vif.pcb);
endtask : get_read_outstanding_num

task axi_master_driver :: wdata_first_judge(axi_master_config cfg);
    axi_master_config cfg_tmp;
    cfg_tmp = new cfg;
    if(cfg_tmp.wdata_first == FIRST)
    begin
        wdata_first = 1;
    end
    else if(cfg_tmp.wdata_first == NOFIRST)
    begin
        wdata_first = 0;
    end
    else if(cfg_tmp.wdata_first == RANDOM)
    begin
        wdata_first = $urandom;
    end
    else 
    begin
        `uvm_fatal(get_type_name(), $sformatf("Config: wdata_first config error!!!"))
    end
endtask : wdata_first_judge

task axi_master_driver :: wait_reset();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.areset_n);
        `uvm_warning("wait reset",$sformatf("Reset signal is asserted in time %t",$time));
        if(get_req_evt.is_on())
        begin
            seq_item_port.item_done();
        end
        reset_signal();
        foreach (processes[i])
            processes[i].kill();
        break;
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

`endif //AXI_MASTER_DRIVER__SV
