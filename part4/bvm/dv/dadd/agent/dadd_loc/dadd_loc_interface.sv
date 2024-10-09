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
//     File for dadd_loc_interface.sv                                                       
//----------------------------------------------------------------------------------
 `ifndef DADD_LOC_INTERFACE__SVI
 `define DADD_LOC_INTERFACE__SVI

 interface dadd_loc_interface
 (
     input logic clk,
     input logic reset_n
  );

    logic         dadd_in_en  ; 
    logic [31:0]  dadd_in_addr; 
    logic [31:0]  dadd_in; 
    logic [31:0]  dadd_out_addr;    
    logic [31:0]  dadd_out;    
    logic         dadd_out_en;  
    // master mode
    clocking mcb @ (posedge clk);
        output dadd_in_en;
        output dadd_in;
        output dadd_in_addr;
        input  dadd_out;
        input  dadd_out_addr;
        input  dadd_out_en;
    endclocking: mcb

    // slave mode
    clocking scb @ (posedge clk);
        input dadd_in_en;
        input dadd_in;
        input  dadd_in_addr;
        output dadd_out;
        output dadd_out_addr;
        output dadd_out_en;
    endclocking: scb

    // passive mode
    clocking pcb @ (posedge clk);
        input dadd_in_en;
        input dadd_in;
        input dadd_in_addr;
        input dadd_out;
        input dadd_out_addr;
        input dadd_out_en;
    endclocking: pcb

 endinterface: dadd_loc_interface

 `endif // DADD_LOC_INTERFACE__SVI
