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
`ifndef DADD_SCOREBOARD__SV
`define DADD_SCOREBOARD__SV

class dadd_scoreboard extends uvm_scoreboard;
    uvm_blocking_get_port #(dadd_loc_item) dadd_loc_exp_port;
    uvm_blocking_get_port #(dadd_loc_item) dadd_loc_act_port;
    `uvm_component_utils(dadd_scoreboard)
    dadd_loc_item dadd_loc_exp_queue[$];
    dadd_env_config cfg;

    extern          function new(string name, uvm_component parent = null);
    extern virtual  function void build_phase(uvm_phase phase);
    extern virtual  task main_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase); 
endclass: dadd_scoreboard

function dadd_scoreboard :: new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dadd_scoreboard :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    dadd_loc_exp_port = new("dadd_loc_exp_port", this);
    dadd_loc_act_port = new("dadd_loc_act_port", this);
endfunction: build_phase

task dadd_scoreboard :: reset_phase(uvm_phase phase);
    dadd_loc_exp_queue.delete();
endtask : reset_phase

task dadd_scoreboard :: main_phase(uvm_phase phase);
    dadd_loc_item dadd_loc_exp_item, dadd_loc_act_item, tmp_dadd_loc_exp_item;
    `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
    fork
        while(1)
        begin
          dadd_loc_exp_port.get(dadd_loc_exp_item);
          dadd_loc_exp_queue.push_front(dadd_loc_exp_item);
        end
        while(1)
        begin
            dadd_loc_act_port.get(dadd_loc_act_item);
            if(dadd_loc_act_item.direction == DADD_LOC_READ)
            begin
                wait(dadd_loc_exp_queue.size()>0);
                tmp_dadd_loc_exp_item = dadd_loc_exp_queue.pop_back();
                if(!tmp_dadd_loc_exp_item.compare(dadd_loc_act_item))
                begin
                    `uvm_error(get_type_name(), $sformatf("Transaction miss match!\nExpect:\n%0s\nActual:\n%0s\n", tmp_dadd_loc_exp_item.sprint(),dadd_loc_act_item.sprint()))
                end
                else 
                begin
                    `uvm_info(get_full_name(),$sformatf("DADD_PASS"),UVM_LOW);
                end
            end
        end
    join
    `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
endtask: main_phase


`endif // DADD_SCOREBOARD__SV
