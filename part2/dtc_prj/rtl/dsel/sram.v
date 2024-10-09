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
//     File for sram.v                                                       
//----------------------------------------------------------------------------------
`ifndef SRAM__V
`define SRAM__V
module sram #(
    parameter AWIDTH = 32,
    parameter DWIDTH = 32,
    parameter DEPTH  = 1024*4
)(  
    input               clk,  
    input [AWIDTH-1:0]  write_addr,  
    input               write_en,  
    input [DWIDTH-1:0]  write_data,
    input [AWIDTH-1:0]  read_addr,  
    input               read_en,  
    output reg [DWIDTH-1:0] read_data
);  
    reg [DWIDTH-1:0] memory [0:DEPTH-1];  
    always @(posedge clk) 
    begin    
        if (write_en) 
        begin      
            memory[write_addr] <= write_data;    
        end  
    end

    always @(posedge clk) 
    begin    
        if (read_en) 
        begin      
            read_data<= memory[read_addr];    
        end  
    end
endmodule
`endif //SRAM__V
