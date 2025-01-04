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
//     File for std_cell.v                                                       
//----------------------------------------------------------------------------------
module ANDCELL(
   output  Z,
   input   A, B);


   assign Z = A & B ;


   specify
      specparam t_rise = 1.3:1.5:1.7 ;
      specparam t_fall = 1.1:1.3:1.6 ;
      (A, B  *> Z) = (t_rise, t_fall) ;
   endspecify


endmodule

module DFLIPFLOPCELL(
            output      Q ,
            input       D, CP);


   reg                  Q_r ;
   always @(posedge CP)
     Q_r <= D ;
   assign       Q = Q_r ;


   specify
      if (D == 1'b1)
        (posedge CP => (Q +: D)) = (1.3:1.5:1.7, 1.1:1.4:1.9) ;
      if (D == 1'b0)
        (posedge CP => (Q +: D)) = (1.2:1.4:1.6, 1.0:1.3:1.8) ;
      $setup(D, posedge CP, 1);
   endspecify


endmodule
