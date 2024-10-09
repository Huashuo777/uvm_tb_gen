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
//     File for apb_master_interface.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_MASTER_INTERFACE__SV
`define APB_MASTER_INTERFACE__SV
interface apb_master_interface();
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

    // master mode
    clocking mcb @ (posedge pclk);
        //default input #`APB_MASTER_INPUT_TIME output #`APB_MASTER_OUTPUT_TIME;
        output  psel;
        output  penable;
        output  paddr;
        output  pwrite;
        output  pwdata;
        input   prdata;
        input   pready;
        input   pslverr;
    endclocking: mcb

    // passive mode
    clocking pcb @ (posedge pclk);
        default input #`APB_PASSIVE_INPUT_TIME output #`APB_PASSIVE_INPUT_TIME;
        input psel;
        input penable;
        input paddr;
        input pwrite;
        input pwdata;
        input prdata;
        input pready;
        input pslverr;
    endclocking: pcb

endinterface : apb_master_interface
`endif //APB_MASTER_INTERFACE__SV
