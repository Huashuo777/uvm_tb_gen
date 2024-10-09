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
//     File for axi_define.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_DEFINE__SV
`define AXI_DEFINE__SV

    `ifndef AXI_MASTER_NUM
        `define AXI_MASTER_NUM 1
    `endif
    `ifndef AXI_SLAVE_NUM
        `define AXI_SLAVE_NUM 1
    `endif
    `ifndef AXI_ADDR_WIDTH
        `define AXI_ADDR_WIDTH 32
    `endif
    `ifndef AXI_ID_WIDTH
        `define AXI_ID_WIDTH 3
    `endif
    `ifndef AXI_DATA_WIDTH
        `define AXI_DATA_WIDTH 64
    `endif
    `ifndef AXI_REGION_WIDTH
        `define AXI_REGION_WIDTH 4
    `endif
    `ifndef AXI_LEN_WIDTH
        `define AXI_LEN_WIDTH 8
    `endif
    `ifndef AXI_SIZE_WIDTH
        `define AXI_SIZE_WIDTH 3
    `endif
    `ifndef AXI_BURST_WIDTH
        `define AXI_BURST_WIDTH 2
    `endif
    `ifndef AXI_CACHE_WIDTH
        `define AXI_CACHE_WIDTH 4
    `endif
    `ifndef AXI_PROT_WIDTH
        `define AXI_PROT_WIDTH 3
    `endif
    `ifndef AXI_QOS_WIDTH
        `define AXI_QOS_WIDTH 4
    `endif
    `ifndef AXI_USER_WIDTH
        `define AXI_USER_WIDTH 4
    `endif
    `ifndef AXI_RESP_WIDTH
        `define AXI_RESP_WIDTH 2
    `endif
    `ifndef AXI_STRB_WIDTH
        `define AXI_STRB_WIDTH 4
    `endif
    `ifndef AXI_MASTER_INPUT_TIME 
        `define AXI_MASTER_INPUT_TIME 1ns
    `endif
    `ifndef AXI_MASTER_OUTPUT_TIME 
        `define AXI_MASTER_OUTPUT_TIME 1ns
    `endif
    `ifndef AXI_SLAVE_INPUT_TIME 
        `define AXI_SLAVE_INPUT_TIME 1ns
    `endif
    `ifndef AXI_SLAVE_OUTPUT_TIME 
        `define AXI_SLAVE_OUTPUT_TIME 1ns
    `endif
    `ifndef AXI_PASSIVE_INPUT_TIME 
        `define AXI_PASSIVE_INPUT_TIME 1ns
    `endif
    `ifndef AXI_PASSIVE_OUTPUT_TIME 
        `define AXI_PASSIVE_OUTPUT_TIME 1ns
    `endif
    `ifndef AXI_WRITE_OUTSTANDING_MAX 
        `define AXI_WRITE_OUTSTANDING_MAX 8
    `endif
    `ifndef AXI_READ_OUTSTANDING_MAX 
        `define AXI_READ_OUTSTANDING_MAX 8
    `endif
    
`endif //AXI_DEFINE__SV
