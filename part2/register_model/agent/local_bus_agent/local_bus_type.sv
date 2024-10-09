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
//     File for local_bus_type.sv                                                       
//----------------------------------------------------------------------------------
`ifndef LOCAL_BUS_TYPE
`define LOCAL_BUS_TYPE
typedef bit [`LOCAL_BUS_ADDR_WIDTH-1:0]   local_bus_addr_t;
typedef bit [`LOCAL_BUS_DATA_WIDTH-1:0]    local_bus_data_t;
typedef enum bit {
    READ,
    WRITE
} local_bus_direction_e;

typedef enum bit {
    AUTO,
    EXPLICIT
} forecast_mode_e;
`endif //LOCAL_BUS_TYPE
