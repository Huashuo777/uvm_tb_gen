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
//     File for dsel_data_handle.v                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_DATA_HANDLE__V
`define DSEL_DATA_HANDLE__V
module dsel_data_handle
    #(
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32
    )
    (
    input                           clk,
    input                           rst_n,
    input                           dsel_in_en_a,
    input       [LOC_DWIDTH-1:0]    dsel_in_a,
    input       [LOC_AWIDTH-1:0]    dsel_in_addr_a,
    input                           dsel_in_en_b,
    input       [LOC_DWIDTH-1:0]    dsel_in_b,
    input       [LOC_AWIDTH-1:0]    dsel_in_addr_b,
    input       [31:0]              reg_value,
    input reg  [LOC_AWIDTH-1:0]     dsel_in_addr,   
    input reg                       dsel_in_en,     
    output reg  [LOC_DWIDTH-1:0]    dsel_out   
    );                                          
    wire channle_sel;
    wire data_inv;
    reg [LOC_DWIDTH-1:0] ram_data_in;
    reg [LOC_AWIDTH-1:0] ram_addr_in;
    reg              ram_en_in;

    wire [LOC_DWIDTH-1:0] ram_data_out;
    wire [LOC_AWIDTH-1:0] ram_addr_out;
    wire              ram_en_out;

    assign channle_sel = reg_value[0];
    assign data_inv = reg_value[1];

    assign ram_addr_out = dsel_in_addr;
    assign ram_en_out = dsel_in_en;
    assign dsel_out = data_inv ? ~ram_data_out: ram_data_out;

    always @ (posedge clk or negedge rst_n)
    begin
        if(~rst_n) 
        begin
            ram_data_in     <= 0;
            ram_addr_in     <= 0;
            ram_en_in       <= 0;
        end
        else if(~channle_sel) 
        begin
            ram_data_in   <= dsel_in_a;
            ram_addr_in   <= dsel_in_addr_a;
            ram_en_in     <= dsel_in_en_a;
        end
        else 
        begin
            ram_data_in   <= dsel_in_b;
            ram_addr_in   <= dsel_in_addr_b;
            ram_en_in     <= dsel_in_en_b;
        end
    end
    sram sram_32x32(
    .clk        (clk            ),
    .write_addr (ram_addr_in    ),
    .write_en   (ram_en_in      ),
    .write_data (ram_data_in    ),
    .read_addr  (ram_addr_out   ),
    .read_en    (ram_en_out     ),
    .read_data  (ram_data_out   )
    );

endmodule
`endif //DSEL_DATA_HANDLE__V
