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
//     File for version_info.v                                                       
//----------------------------------------------------------------------------------
module version_info(
    input           clk,
    input           reset_n,
    input           addr_en,
    input           rw_direction,
    input [31:0]    addr,
    input [31:0]    wdata,
    output [31:0]   rdata,
    output          rvalid
);
reg [15:0] version;

reg [31:0] rdata_tmp;
reg rvalid_tmp;
reg rvalid_f;
reg rvalid_ff;
always @(posedge clk or negedge reset_n)
    if(!reset_n)
    begin
        version <= 16'hffff;
        rdata_tmp <=0;
        rvalid_f <=0;
    end
    else
        if(addr_en)
        begin
            if(rw_direction) 
            begin
                if(addr == 32'h0)
                begin
                    version <= wdata;
                end
            end
            else
            begin
                if(addr == 32'h0)
                begin
                    rdata_tmp <= version;
                    rvalid_f <= 1;
                end
            end
        end
always @(posedge clk or negedge reset_n)
    if(!reset_n)
    begin
        rvalid_ff <= 0;
    end
    else
    begin
        rvalid_ff <= rvalid_f;
    end

assign rdata = rdata_tmp;
assign rvalid = rvalid_f ^ rvalid_ff;

endmodule
