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
//     File for apb_slave_interface.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_INTERFACE__SV
`define APB_SLAVE_INTERFACE__SV
interface apb_slave_interface();
    logic                       pclk;
    logic                       preset_n;
    logic [`APB_ADDR_WIDTH-1:0] paddr;
    logic                       penable;
    logic                       pwrite;
    logic [`APB_DATA_WIDTH-1:0] pwdata;
    logic [`APB_DATA_WIDTH-1:0] prdata;
    logic                       psel;
    logic                       pready;
    logic                       pslverr;

    // slave mode
    clocking scb @ (posedge pclk);
        //default input #`APB_SLAVE_INPUT_TIME output #`APB_SLAVE_OUTPUT_TIME;
        input  psel;
        input  penable;
        input  paddr;
        input  pwrite;
        input  pwdata;
        output prdata;
        output pready;
        output pslverr;
    endclocking: scb

    // passive mode
    clocking pcb @ (posedge pclk);
        default input #`APB_PASSIVE_INPUT_TIME output #`APB_PASSIVE_OUTPUT_TIME;
        input psel;
        input penable;
        input paddr;
        input pwrite;
        input pwdata;
        input prdata;
        input pready;
        input pslverr;
    endclocking: pcb

endinterface : apb_slave_interface
`endif //APB_SLAVE_INTERFACE__SV
