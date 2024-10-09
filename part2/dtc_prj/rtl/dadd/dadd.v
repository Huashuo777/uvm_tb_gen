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
//     File for dadd.v                                                       
//----------------------------------------------------------------------------------
`ifndef DADD__V
`define DADD__V
module dadd
    #(
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32,
    parameter APB_AWIDTH = 32,
    parameter APB_DWIDTH = 32
    )
    (
    input                   clk         ,
    input                   rst_n       ,
    input                   dadd_in_en      ,
    input      [LOC_DWIDTH-1:0] dadd_in         ,
    input      [LOC_AWIDTH-1:0] dadd_in_addr    ,
    output reg [LOC_DWIDTH-1:0] dadd_out        ,   
    output reg [LOC_AWIDTH-1:0] dadd_out_addr   ,
    output reg              dadd_out_en        , 
    //apb interface
    input                   psel            ,
    input [APB_AWIDTH-1:0]            paddr           ,
    input                   penable         ,
    input                   pwrite          ,
    input [APB_DWIDTH-1:0]            pwdata          ,
    output                  pready          ,
    output reg [APB_DWIDTH-1:0]       prdata          
    );
    wire [31:0] reg_value;

    dadd_data_handle dadd_data_handle_inst
    (
        .clk        (clk      ),
        .rst_n      (rst_n    ),
        .dadd_in_en     (dadd_in_en   ),
        .dadd_in        (dadd_in      ),
        .dadd_in_addr   (dadd_in_addr ),
        .reg_value      (reg_value    ),
        .dadd_out       (dadd_out     ),   
        .dadd_out_addr  (dadd_out_addr),
        .dadd_out_en    (dadd_out_en  )    
    );                                          
    dadd_regfile dadd_regfile_inst
    (
        .pclk           (clk  ),
        .rst_n          (rst_n),
        .psel           (psel     ),
        .paddr          (paddr    ),
        .penable        (penable  ),
        .pwrite         (pwrite   ),
        .pwdata         (pwdata   ),
        .pready         (pready   ),
        .prdata         (prdata   ),
        .reg_value      (reg_value)
    );
endmodule
`endif//DADD__V
