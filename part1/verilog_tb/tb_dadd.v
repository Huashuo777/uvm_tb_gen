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
//     File for tb_dadd.v                                                       
//----------------------------------------------------------------------------------
`ifndef TB_DADD__SV
`define TB_DADD__SV

`timescale 1ns/100ps
module tb_dadd;
    real  clk_period = 10;
    reg clk;
    reg reset_n;

    reg         dadd_in_en  ;
    reg [31:0]  dadd_in_addr;
    reg [31:0]  dadd_in     ;

    wire        dadd_out_en  ; 
    wire [31:0] dadd_out_addr;
    wire [31:0] dadd_out     ;


    initial
    begin
        $timeformat(-9, 2,"ns", 10);
    end
    
    always #(clk_period/2.0) clk = ~ clk;

    initial 
    begin
        clk = 0;
    end

    initial
    begin
        reset_n = 0;
        #10;
        reset_n = 1;
    end

    initial begin
        $vcdplusautoflushon;
        $vcdpluson();
    end

    initial
    begin
        dadd_in_en  <= 0;
        dadd_in_addr<= 0;
        dadd_in     <= 0;
        #5;
        @(posedge clk);
        dadd_in_en  <= 1;
        dadd_in     <= 1;
        dadd_in_addr<= 1;
        @(posedge clk);
        dadd_in_en  <= 0;
        dadd_in     <= 0;
        dadd_in_addr<= 0;
        @(posedge clk);
        dadd_in_en  <= 1;
        dadd_in     <= 2;
        dadd_in_addr<= 2;
        @(posedge clk);
        dadd_in_en  <= 0;
        dadd_in     <= 0;
        dadd_in_addr<= 0;
        #100;
        $finish();
    end

    dadd dadd_inst
    (
        .clk           (clk),
        .rst_n         (reset_n),
        .dadd_in_en    (dadd_in_en ),
        .dadd_in_addr  (dadd_in_addr),
        .dadd_in       (dadd_in),
        .dadd_out      (dadd_out   ),
        .dadd_out_addr (dadd_out_addr),
        .dadd_out_en   (dadd_out_en)
    );

endmodule

`endif // TB_DADD__SV
