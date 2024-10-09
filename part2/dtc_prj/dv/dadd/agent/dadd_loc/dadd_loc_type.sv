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
//     File for dadd_loc_type.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_TYPE__SV
`define DADD_LOC_TYPE__SV

typedef bit [`DADD_LOC_DATA_WIDTH-1:0] dadd_loc_data_t;
typedef bit [`DADD_LOC_ADDR_WIDTH-1:0] dadd_loc_addr_t;

typedef enum bit {
    DADD_LOC_READ,
    DADD_LOC_WRITE
} dadd_loc_direction_e;

`endif //DADD_LOC_TYPE__SV
