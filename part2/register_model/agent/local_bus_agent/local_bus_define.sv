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
//     File for local_bus_define.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_DEFINE
`define LOCAL_BUS_DEFINE

    `ifndef LOCAL_BUS_ADDR_WIDTH
        `define LOCAL_BUS_ADDR_WIDTH 32
    `endif
    `ifndef LOCAL_BUS_DATA_WIDTH
        `define LOCAL_BUS_DATA_WIDTH 32
    `endif
`endif //LOCAL_BUS_DEFINE
