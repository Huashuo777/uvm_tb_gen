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
//     File for top.v                                                       
//----------------------------------------------------------------------------------
module top(
   output  out,
   input   in0, in1, clk);

   wire            tmp_D0;
   wire            tmp_D1;
   ANDCELL         u_and(tmp_D0, in0, in1);
   DFLIPFLOPCELL   u_dflipflop0(tmp_D1, tmp_D0, clk);
   DFLIPFLOPCELL   u_dflipflop1(out,tmp_D1, clk);
endmodule
