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
//     File for dsel_loc_interface.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_INTERFACE__SV
`define DSEL_LOC_INTERFACE__SV
`include "dsel_loc_define.sv"
interface dsel_loc_interface
(
    input logic clk,
    input logic reset_n
);

    logic        dsel_in_en;
    logic [31:0] dsel_in;
    logic [31:0] dsel_in_addr;


    //master mode
    clocking mcb @ (posedge clk);
        default input #`DSEL_LOC_MASTER_INPUT_TIME output #`DSEL_LOC_MASTER_OUTPUT_TIME;
        output dsel_in_en;
        output dsel_in_addr;
        output dsel_in;
    endclocking: mcb

    //passive mode
    clocking pcb @ (posedge clk);
        default input #`DSEL_LOC_PASSIVE_INPUT_TIME output #`DSEL_LOC_PASSIVE_OUTPUT_TIME;
        input  dsel_in_en;
        input  dsel_in_addr;
        input  dsel_in;
    endclocking: pcb

    //for reset
    task force_reset_low();
        force `TB_TOP.reset_n= 0;
        #100ns;
        force `TB_TOP.reset_n= 1;
    endtask : force_reset_low

 endinterface: dsel_loc_interface

 `endif // DSEL_LOC_INTERFACE__SV
