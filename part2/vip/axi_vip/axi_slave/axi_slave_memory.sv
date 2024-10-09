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
//     File for axi_slave_memory.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_SLAVE_MEMORY__SV
`define AXI_SLAVE_MEMORY__SV
class axi_slave_memory;
    protected axi_data_t val[axi_addr_t];

    extern function void write(input axi_addr_t addr,input axi_data_t data); 
    extern function void read(input axi_addr_t addr,output axi_data_t data); 
endclass : axi_slave_memory

function void axi_slave_memory :: write(input axi_addr_t addr,input axi_data_t data);
    val[addr] = data;
endfunction : write

function void axi_slave_memory :: read(input axi_addr_t addr,output axi_data_t data);
    if(val.exists(addr))
        data = val[addr];
    else 
        data = addr;
endfunction : read

`endif //AXI_SLAVE_MEMORY__SV
