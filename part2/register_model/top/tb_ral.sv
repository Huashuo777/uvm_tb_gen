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
//     File for tb_ral.sv                                                       
//----------------------------------------------------------------------------------
module tb_ral();
import uvm_pkg::*;

reg clk;
reg reset_n;
reg addr_en;
reg rw_direction;
reg [31:0] addr;
reg [31:0] wdata;
wire [31:0] rdata;

local_bus_interface local_bus_if();

initial 
begin
    uvm_config_db #(virtual local_bus_interface) :: set(null,"*","vif",local_bus_if);
    run_test();
end

initial
begin
    clk = 0;
    reset_n = 0;
    #10ns;
    reset_n = 1;
end

initial
begin
    forever 
    begin
        clk = #10ns ~clk;
    end
end

assign local_bus_if.clk = clk;
assign local_bus_if.reset_n = reset_n;

initial 
begin
    $vcdplusautoflushon;
    $vcdpluson();
end

//initial 
//begin
//    #500ns;
//    @(posedge clk);
//    force local_bus_if.rw_direction = 1;
//    force local_bus_if.addr_en= 1;
//    force local_bus_if.addr = 0;
//    force local_bus_if.wdata= 32'hdddd;
//    @(posedge clk);
//    force local_bus_if.rw_direction = 0;
//    force local_bus_if.addr_en= 0;
//    force local_bus_if.addr = 0;
//    force local_bus_if.wdata= 0;
//end

    
version_info vinfo_inst(
    .clk            (clk),
    .reset_n        (reset_n),
    .addr_en      (local_bus_if.addr_en),
    .rw_direction   (local_bus_if.rw_direction),
    .addr           (local_bus_if.addr),
    .wdata          (local_bus_if.wdata),
    .rdata          (local_bus_if.rdata),
    .rvalid         (local_bus_if.rvalid)
);
endmodule
