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
//     File for tb_top.v                                                       
//----------------------------------------------------------------------------------
`timescale 1ns/1ps
module tb_top;
   wire         out ;
   reg          in0, in1 ;
   reg          clk ;


   initial begin
      clk = 0 ;
      forever begin
          #(10/2) clk = ~clk ;
      end
   end


   initial begin
      in0 = 0 ; in1 = 0 ;
      # 52 ;
      in0 = 1 ; in1 = 1 ;
      # 23 ;
      in0 = 1 ; in1 = 0 ;
   end


   top   u_top(
               .out     (out),
               .in0     (in0),
               .in1     (in1),
               .clk     (clk));


   initial begin
      forever begin
         #100;
         if ($time >= 1000)  $finish ;
      end
   end

  initial begin
    $vcdplusautoflushon;
    $vcdpluson();
  end

endmodule // tb_top
