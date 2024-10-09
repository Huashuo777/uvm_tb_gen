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
//     File for apb_slave_memory.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_SLAVE_MEMORY__SV
`define APB_SLAVE_MEMORY__SV
class apb_slave_memory;
    protected apb_data_t val[apb_addr_t];

    extern function void write(input apb_addr_t addr,input apb_data_t data); 
    extern function void read(input apb_addr_t addr,output apb_data_t data); 
endclass : apb_slave_memory

function void apb_slave_memory :: write(input apb_addr_t addr,input apb_data_t data);
    val[addr] = data;
endfunction : write

function void apb_slave_memory :: read(input apb_addr_t addr,output apb_data_t data);
    if(val.exists(addr))
        data = val[addr];
    else 
        data = addr;
endfunction : read

`endif //APB_SLAVE_MEMORY__SV
