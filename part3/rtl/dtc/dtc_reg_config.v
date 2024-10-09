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
//     File for dtc_reg_config.v                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_REG_CONFIG__V
`define DTC_REG_CONFIG__V
module dtc_reg_config
    #(
    parameter APB_AWIDTH = 32,
    parameter APB_DWIDTH = 32
    )
    (
    input                       psel   ,
    input [APB_AWIDTH-1:0]      paddr  ,
    input                       penable,
    input                       pwrite ,
    input [APB_DWIDTH-1:0]      pwdata ,
    output                      pready ,
    output [APB_DWIDTH-1:0]     prdata ,     
    //dadd
    output                      dadd_psel   ,
    output [APB_AWIDTH-1:0]     dadd_paddr  ,
    output                      dadd_penable,
    output                      dadd_pwrite ,
    output [APB_DWIDTH-1:0]     dadd_pwdata ,
    input                       dadd_pready ,
    input  [APB_DWIDTH-1:0]     dadd_prdata ,     
    //dsel
    output                      dsel_psel   ,
    output [APB_AWIDTH-1:0]     dsel_paddr  ,
    output                      dsel_penable,
    output                      dsel_pwrite ,
    output [APB_DWIDTH-1:0]     dsel_pwdata ,
    input                       dsel_pready ,
    input  [APB_DWIDTH-1:0]     dsel_prdata 
    );

    assign pready = 1;

    assign dadd_reg_write = pready && psel && penable && pwrite && (paddr == 32'h0);
    assign dsel_reg_write = pready && psel && penable && pwrite && (paddr == 32'h100);
    assign dadd_reg_read  = psel && ~pwrite && (paddr == 32'h0);
    assign dsel_reg_read  = psel && ~pwrite && (paddr == 32'h100);

    assign dadd_psel    = dadd_reg_write || dadd_reg_read ? psel    : 0; 
    assign dadd_paddr   = dadd_reg_write || dadd_reg_read ? paddr   : 0; 
    assign dadd_penable = dadd_reg_write || dadd_reg_read ? penable : 0; 
    assign dadd_pwrite  = dadd_reg_write || dadd_reg_read ? pwrite  : 0; 
    assign dadd_pwdata  = dadd_reg_write ? pwdata  : 0; 
    assign prdata       = dadd_reg_read  ? dadd_prdata : 0; 

    assign dsel_psel    = dsel_reg_write || dsel_reg_read ? psel    : 0; 
    assign dsel_paddr   = dsel_reg_write || dsel_reg_read ? paddr   : 0; 
    assign dsel_penable = dsel_reg_write || dsel_reg_read ? penable : 0; 
    assign dsel_pwrite  = dsel_reg_write || dsel_reg_read ? pwrite  : 0; 
    assign dsel_pwdata  = dsel_reg_write ? pwdata  : 0; 
    assign prdata       = dsel_reg_read  ? dsel_prdata : 0; 
endmodule
`endif //DTC_REG_CONFIG__V
