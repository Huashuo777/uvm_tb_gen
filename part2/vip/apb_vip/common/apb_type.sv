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
//     File for apb_type.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_TYPE__SV
`define APB_TYPE__SV
typedef bit [`APB_ADDR_WIDTH-1:0]   apb_addr_t;
typedef bit [`APB_DATA_WIDTH-1:0]    apb_data_t;
typedef enum bit {
    False,
    True
} bool;
typedef enum bit {
    READ,
    WRITE
} apb_direction_e;

typedef enum bit {
    OKAY,
    ERROR
} apb_response_e;

`endif //APB_TYPE__SV
