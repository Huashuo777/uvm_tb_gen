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
//     File for dadd_fixen_driver.sv                                                       
//----------------------------------------------------------------------------------
class dadd_fixen_driver extends dadd_driver;
    `uvm_component_utils(dadd_fixen_driver)
    extern function new(string name ="dadd_fixen_driver", uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
endclass: dadd_fixen_driver

function dadd_fixen_driver :: new(string name ="dadd_fixen_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

task dadd_fixen_driver :: main_phase(uvm_phase phase);
    wait(tb_dadd.dadd_if.reset_n);
    forever 
    begin
        seq_item_port.get_next_item(req);
        @(posedge tb_dadd.dadd_if.clk);
        tb_dadd.dadd_if.mcb.dadd_in_en <= 1'b1;
        tb_dadd.dadd_if.mcb.dadd_in <= req.data;
        tb_dadd.dadd_if.mcb.dadd_in_addr <= req.addr;
        seq_item_port.item_done();
    end
endtask: main_phase
