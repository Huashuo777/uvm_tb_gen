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
//     File for local_bus_adapter.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_ADPTER
`define LOCAL_BUS_ADPTER
class local_bus_adapter extends uvm_reg_adapter;
    `uvm_object_utils(local_bus_adapter)
    extern           function new(string name = "local_bus_adapter");
    extern protected function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    extern protected function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
endclass

function local_bus_adapter :: new(string name = "local_bus_adapter");
    super.new(name);
endfunction : new

function uvm_sequence_item local_bus_adapter :: reg2bus(const ref uvm_reg_bus_op rw);
    local_bus_item item;
    item          = new("item");
    item.direction =(rw.kind == UVM_READ)? READ:WRITE;
    item.addr      = rw.addr;
    item.data     = rw.data;
    return item;
endfunction : reg2bus

function void local_bus_adapter :: bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    local_bus_item item;
    if(!$cast(item,bus_item)) begin
        `uvm_fatal(get_type_name(),"Provided bus_item is not of the correct type.")
        return;
    end
    rw.kind     = (item.direction == READ)? UVM_READ:UVM_WRITE;
    rw.addr     = item.addr;
    rw.data     = item.data;
    rw.status =  UVM_IS_OK;
endfunction : bus2reg

`endif //LOCAL_BUS_ADPTER
