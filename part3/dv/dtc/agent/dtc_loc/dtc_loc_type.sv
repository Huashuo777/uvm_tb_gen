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
//     File for dtc_loc_type.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_TYPE__SV
`define DTC_LOC_TYPE__SV

typedef bit [`DTC_LOC_DATA_WIDTH-1:0] dtc_loc_data_t;
typedef bit [`DTC_LOC_ADDR_WIDTH-1:0] dtc_loc_addr_t;

typedef enum bit {
    DTC_LOC_READ,
    DTC_LOC_WRITE
} dtc_loc_direction_e;


`endif //DTC_LOC_TYPE__SV
