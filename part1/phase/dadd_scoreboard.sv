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
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    extern task          run_phase(uvm_phase phase);
    extern task          pre_reset_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern task          post_reset_phase(uvm_phase phase);
    extern task          pre_configure_phase(uvm_phase phase);
    extern task          configure_phase(uvm_phase phase);
    extern task          post_configure_phase(uvm_phase phase);
    extern task          pre_main_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
    extern task          post_main_phase(uvm_phase phase);
    extern task          pre_shutdown_phase(uvm_phase phase);
    extern task          shutdown_phase(uvm_phase phase);
    extern task          post_shutdown_phase(uvm_phase phase);
    extern function void extract_phase(uvm_phase phase);
    extern function void check_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    extern function void final_phase(uvm_phase phase);
endclass: dadd_scoreboard

function dadd_scoreboard :: new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dadd_scoreboard :: build_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting build_phase");
    exp_port = new("exp_port", this);
    act_port = new("act_port", this);
endfunction : build_phase
function void dadd_scoreboard :: connect_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting connect_phase");
endfunction : connect_phase
function void dadd_scoreboard :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_scoreboard :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_scoreboard :: run_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting run_phase");
endtask : run_phase
task          dadd_scoreboard :: pre_reset_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_scoreboard :: reset_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting reset_phase");
    dadd_exp_queue.delete();
endtask : reset_phase
task          dadd_scoreboard :: post_reset_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_scoreboard :: pre_configure_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_scoreboard :: configure_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting configure_phase");
endtask : configure_phase
task          dadd_scoreboard :: post_configure_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_scoreboard :: pre_main_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_scoreboard :: main_phase(uvm_phase phase);
    dadd_item dadd_exp_item, dadd_act_item, tmp_dadd_exp_item;
    $display("dadd_scoreboard, Starting main_phase");
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
                if((tmp_dadd_exp_item.addr != dadd_act_item.addr) && (tmp_dadd_exp_item.data != dadd_act_item.data))
                begin
                    $display($sformatf("Transaction miss match!\nExpect_addr:%h,Expect_data:%h\nActual_addr:%h,Expect_data:%h\n", tmp_dadd_exp_item.addr,tmp_dadd_exp_item.data,dadd_act_item.addr,dadd_act_item.data));
                end
                else 
                begin
                    //$display("DADD_PASS");
                end
            end
        end
    join
endtask: main_phase

task          dadd_scoreboard :: post_main_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting post_main_phase");
endtask : post_main_phase
task          dadd_scoreboard :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_scoreboard :: shutdown_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_scoreboard :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_scoreboard :: extract_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting extract_phase");
endfunction : extract_phase
function void dadd_scoreboard :: check_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting check_phase");
endfunction : check_phase
function void dadd_scoreboard :: report_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting report_phase");
endfunction : report_phase
function void dadd_scoreboard :: final_phase(uvm_phase phase);
    $display("dadd_scoreboard, Starting final_phase");
endfunction : final_phase
