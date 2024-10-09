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
//     File for axi_slave_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_DRIVER__SV
`define AXI_SLAVE_DRIVER__SV
class axi_slave_driver extends uvm_driver#(axi_slave_item);
    bit w_is_start_addr=1;
    bit [7:0] w_number_bytes;
    int     w_response_num = 0;
    axi_addr_t w_pre_addr;
    `uvm_component_utils(axi_slave_driver)
    virtual axi_slave_interface vif;
    raddr_info_s raddr_info_q[$];  
    waddr_info_s waddr_info_resp_q[$];  
    waddr_info_s waddr_info_mem_q[$];  
    wdata_info_s wdata_info_q[$];
    axi_slave_config cfg;
    uvm_event_pool events;
    protected process processes[string];
    protected axi_slave_memory m_mem;

    extern                   function new(string name = "axi_slave_driver",uvm_component parent = null);
    extern           virtual function void connect_phase(uvm_phase phase);
    extern           virtual task run_phase(uvm_phase phase); 
    extern protected virtual task get_and_drive();
    extern protected virtual task write_mem();
    extern protected virtual task axi_slave_waddr_driver();
    extern protected virtual task axi_slave_wdata_driver();
    extern protected virtual task axi_slave_wresp_driver(axi_slave_item item);
    extern protected virtual task get_write_data_last_num();
    extern protected virtual task axi_slave_raddr_driver();
    extern protected virtual task get_raddr_info();
    extern protected virtual task get_waddr_info();
    extern protected virtual task get_wdata_info();
    extern protected virtual task axi_slave_rdata_driver(axi_slave_item item);
    extern protected virtual task reset_signal();
    extern protected virtual task wait_reset();
    extern protected virtual task reset_global_val();
    extern protected virtual function void init_mem();
endclass : axi_slave_driver

