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
//     File for dsel_loc_type.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_TYPE__SV
`define DSEL_LOC_TYPE__SV

typedef bit [`DSEL_LOC_DATA_WIDTH-1:0] dsel_loc_data_t;
typedef bit [`DSEL_LOC_ADDR_WIDTH-1:0] dsel_loc_addr_t;

typedef enum bit {
    DSEL_LOC_READ,
    DSEL_LOC_WRITE
} dsel_loc_direction_e;


`endif //DSEL_LOC_TYPE__SV
