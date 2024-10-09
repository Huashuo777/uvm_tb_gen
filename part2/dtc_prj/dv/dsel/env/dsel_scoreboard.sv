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
//     File for dsel_scoreboard.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_SCOREBOARD__SV
`define DSEL_SCOREBOARD__SV
class dsel_scoreboard extends uvm_scoreboard;
    uvm_blocking_get_port #(dsel_loc_item) dsel_loc_exp_port;
    uvm_blocking_get_port #(axi_master_item) axi_mst_act_port;
    dsel_env_config cfg;
    uvm_event_pool events;

    dsel_loc_item dsel_loc_exp_queue[$];
    `uvm_component_utils(dsel_scoreboard)

    extern                   function new(string name, uvm_component parent = null);
    extern           virtual function void build_phase(uvm_phase phase);
    extern           virtual task main_phase(uvm_phase phase);
    extern           virtual function void  connect_phase(uvm_phase phase);
    extern protected virtual function get_dsel_loc_item(input axi_master_item axi_item,output dsel_loc_item loc_item);
    extern task reset_phase(uvm_phase phase); 
endclass: dsel_scoreboard

function dsel_scoreboard :: new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dsel_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);

    dsel_loc_exp_port = new("dsel_loc_exp_port", this);
    axi_mst_act_port = new("axi_mst_act_port", this);
endfunction: build_phase

function void  dsel_scoreboard :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
endfunction : connect_phase

task dsel_scoreboard :: reset_phase(uvm_phase phase);
    dsel_loc_exp_queue.delete();
endtask : reset_phase

task dsel_scoreboard::main_phase(uvm_phase phase);
    dsel_loc_item dsel_loc_exp_item,dsel_loc_act_item;
    axi_master_item axi_mst_item;
    `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
    fork
        while(1)
        begin
            dsel_loc_exp_port.get(dsel_loc_exp_item);
            dsel_loc_exp_queue.push_front(dsel_loc_exp_item);
        end
        while(1)
        begin
            axi_mst_act_port.get(axi_mst_item);
            if(axi_mst_item.direction == 0)
            begin
                dsel_loc_item loc_item_tmp;
                get_dsel_loc_item(axi_mst_item,dsel_loc_act_item);
                wait(dsel_loc_exp_queue.size()>0);
                loc_item_tmp = dsel_loc_exp_queue.pop_back();
                if(~loc_item_tmp.compare(dsel_loc_act_item))
                begin
                    `uvm_error(get_type_name(), $sformatf("Transaction miss match!\nExpect:\n%0s\nActual:\n%0s\n",loc_item_tmp.sprint(),dsel_loc_act_item.sprint()))
                end
                else
                begin
                    `uvm_info(get_full_name(),$sformatf("DSEL_PASS"),UVM_LOW);
                end
            end
        end
    join
    `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
endtask: main_phase

function dsel_scoreboard :: get_dsel_loc_item(input axi_master_item axi_item,output dsel_loc_item loc_item);
    dsel_loc_item item_tmp;
    `uvm_info(get_type_name(),"Starting task get_dsel_loc_item...", UVM_HIGH)
    item_tmp = new();
    item_tmp.c_data = axi_item.c_data;
    item_tmp.c_addr = axi_item.c_addr;
    loc_item = item_tmp;
    `uvm_info(get_type_name(),"Finish task get_dsel_loc_item...", UVM_HIGH)
endfunction : get_dsel_loc_item

`endif // DSEL_SCOREBOARD__SV
