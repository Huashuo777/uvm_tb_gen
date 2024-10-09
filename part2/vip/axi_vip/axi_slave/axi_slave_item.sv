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
//     File for axi_slave_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_ITEM__SV
`define AXI_SLAVE_ITEM__SV
class axi_slave_item extends axi_base_item;
    rand int unsigned wait_ready_cycle;

    `uvm_object_utils_begin(axi_slave_item)
        `uvm_field_int(wait_ready_cycle, UVM_ALL_ON)
    `uvm_object_utils_end
    constraint wait_ready_cycle_cst;
    extern function new(string name = "axi_slave_item");
endclass : axi_slave_item

function axi_slave_item :: new(string name = "axi_slave_item");
    super.new(name);
endfunction : new

constraint axi_slave_item :: wait_ready_cycle_cst{
    wait_ready_cycle == 0;
}
`endif //AXI_MASTER_ITEM__SV
