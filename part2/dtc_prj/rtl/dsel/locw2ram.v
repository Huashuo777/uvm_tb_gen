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
//     File for locw2ram.v                                                       
//----------------------------------------------------------------------------------
`ifndef LOCW2RAM__V
`define LOCW2RAM__V
module locw2ram#(
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32

)(
    input loc_data_in_en,
    input [LOC_AWIDTH-1:0]  loc_data_in_addr,
    input [LOC_DWIDTH-1:0]  loc_data_in,

    output                      loc_data_out_en,
    output [LOC_AWIDTH-1:0]     loc_data_out_addr,
    output [LOC_DWIDTH-1:0]     loc_data_out
);
    assign loc_data_out_en = loc_data_in_en;
    assign loc_data_out_addr = loc_data_in_addr[LOC_AWIDTH-1:2];
    assign loc_data_out = loc_data_in;

endmodule
`endif //LOCW2RAM__V
