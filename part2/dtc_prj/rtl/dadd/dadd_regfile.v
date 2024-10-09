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
//     File for dadd_regfile.v                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_REGFILE__V
`define DADD_REGFILE__V
module dadd_regfile
    #(
    parameter APB_AWIDTH = 32,
    parameter APB_DWIDTH = 32
    )
    (
    input               pclk         ,
    input               rst_n       ,
    //apb interface
    input               psel        ,
    input [APB_AWIDTH-1:0]        paddr       ,
    input               penable     ,
    input               pwrite      ,
    input [APB_DWIDTH-1:0]        pwdata      ,
    output              pready      ,
    output reg [APB_DWIDTH-1:0]   prdata      ,
    
    output [31:0]       reg_value   
    );
    wire dadd_en;
    wire [4:0] addend_value;
    assign dadd_reg_write_0 = pready && psel && penable && pwrite && (paddr == `DADD_REG_ADDR_OFFSET_0);
    assign dadd_reg_read_0 = psel && ~pwrite && (paddr == `DADD_REG_ADDR_OFFSET_0);
    assign reg_value = {addend_value,dadd_en};
    assign pready = 1;
    always @(posedge pclk or negedge rst_n)
    if(~rst_n)
        prdata <= 0;
    else if(dadd_reg_read_0)
        prdata <= reg_value;
    else
        prdata <= prdata;

    apb_rw_reg #(1,0) dadd_en_field(
    .pclk       (pclk),
    .rst_n      (rst_n),
    .wr_en      (dadd_reg_write_0),
    .pwdata     (pwdata[0]),
    .reg_data   (dadd_en)
    );
    apb_rw_reg #(5,1) addend_value_field(
    .pclk       (pclk),
    .rst_n      (rst_n),
    .wr_en      (dadd_reg_write_0),
    .pwdata     (pwdata[5:1]),
    .reg_data   (addend_value)
    );

endmodule
`endif //DADD_REGFILE__V
