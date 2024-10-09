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
//     File for dadd_driver.sv                                                       
//----------------------------------------------------------------------------------
class dadd_driver extends uvm_driver #(dadd_item);
    extern function new(string name ="dadd_driver", uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
endclass: dadd_driver

function dadd_driver :: new(string name ="dadd_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

task dadd_driver :: main_phase(uvm_phase phase);
    dadd_item item;
    item = new();
    wait(tb_dadd.dadd_if.reset_n);
    @(posedge tb_dadd.dadd_if.clk);
    forever 
    begin
        item.randomize();
        if(item.data_en)
        begin
            tb_dadd.dadd_if.mcb.dadd_in_en <= item.data_en;
            tb_dadd.dadd_if.mcb.dadd_in <= item.data;
            tb_dadd.dadd_if.mcb.dadd_in_addr <= item.addr;
        end
        else 
        begin
            tb_dadd.dadd_if.mcb.dadd_in_en <= 0;
            tb_dadd.dadd_if.mcb.dadd_in <= 0;
            tb_dadd.dadd_if.mcb.dadd_in_addr <= 0;
        end
        @(posedge tb_dadd.dadd_if.clk);
        tb_dadd.dadd_if.dadd_in_en      <= 0 ;
        tb_dadd.dadd_if.dadd_in_addr    <= 0 ;
        tb_dadd.dadd_if.dadd_in         <= 0 ;
    end
endtask: main_phase
