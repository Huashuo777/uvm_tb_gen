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
//     File for apb_master_adapter.sv                                                       
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
// This code is copyrighted by BrentWang and cannot be used for commercial purposes.
//                                                                                  
// If you have any questions, please contact email:brent_wang@foxmail.com.          
//----------------------------------------------------------------------------------
//                                                                                  
// Author  : BrentWang                                                              
// Project : UVM study                                                              
// Date    : Sat Jan 26 06:05:52 WAT 2022                                           
//----------------------------------------------------------------------------------
//                                                                                  
// Description:                                                                     
//     File for apb_master_adapter.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_ADPTER__SV
`define APB_MASTER_ADPTER__SV
class apb_master_adapter extends uvm_reg_adapter;
    `uvm_object_utils(apb_master_adapter)
    apb_master_config cfg;
    extern           function new(string name = "apb_master_adapter");
    extern protected function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    extern protected function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
endclass

function apb_master_adapter :: new(string name = "apb_master_adapter");
    super.new(name);
endfunction : new

function uvm_sequence_item apb_master_adapter :: reg2bus(const ref uvm_reg_bus_op rw);
    apb_master_item item;
    item          = new("item");
    item.direction =(rw.kind == UVM_READ)? READ:WRITE;
    item.addr      = rw.addr;
    item.data     = rw.data;
    return item;
endfunction : reg2bus

function void apb_master_adapter :: bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
    apb_master_item item;
    if(!$cast(item,bus_item)) begin
        `uvm_fatal(get_type_name(),"Provided bus_item is not of the correct type.")
        return;
    end
    rw.kind     = (item.direction == READ)? UVM_READ:UVM_WRITE;
    rw.addr     = item.addr;
    rw.data     = item.data;
    rw.status = (item.response == OKAY) ? UVM_IS_OK : UVM_NOT_OK;
endfunction : bus2reg

`endif //APB_MASTER_ADPTER__SV
