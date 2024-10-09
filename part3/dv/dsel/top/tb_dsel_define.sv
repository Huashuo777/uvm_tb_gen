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
//     File for tb_dsel_define.sv                                                       
//----------------------------------------------------------------------------------
`ifndef TB_DSEL_DEFINE__SV
`define TB_DSEL_DEFINE__SV
    `define TB_TOP tb_dsel
    `define AXI_DATA_WIDTH 32
    `define AXI_LEN_WIDTH 8
`endif //TB_DSEL_DEFINE_SV
