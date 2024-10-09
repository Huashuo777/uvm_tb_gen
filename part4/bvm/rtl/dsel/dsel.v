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
//     File for dsel.v                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL__V
`define DSEL__V
module dsel
#(parameter AWIDTH = 32,DWIDTH = 32)
(
    input                   clk,
    input                   rst_n,
    input                   dsel_sel,
    input                   dsel_in_en_a,
    input      [DWIDTH-1:0] dsel_in_a,
    input      [AWIDTH-1:0] dsel_in_addr_a,
    input                   dsel_in_en_b,
    input      [DWIDTH-1:0] dsel_in_b,
    input      [AWIDTH-1:0] dsel_in_addr_b,
    output reg [DWIDTH-1:0] dsel_out,   
    output reg [AWIDTH-1:0] dsel_out_addr,   
    output reg              dsel_out_en      
);                                          
always @ (posedge clk or negedge rst_n)
begin
    if(~rst_n) 
    begin
        dsel_out_en     <= 0;
        dsel_out_addr   <= 0;
        dsel_out        <= 0;
    end
    else if(~dsel_sel) 
    begin
        dsel_out_en     <= dsel_in_en_a;
        dsel_out_addr   <= dsel_in_addr_a;
        dsel_out        <= dsel_in_a;
    end
    else 
    begin
        dsel_out_en     <= dsel_in_en_b;
        dsel_out_addr   <= dsel_in_addr_b;
        dsel_out        <= dsel_in_b;
    end
end
endmodule
`endif //DSEL__V
