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
//     File for dsel_refmodel.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_REFEMODEL__SV
`define DSEL_REFEMODEL__SV

class dsel_refmodel extends uvm_component;
    
    uvm_event_pool events;
    dsel_block rm;
    uvm_blocking_get_port #(dsel_loc_item) dsel_loc_port;
    uvm_analysis_port     #(dsel_loc_item) dsel_loc_ap;

    uvm_blocking_get_port #(axi_master_item) axi_mst_port;

    dsel_env_config cfg;

    bit ch_sel;
    bit data_inv;


    `uvm_component_utils(dsel_refmodel)

    extern                   function new(string name, uvm_component parent);
    extern           virtual function void build_phase(uvm_phase phase);
    extern           virtual task main_phase(uvm_phase phase);
    extern           virtual function void  connect_phase(uvm_phase phase);
    extern protected virtual task get_axi_mst_pkt(output axi_master_item item); 
    extern protected virtual task get_dsel_loc_pkt(output dsel_loc_item item); 

endclass: dsel_refmodel

function dsel_refmodel:: new(string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dsel_refmodel :: build_phase(uvm_phase phase);
    super.build_phase(phase);

    dsel_loc_port = new("dsel_loc_port", this);
    dsel_loc_ap   = new("dsel_loc_ap",   this);
    axi_mst_port = new("axi_mst_port",this);


endfunction: build_phase

function void  dsel_refmodel :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
    rm = cfg.rm;
endfunction : connect_phase

task dsel_refmodel::main_phase(uvm_phase phase);
    apb_master_item apb_mst_item;
    uvm_event reg_cfg_fns_evt;
    reg_cfg_fns_evt = events.get("reg_cfg_fns_evt");
    `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
    reg_cfg_fns_evt.wait_trigger();

    ch_sel = rm.dsel_reg.channel_sel_field.get();
    data_inv = rm.dsel_reg.data_inv_field.get();
    while(1)
    begin
        if(ch_sel == 1)
        begin
            dsel_loc_item item;
            get_dsel_loc_pkt(item);
            if(data_inv)
            begin
                item.c_data = ~item.c_data;
            end
            dsel_loc_ap.write(item);
        end
        else
        begin
            bit [`AXI_DATA_WIDTH-1:0] data_tmp;
            axi_master_item axi_item;
            dsel_loc_item item;
            get_axi_mst_pkt(axi_item);
            item = new();
            for(int i=0;i<(`AXI_DATA_WIDTH/8);i++)
            begin
                if(axi_item.c_strb[i])
                begin
                    data_tmp[i*8+:8] = axi_item.c_data[i*8+:8];
                end
            end
            if(data_inv)
            begin
                data_tmp = ~data_tmp;
            end
            item.c_data = data_tmp;
            item.direction = DSEL_LOC_WRITE;
            item.c_addr = axi_item.c_addr;
            dsel_loc_ap.write(item);
        end
    end
    `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
endtask: main_phase
    
task dsel_refmodel :: get_axi_mst_pkt(output axi_master_item item); 
    axi_master_item item_tmp;
    `uvm_info(get_type_name(),"Starting task get_axi_mst_pkt...", UVM_HIGH)
    while(1)
    begin
        axi_mst_port.get(item_tmp);
        if(item_tmp.direction == axi_env_pkg::WRITE)
        begin
            item = new item_tmp;
            break;
        end
    end
    `uvm_info(get_type_name(),"Finish task get_axi_mst_pkt...", UVM_HIGH)
endtask : get_axi_mst_pkt

task dsel_refmodel :: get_dsel_loc_pkt(output dsel_loc_item item); 
    dsel_loc_item item_tmp;
    `uvm_info(get_type_name(),"Starting task get_sel_loc_pkt...", UVM_HIGH)
    while(1)
    begin
        dsel_loc_port.get(item_tmp);
        if(item_tmp.direction == DSEL_LOC_WRITE)
        begin
            item = new item_tmp;
            break;
        end
    end
    `uvm_info(get_type_name(),"Finish task get_sel_loc_pkt...", UVM_HIGH)
endtask : get_dsel_loc_pkt

`endif // DSEL_REFERENCE__SV
