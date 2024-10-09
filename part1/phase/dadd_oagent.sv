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
//     File for dadd_oagent.sv                                                       
//----------------------------------------------------------------------------------
class dadd_oagent extends uvm_agent;
    `uvm_component_utils(dadd_oagent)

    uvm_analysis_port #(dadd_item) ap;
    dadd_omonitor   omon;

    extern function new(string name ="dadd_oagent", uvm_component parent);
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
endclass: dadd_oagent

function dadd_oagent :: new(string name ="dadd_oagent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_oagent :: build_phase(uvm_phase phase);
    $display("dadd_oagent, Starting build_phase");
    omon = dadd_omonitor :: type_id :: create("omon",this);
endfunction : build_phase
function void dadd_oagent :: connect_phase(uvm_phase phase);
    $display("dadd_oagent, Starting connect_phase");
    ap = omon.ap;
endfunction : connect_phase
function void dadd_oagent :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_oagent, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_oagent :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_oagent, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_oagent :: run_phase(uvm_phase phase);
    $display("dadd_oagent, Starting run_phase");
endtask : run_phase
task          dadd_oagent :: pre_reset_phase(uvm_phase phase);
    $display("dadd_oagent, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_oagent :: reset_phase(uvm_phase phase);
    $display("dadd_oagent, Starting reset_phase");
endtask : reset_phase
task          dadd_oagent :: post_reset_phase(uvm_phase phase);
    $display("dadd_oagent, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_oagent :: pre_configure_phase(uvm_phase phase);
    $display("dadd_oagent, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_oagent :: configure_phase(uvm_phase phase);
    $display("dadd_oagent, Starting configure_phase");
endtask : configure_phase
task          dadd_oagent :: post_configure_phase(uvm_phase phase);
    $display("dadd_oagent, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_oagent :: pre_main_phase(uvm_phase phase);
    $display("dadd_oagent, Starting pre_main_phase");
endtask : pre_main_phase
task          dadd_oagent :: main_phase(uvm_phase phase);
    $display("dadd_oagent, Starting main_phase");
endtask: main_phase
task          dadd_oagent :: post_main_phase(uvm_phase phase);
    $display("dadd_oagent, Starting post_main_phase");
endtask : post_main_phase
task          dadd_oagent :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_oagent, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_oagent :: shutdown_phase(uvm_phase phase);
    $display("dadd_oagent, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_oagent :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_oagent, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_oagent :: extract_phase(uvm_phase phase);
    $display("dadd_oagent, Starting extract_phase");
endfunction : extract_phase
function void dadd_oagent :: check_phase(uvm_phase phase);
    $display("dadd_oagent, Starting check_phase");
endfunction : check_phase
function void dadd_oagent :: report_phase(uvm_phase phase);
    $display("dadd_oagent, Starting report_phase");
endfunction : report_phase
function void dadd_oagent :: final_phase(uvm_phase phase);
    $display("dadd_oagent, Starting final_phase");
endfunction : final_phase
