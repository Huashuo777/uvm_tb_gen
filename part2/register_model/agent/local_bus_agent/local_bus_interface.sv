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
//     File for local_bus_interface.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_INTERFACE
`define LOCAL_BUS_INTERFACE
`include "local_bus_define.sv"
interface local_bus_interface();
    logic                       clk;
    logic                       reset_n;
    logic [`LOCAL_BUS_ADDR_WIDTH-1:0] addr;
    logic [`LOCAL_BUS_DATA_WIDTH-1:0] wdata;
    logic [`LOCAL_BUS_DATA_WIDTH-1:0] rdata;
    logic                             rvalid;
    logic                       addr_en;
    logic                       rw_direction;

    // master mode
    clocking mcb @ (posedge clk);
        output  addr_en;
        output  addr;
        output  rw_direction;
        output  wdata;
        input   rdata;
        input   rvalid;
    endclocking: mcb

    // passive mode
    clocking pcb @ (posedge clk);
        input  addr_en;
        input  addr;
        input  rw_direction;
        input  wdata;
        input  rdata;
        input  rvalid;
    endclocking: pcb

endinterface : local_bus_interface
`endif //LOCAL_BUS_INTERFACE
