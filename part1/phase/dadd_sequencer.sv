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
//     File for dadd_sequencer.sv                                                       
//----------------------------------------------------------------------------------
class dadd_sequencer extends uvm_sequencer #(dadd_item);
    `uvm_component_utils(dadd_sequencer)
    virtual dadd_interface vif;
    extern function new(string name ="dadd_sequencer", uvm_component parent);
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
endclass: dadd_sequencer

function dadd_sequencer :: new(string name ="dadd_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_sequencer :: build_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting build_phase");
endfunction : build_phase
function void dadd_sequencer :: connect_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting connect_phase");
    super.connect_phase(phase);//must add or error
endfunction : connect_phase
function void dadd_sequencer :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_sequencer :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_sequencer :: run_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting run_phase");
endtask : run_phase
task          dadd_sequencer :: pre_reset_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_sequencer :: reset_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting reset_phase");
endtask : reset_phase
task          dadd_sequencer :: post_reset_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_sequencer :: pre_configure_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_sequencer :: configure_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting configure_phase");
endtask : configure_phase
task          dadd_sequencer :: post_configure_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_sequencer :: pre_main_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_sequencer :: main_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting main_phase");
endtask: main_phase

task          dadd_sequencer :: post_main_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting post_main_phase");
endtask : post_main_phase
task          dadd_sequencer :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_sequencer :: shutdown_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_sequencer :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_sequencer :: extract_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting extract_phase");
endfunction : extract_phase
function void dadd_sequencer :: check_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting check_phase");
endfunction : check_phase
function void dadd_sequencer :: report_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting report_phase");
endfunction : report_phase
function void dadd_sequencer :: final_phase(uvm_phase phase);
    $display("dadd_sequencer, Starting final_phase");
endfunction : final_phase

