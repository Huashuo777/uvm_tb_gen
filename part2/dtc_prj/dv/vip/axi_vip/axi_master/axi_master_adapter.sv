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
//     File for axi_master_adapter.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_ADPTER__SV
`define AXI_MASTER_ADPTER__SV
class axi_master_adapter extends uvm_reg_adapter;
    `uvm_object_utils(axi_master_adapter)
    axi_master_config cfg;
    extern           function new(string name = "axi_master_adapter");
    extern protected function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    extern protected function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
endclass

function axi_master_adapter :: new(string name = "axi_master_adapter");
    super.new(name);
endfunction : new

function uvm_sequence_item axi_master_adapter :: reg2bus(const ref uvm_reg_bus_op rw);
    axi_master_item item;
    item          = new("item");
    item.direction =(rw.kind == UVM_READ)? READ:WRITE;
    item.addr_arr[0]    = rw.addr;
    item.data_arr[0][0] = rw.data;
    item.id_arr[0]         =$urandom();
    item.strb_arr[0][0] ='1;
    item.size_arr[0]    =$clog2(`AXI_DATA_WIDTH/8);
    item.burst_len_arr[0] = 0;
    item.burst_type = INCR;
    return item;
endfunction : reg2bus

function void axi_master_adapter :: bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    axi_master_item item;
    if(!$cast(item,bus_item)) begin
        `uvm_fatal(get_type_name(),"Provided bus_item is not of the correct type.")
        return;
    end
    rw.kind     = (item.direction == READ)? UVM_READ:UVM_WRITE;
    rw.addr     = item.c_addr;
    rw.data     = item.c_data;
    rw.status = (item.response == OKAY) ? UVM_IS_OK : UVM_NOT_OK;
endfunction : bus2reg

`endif //AXI_MASTER_ADPTER__SV
