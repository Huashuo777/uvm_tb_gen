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
//     File for axi_master_config.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_CONFIG__SV
`define AXI_MASTER_CONFIG__SV
class axi_master_config extends axi_base_config;
    bool use_reg_model = False;
    axi_wdata_first_e wdata_first = NOFIRST;
    int write_done_num=0;
    int read_done_num=0;
    int rdata_ready_sparsity = 90;
    int wresponse_ready_sparsity = 90;
    `uvm_object_utils_begin(axi_master_config)
         `uvm_field_enum(bool,use_reg_model,UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "axi_master_config");
endclass : axi_master_config

function axi_master_config :: new(string name = "axi_master_config");
    super.new(name);
endfunction : new
`endif// AXI_MASTER_CONFIG__SV