function axi_slave_driver :: new(string name = "axi_slave_driver",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void axi_slave_driver :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task axi_slave_driver :: run_phase(uvm_phase phase);
    process proc_drive;
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Starting task run_phase...", UVM_HIGH)
    reset_signal();
    init_mem();
    forever 
    begin
        reset_global_val();
        wait(vif.areset_n);
        @(vif.scb);
        fork
            forever
            begin
                proc_drive = process::self();
                processes["proc_drive"] = proc_drive;
                get_and_drive();
            end
            forever axi_slave_waddr_driver();
            forever get_raddr_info();
            forever get_waddr_info();
            forever axi_slave_raddr_driver();
            forever axi_slave_wdata_driver();
            forever get_wdata_info();
            forever write_mem();
            forever get_write_data_last_num();
            wait_reset();
        join_any
        disable fork;
    end
    `uvm_info(get_type_name(),"Finish task run_phase...", UVM_HIGH)
endtask : run_phase

task axi_slave_driver :: get_and_drive();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task get_and_drive...", UVM_HIGH)

    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Get transaction:%0s", req.sprint()), UVM_HIGH)
    get_req_evt.trigger();

    fork
        forever axi_slave_wresp_driver(req);
        forever axi_slave_rdata_driver(req);
    join

    seq_item_port.item_done();
    get_req_evt.reset();
    `uvm_info(get_type_name(),"Finish task get_and_drive...", UVM_HIGH)
endtask : get_and_drive

task axi_slave_driver :: reset_global_val();
    w_is_start_addr=1;
    w_response_num = 0;
    raddr_info_q.delete();  
    waddr_info_resp_q.delete();  
    waddr_info_mem_q.delete();  
    wdata_info_q.delete();
endtask : reset_global_val


task axi_slave_driver :: write_mem();
    waddr_info_s waddr_info_tmp;
    wdata_info_s wdata_info_tmp;
    axi_addr_t addr_tmp;
    axi_data_t data_tmp;
    if(wdata_info_q.size() != 0)
    begin
        if(waddr_info_mem_q.size() != 0)
        begin
            wdata_info_tmp = wdata_info_q.pop_front(); 
            waddr_info_tmp = waddr_info_mem_q[0];
            if(w_is_start_addr)
            begin
                addr_tmp = waddr_info_tmp.addr_info;
                w_pre_addr =  addr_tmp;
                w_number_bytes = 2**waddr_info_tmp.size_info;
                w_is_start_addr = 0;
            end
            else
            begin
                addr_tmp = w_pre_addr + w_number_bytes;
                w_pre_addr = addr_tmp;
            end
            if(wdata_info_tmp.is_last_info)
            begin
                waddr_info_mem_q.pop_front();
                w_is_start_addr = 1;
            end
            for(int i=0;i<2**waddr_info_tmp.size_info;i++)
            begin
                if(wdata_info_tmp.strb_info[i])
                begin
                    data_tmp[i*8+:8] = wdata_info_tmp.data_info[i*8+:8];
                end
                else 
                begin
                    data_tmp[i*8+:8] = 8'b0;
                end
            end
            m_mem.write(addr_tmp,data_tmp); 
        end
    end
    @(vif.pcb);
endtask : write_mem

task axi_slave_driver :: reset_signal();
    vif.scb.awready <= 0;
    vif.scb.wready  <= 0;
    vif.scb.bid     <= 0;
    vif.scb.bresp   <= 0;
    vif.scb.bvalid  <= 0;
    vif.scb.arready <= 0;
    vif.scb.rid     <= 0;
    vif.scb.rdata   <= 0;
    vif.scb.rresp   <= 0;
    vif.scb.rlast   <= 0;
    vif.scb.rvalid  <= 0;
    //@(vif.scb);
endtask : reset_signal

task axi_slave_driver :: axi_slave_waddr_driver();
    bit ready;
    std::randomize(ready) with {
        ready dist {1:/cfg.waddr_ready_sparsity,0:/(100-cfg.waddr_ready_sparsity)}; 
    };
    vif.scb.awready <= ready;
    @(vif.scb);

endtask : axi_slave_waddr_driver

task axi_slave_driver :: axi_slave_raddr_driver();
    bit ready;
    std::randomize(ready) with {
        ready dist {1:/cfg.raddr_ready_sparsity,0:/(100-cfg.raddr_ready_sparsity)}; 
    };
    vif.scb.arready <= ready;
    @(vif.scb);
endtask : axi_slave_raddr_driver

task axi_slave_driver :: axi_slave_rdata_driver(axi_slave_item item);
    raddr_info_s raddr_info_tmp; 
    axi_addr_t addr_tmp;
    axi_strb_t strb_tmp;
    axi_id_t id_tmp;
    axi_size_t size_tmp;
    axi_len_t len_tmp;
    wait(raddr_info_q.size != 0)
    begin
        raddr_info_tmp = raddr_info_q.pop_front();
        id_tmp = raddr_info_tmp.id_info;
        addr_tmp = raddr_info_tmp.addr_info;
        size_tmp = raddr_info_tmp.size_info;
        len_tmp = raddr_info_tmp.burst_len_info;
        for(int i=0 ;i<(len_tmp+1);)
        begin
            axi_data_t data_tmp;
            m_mem.read(addr_tmp,data_tmp); 
            addr_tmp = addr_tmp + 2**size_tmp;
            vif.scb.rvalid <= 1;
            vif.scb.rid <= id_tmp;
            vif.scb.rresp  <= item.response;
            vif.scb.rdata <= data_tmp;
            if(i==len_tmp)
            begin
                vif.scb.rlast <= 1;
            end
            else
            begin
                vif.scb.rlast <= 0;
            end
            i++;
            @(vif.scb iff vif.scb.rready);
            vif.scb.rvalid  <= 0;
            vif.scb.rid     <= 0;
            vif.scb.rlast   <= 0;
            vif.scb.rdata   <= 0;
            vif.scb.rresp   <= 0;
        end
    end

endtask : axi_slave_rdata_driver


task axi_slave_driver :: axi_slave_wdata_driver();
    bit ready;
    std::randomize(ready) with {
        ready dist {1:/cfg.wdata_ready_sparsity,0:/(100-cfg.wdata_ready_sparsity)}; 
    };
    vif.scb.wready <= ready;
    @(vif.scb); 
endtask : axi_slave_wdata_driver

task axi_slave_driver :: get_write_data_last_num();
    if(vif.pcb.wlast && vif.pcb.wvalid && vif.pcb.wready)
    begin
       w_response_num ++; 
    end
    @(vif.pcb);
endtask : get_write_data_last_num

task axi_slave_driver :: axi_slave_wresp_driver(axi_slave_item item);
    waddr_info_s waddr_info_tmp;
    if(w_response_num > 0)
    begin
        wait(waddr_info_resp_q.size()>0);
        //@(vif.scb);
        waddr_info_tmp = waddr_info_resp_q.pop_front();
        vif.scb.bvalid <= 1'b1;
        vif.scb.bid    <= waddr_info_tmp.id_info;
        vif.scb.bresp  <= item.response;
        @(vif.scb iff vif.scb.bready);
        vif.scb.bvalid <= 0;
        vif.scb.bid    <= 0;
        vif.scb.bresp  <= 0;
        w_response_num --;
    end
    else
    begin
        @(vif.pcb);
    end
endtask : axi_slave_wresp_driver

task axi_slave_driver :: get_raddr_info();
    raddr_info_s raddr_info; 
    if(vif.pcb.arvalid && vif.pcb.arready)
    begin
        raddr_info.id_info          = vif.pcb.arid    ;
        raddr_info.size_info        = vif.pcb.arsize   ;
        raddr_info.addr_info        = vif.pcb.araddr  ;
        raddr_info.burst_len_info   = vif.pcb.arlen   ;
        raddr_info_q.push_back(raddr_info);
    end
    @(vif.pcb);
endtask : get_raddr_info

task axi_slave_driver :: get_waddr_info();
    waddr_info_s waddr_info; 
    if(vif.pcb.awvalid && vif.pcb.awready)
    begin
        waddr_info.id_info          = vif.pcb.awid    ;
        waddr_info.size_info        = vif.pcb.awsize   ;
        waddr_info.addr_info        = vif.pcb.awaddr  ;
        waddr_info.burst_len_info   = vif.pcb.awlen   ;
        waddr_info_resp_q.push_back(waddr_info);
        waddr_info_mem_q.push_back(waddr_info);
    end
    @(vif.pcb);
endtask : get_waddr_info

task axi_slave_driver :: get_wdata_info();
    wdata_info_s wdata_info; 
    @(vif.pcb);
    if(vif.pcb.wvalid && vif.pcb.wready)
    begin
        wdata_info.data_info        = vif.pcb.wdata;
        wdata_info.strb_info        = vif.pcb.wstrb;
        wdata_info.is_last_info     = vif.pcb.wlast;
        wdata_info_q.push_back(wdata_info);
    end
endtask : get_wdata_info


task axi_slave_driver :: wait_reset();
    uvm_event get_req_evt = events.get($sformatf("%s_get_req_evt", cfg.get_name()));
    `uvm_info(get_type_name(),"Starting task wait_reset...", UVM_HIGH)
    forever begin
        @(negedge vif.areset_n);
        `uvm_warning("wait reset",$sformatf("Reset signal is asserted in time %t",$time));
        if(get_req_evt.is_on())
            seq_item_port.item_done();
        reset_signal();
        foreach (processes[i])
            processes[i].kill();
        break;
    end
    `uvm_info(get_type_name(),"Finish task wait_reset...", UVM_HIGH)
endtask : wait_reset

function void axi_slave_driver :: init_mem();
    if(!uvm_config_db #(axi_slave_memory) :: get(null,get_full_name(),"mem",m_mem))
    begin
        m_mem = new();
    end
endfunction : init_mem

`endif //AXI_SLAVE_DRIVER__SV
