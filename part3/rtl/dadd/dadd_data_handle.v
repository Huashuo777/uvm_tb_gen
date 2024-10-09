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
//     File for dadd_data_handle.v                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_DATA_HANDLE__V
`define DADD_DATA_HANDLE__V
module dadd_data_handle
    #(
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32
    )
    (
    input                   clk         ,
    input                   rst_n       ,
    input                   dadd_in_en      ,
    input      [LOC_DWIDTH-1:0] dadd_in         ,
    input      [LOC_AWIDTH-1:0] dadd_in_addr    ,
    input      [31:0]       reg_value,
    output reg [LOC_DWIDTH-1:0] dadd_out        ,   
    output reg [LOC_AWIDTH-1:0] dadd_out_addr   ,
    output reg              dadd_out_en         
    );                                          
    wire dadd_enable;
    wire [6:0] addend;
    assign dadd_enable = reg_value[0];
    assign addend = reg_value[5:1];
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
            if(dadd_enable)
            begin
                dadd_out        <= dadd_in+addend;
            end
            else
            begin
                dadd_out        <= dadd_in;
            end
        end
    end
endmodule
`endif // DADD_DATA_HANDLE__V
