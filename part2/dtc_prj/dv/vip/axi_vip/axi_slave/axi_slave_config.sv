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
//     File for axi_slave_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_CONFIG__SV
`define AXI_SLAVE_CONFIG__SV
class axi_slave_config extends axi_base_config;
    `uvm_object_utils_begin(axi_slave_config)
    `uvm_object_utils_end
    int waddr_ready_sparsity = 90;
    int raddr_ready_sparsity = 90;
    int wdata_ready_sparsity = 90;
    extern function new(string name = "axi_slave_config");
endclass : axi_slave_config

function axi_slave_config :: new(string name = "axi_slave_config");
    super.new(name);
endfunction : new
`endif //AXI_SLAVE_CONFIG__SV
