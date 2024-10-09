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
//     File for dadd_iagent.sv                                                       
//----------------------------------------------------------------------------------
class dadd_iagent extends uvm_agent;
    `uvm_component_utils(dadd_iagent)

    uvm_analysis_port #(dadd_item) ap;
    dadd_sequencer  sqr;
    dadd_driver     drv;
    dadd_imonitor   imon;

    extern function new(string name ="dadd_iagent", uvm_component parent);
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
endclass: dadd_iagent

function dadd_iagent :: new(string name ="dadd_iagent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_iagent :: build_phase(uvm_phase phase);
    $display("dadd_iagent, Starting build_phase");
    drv = dadd_driver :: type_id :: create("drv",this);
    sqr = dadd_sequencer :: type_id :: create("sqr",this);
    imon = dadd_imonitor :: type_id :: create("imon",this);
endfunction : build_phase
function void dadd_iagent :: connect_phase(uvm_phase phase);
    $display("dadd_iagent, Starting connect_phase");
    drv.seq_item_port.connect(sqr.seq_item_export);
    ap = imon.ap;
endfunction : connect_phase
function void dadd_iagent :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_iagent, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_iagent :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_iagent, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_iagent :: run_phase(uvm_phase phase);
    $display("dadd_iagent, Starting run_phase");
endtask : run_phase
task          dadd_iagent :: pre_reset_phase(uvm_phase phase);
    $display("dadd_iagent, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_iagent :: reset_phase(uvm_phase phase);
    $display("dadd_iagent, Starting reset_phase");
endtask : reset_phase
task          dadd_iagent :: post_reset_phase(uvm_phase phase);
    $display("dadd_iagent, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_iagent :: pre_configure_phase(uvm_phase phase);
    $display("dadd_iagent, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_iagent :: configure_phase(uvm_phase phase);
    $display("dadd_iagent, Starting configure_phase");
endtask : configure_phase
task          dadd_iagent :: post_configure_phase(uvm_phase phase);
    $display("dadd_iagent, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_iagent :: pre_main_phase(uvm_phase phase);
    $display("dadd_iagent, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_iagent :: main_phase(uvm_phase phase);
    $display("dadd_iagent, Starting main_phase");
endtask: main_phase

task          dadd_iagent :: post_main_phase(uvm_phase phase);
    $display("dadd_iagent, Starting post_main_phase");
endtask : post_main_phase
task          dadd_iagent :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_iagent, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_iagent :: shutdown_phase(uvm_phase phase);
    $display("dadd_iagent, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_iagent :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_iagent, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_iagent :: extract_phase(uvm_phase phase);
    $display("dadd_iagent, Starting extract_phase");
endfunction : extract_phase
function void dadd_iagent :: check_phase(uvm_phase phase);
    $display("dadd_iagent, Starting check_phase");
endfunction : check_phase
function void dadd_iagent :: report_phase(uvm_phase phase);
    $display("dadd_iagent, Starting report_phase");
endfunction : report_phase
function void dadd_iagent :: final_phase(uvm_phase phase);
    $display("dadd_iagent, Starting final_phase");
endfunction : final_phase
