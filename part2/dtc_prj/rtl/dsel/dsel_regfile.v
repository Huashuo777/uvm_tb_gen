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
//     File for dsel_regfile.v                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_REGFILE__V
`define DSEL_REGFILE__V
module dsel_regfile
    #(
    parameter APB_AWIDTH = 32,
    parameter APB_DWIDTH = 32
    )
    (
    input                       pclk     ,
    input                       rst_n    ,
    //apb interface
    input                       psel     ,
    input [APB_AWIDTH-1:0]      paddr    ,
    input                       penable  ,
    input                       pwrite   ,
    input [APB_DWIDTH-1:0]      pwdata   ,
    output                      pready   ,
    output reg [APB_DWIDTH-1:0] prdata   ,
    output [31:0]               reg_value
    );
    wire channel_sel;
    wire data_inv;
    assign dsel_reg_write_0 = pready && psel && penable && pwrite && (paddr == `DSEL_REG_ADDR_OFFSET_0);
    assign dsel_reg_read_0 = psel && ~pwrite && (paddr == `DSEL_REG_ADDR_OFFSET_0);
    assign reg_value = {data_inv,channel_sel};
    assign pready = 1;
    always @(posedge pclk or negedge rst_n)
    if(~rst_n)
        prdata <= 0;
    else if(dsel_reg_read_0)
        prdata <= reg_value;
    else
        prdata <= prdata;

    apb_rw_reg #(1,0) channel_sel_field(
    .pclk       (pclk),
    .rst_n      (rst_n),
    .wr_en      (dsel_reg_write_0),
    .pwdata     (pwdata[0]),
    .reg_data   (channel_sel)
    );
    apb_rw_reg #(1,0) data_inv_field(
    .pclk       (pclk),
    .rst_n      (rst_n),
    .wr_en      (dsel_reg_write_0),
    .pwdata     (pwdata[1]),
    .reg_data   (data_inv)
    );

endmodule
`endif //DSEL_REGFILE__V
