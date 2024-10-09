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

class dadd_scoreboard extends bvm_component;
    `bvm_component_utils(dadd_scoreboard)
    dadd_loc_item dadd_loc_exp_queue[$];

    extern function new(string name, bvm_component parent = null);
    extern function void build_phase();
    extern task run_phase();
endclass: dadd_scoreboard

function dadd_scoreboard :: new(string name, bvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dadd_scoreboard :: build_phase();
    super.build_phase();
endfunction: build_phase

task dadd_scoreboard :: run_phase();
    dadd_loc_item dadd_loc_exp_item, dadd_loc_act_item, tmp_dadd_loc_exp_item;
    bvm_sequence_item exp_seq_item,act_seq_item;
    fork
        while(1)
        begin
          ref2scb_box.get(exp_seq_item);
          $cast(dadd_loc_exp_item,exp_seq_item);
          dadd_loc_exp_queue.push_front(dadd_loc_exp_item);
        end
        while(1)
        begin
            begin
                wait(dadd_loc_exp_queue.size()>0);
                omon2scb_box.get(act_seq_item);
                $cast(dadd_loc_act_item,act_seq_item);
                tmp_dadd_loc_exp_item = dadd_loc_exp_queue.pop_back();
                if(!(tmp_dadd_loc_exp_item.data == dadd_loc_act_item.data) && !(tmp_dadd_loc_exp_item.addr == dadd_loc_act_item.addr))
                begin
                    `bvm_error($sformatf("Transaction miss match!\nExpect:\n%0p\nActual:\n%0p\n", tmp_dadd_loc_exp_item,dadd_loc_act_item))
                end
                else 
                begin
                    `bvm_info("DADD_PASS",BVM_LOW)
                end
            end
        end
    join
endtask: run_phase

`endif // DADD_SCOREBOARD__SV
