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
module dadd
#(parameter AWIDTH = 32,DWIDTH = 32)
(
    input                   clk         ,
    input                   rst_n       ,
    input                   dadd_in_en      ,
    input      [DWIDTH-1:0] dadd_in         ,
    input      [AWIDTH-1:0] dadd_in_addr    ,
    output reg [DWIDTH-1:0] dadd_out        ,   
    output reg [AWIDTH-1:0] dadd_out_addr   ,
    output reg              dadd_out_en         
);                                          
always @ (posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        dadd_out_en     <= 0;
        dadd_out        <= 0; 
        dadd_out_addr   <= 0; 
    end
    else 
    begin
        dadd_out_en     <= dadd_in_en   ;
        dadd_out_addr   <= dadd_in_addr ;
        dadd_out        <= dadd_in+31'b1;
    end
end
endmodule
