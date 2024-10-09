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
//     File for dtc_loc_interface.sv                                                       
//----------------------------------------------------------------------------------
 `ifndef DTC_LOC_INTERFACE__SV
 `define DTC_LOC_INTERFACE__SV
`include "dtc_loc_define.sv"
 interface dtc_loc_interface
 (
     input logic clk,
     input logic reset_n
  );

    real  dtc_loc_clk_period = 10;

    logic         dadd_in_en  ; 
    logic [31:0]  dadd_in_addr; 
    logic [31:0]  dadd_in; 
    // master mode
    clocking mcb @ (posedge clk);
        default input #`DTC_LOC_MASTER_INPUT_TIME output #`DTC_LOC_MASTER_OUTPUT_TIME;
        output dadd_in_en;
        output dadd_in;
        output dadd_in_addr;
    endclocking: mcb

    // passive mode
    clocking pcb @ (posedge clk);
        default input #`DTC_LOC_PASSIVE_INPUT_TIME output #`DTC_LOC_PASSIVE_OUTPUT_TIME;
        input dadd_in_en;
        input dadd_in;
        input dadd_in_addr;
    endclocking: pcb

    //for reset
    task force_reset_low();
        force `TB_TOP.reset_n= 0;
        #100ns;
        force `TB_TOP.reset_n= 1;
    endtask : force_reset_low

 endinterface: dtc_loc_interface

 `endif // DTC_LOC_INTERFACE__SV
