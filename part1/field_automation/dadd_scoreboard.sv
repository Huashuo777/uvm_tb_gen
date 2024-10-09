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
//     File for dadd_scoreboard.sv                                                       
//----------------------------------------------------------------------------------
class dadd_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dadd_scoreboard)
    uvm_blocking_get_port #(dadd_item) exp_port;
    uvm_blocking_get_port #(dadd_item) act_port;
    dadd_item dadd_exp_queue[$];

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_scoreboard

function dadd_scoreboard :: new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dadd_scoreboard :: build_phase(uvm_phase phase);
    exp_port = new("exp_port", this);
    act_port = new("act_port", this);
endfunction : build_phase
task          dadd_scoreboard :: reset_phase(uvm_phase phase);
    dadd_exp_queue.delete();
endtask : reset_phase

task          dadd_scoreboard :: main_phase(uvm_phase phase);
    dadd_item dadd_exp_item, dadd_act_item, tmp_dadd_exp_item;
    fork
        while(1)
        begin
          exp_port.get(dadd_exp_item);
          dadd_exp_queue.push_front(dadd_exp_item);
        end
        while(1)
        begin
            act_port.get(dadd_act_item);
            begin
                wait(dadd_exp_queue.size()>0);
                tmp_dadd_exp_item = dadd_exp_queue.pop_back();
                if(!tmp_dadd_exp_item.compare(dadd_act_item))
                begin
                    `uvm_error("dadd_scoreboard",$sformatf("Transaction miss match!\nExpect_addr:%h,Expect_data:%h\nActual_addr:%h,Expect_data:%h\n", tmp_dadd_exp_item.addr,tmp_dadd_exp_item.data,dadd_act_item.addr,dadd_act_item.data));
                end
                else 
                begin
                    `uvm_info("dadd_scoreboard","DADD_PASS",UVM_LOW);
                end
            end
        end
    join
endtask: main_phase
