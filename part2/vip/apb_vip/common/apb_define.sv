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
//     File for apb_define.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_DEFINE__SV
`define APB_DEFINE__SV

    `ifndef APB_MASTER_NUM
        `define APB_MASTER_NUM 1
    `endif
    `ifndef APB_SLAVE_NUM
        `define APB_SLAVE_NUM 1
    `endif
    `ifndef APB_ADDR_WIDTH
        `define APB_ADDR_WIDTH 32
    `endif
    `ifndef APB_DATA_WIDTH
        `define APB_DATA_WIDTH 32
    `endif
    `ifndef APB_MASTER_INPUT_TIME 
        `define APB_MASTER_INPUT_TIME 1ns
    `endif
    `ifndef APB_MASTER_OUTPUT_TIME 
        `define APB_MASTER_OUTPUT_TIME 1ns
    `endif
    `ifndef APB_SLAVE_INPUT_TIME 
        `define APB_SLAVE_INPUT_TIME 1ns
    `endif
    `ifndef APB_SLAVE_OUTPUT_TIME 
        `define APB_SLAVE_OUTPUT_TIME 1ns
    `endif
    `ifndef APB_PASSIVE_INPUT_TIME 
        `define APB_PASSIVE_INPUT_TIME 1ns
    `endif
    `ifndef APB_PASSIVE_OUTPUT_TIME 
        `define APB_PASSIVE_OUTPUT_TIME 1ns
    `endif

`endif //APB_DEFINE__SV
