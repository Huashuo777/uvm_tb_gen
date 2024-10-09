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
//     File for apb_rw_reg.v                                                       
//----------------------------------------------------------------------------------
`ifndef APB_RW_REG__V
`define APB_RW_REG__V
module apb_rw_reg
    #(parameter width =32, init_val = {width{1'b0}}) 
    (
    input                pclk,
    input                rst_n,
    input                wr_en,
    input  [width-1:0]   pwdata,
    output [width-1:0]   reg_data
    );
    reg [width-1:0] REG_data;
    always @ (posedge pclk or negedge rst_n)
    begin
        if(~rst_n) 
        begin
            REG_data <= init_val;
        end
        else if(wr_en)
        begin
            REG_data <= pwdata;
        end
    end 
    assign reg_data = REG_data;
endmodule
`endif //APB_RW_REG__V
