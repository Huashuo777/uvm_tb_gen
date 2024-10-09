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
//     File for dadd_environment.sv                                                       
//----------------------------------------------------------------------------------
class dadd_environment extends uvm_env;
    `uvm_component_utils(dadd_environment)
    dadd_iagent iagt;
    dadd_oagent oagt;
    dadd_refmodel refmdl;
    dadd_scoreboard scb;
    uvm_tlm_analysis_fifo #(dadd_item) dadd_iagt_to_refmdl_fifo;
    uvm_tlm_analysis_fifo #(dadd_item) dadd_oagt_to_scb_fifo;
    uvm_tlm_analysis_fifo #(dadd_item) dadd_refmdl_to_scb_fifo;
    extern function new(string name ="dadd_environment", uvm_component parent);
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
endclass: dadd_environment

function dadd_environment :: new(string name ="dadd_environment", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_environment :: build_phase(uvm_phase phase);
    $display("dadd_environment, Starting build_phase");
    iagt = dadd_iagent :: type_id :: create("iagt",this);
    oagt = dadd_oagent :: type_id :: create("oagt",this);
    refmdl = dadd_refmodel :: type_id :: create("refmdl",this);
    scb =  dadd_scoreboard :: type_id :: create("scb",this);
    dadd_iagt_to_refmdl_fifo = new("dadd_iagt_to_refmdl_fifo",this);
    dadd_oagt_to_scb_fifo = new("dadd_oagt_to_scb_fifo",this);
    dadd_refmdl_to_scb_fifo = new("dadd_refmdl_to_scb_fifo",this);
endfunction : build_phase
function void dadd_environment :: connect_phase(uvm_phase phase);
    $display("dadd_environment, Starting connect_phase");
    iagt.ap.connect(dadd_iagt_to_refmdl_fifo.analysis_export);                                                                                                                                                          
    refmdl.port.connect(dadd_iagt_to_refmdl_fifo.blocking_get_export);

    oagt.ap.connect(dadd_oagt_to_scb_fifo.analysis_export);                                                                                                                                                          
    scb.act_port.connect(dadd_oagt_to_scb_fifo.blocking_get_export);

    refmdl.ap.connect(dadd_refmdl_to_scb_fifo.analysis_export);
    scb.exp_port.connect(dadd_refmdl_to_scb_fifo.blocking_get_export);
endfunction : connect_phase
function void dadd_environment :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_environment, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_environment :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_environment, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_environment :: run_phase(uvm_phase phase);
    $display("dadd_environment, Starting run_phase");
endtask : run_phase
task          dadd_environment :: pre_reset_phase(uvm_phase phase);
    $display("dadd_environment, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_environment :: reset_phase(uvm_phase phase);
    $display("dadd_environment, Starting reset_phase");
    dadd_iagt_to_refmdl_fifo.flush();
    dadd_oagt_to_scb_fifo.flush();
    dadd_refmdl_to_scb_fifo.flush();
endtask : reset_phase
task          dadd_environment :: post_reset_phase(uvm_phase phase);
    $display("dadd_environment, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_environment :: pre_configure_phase(uvm_phase phase);
    $display("dadd_environment, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_environment :: configure_phase(uvm_phase phase);
    $display("dadd_environment, Starting configure_phase");
endtask : configure_phase
task          dadd_environment :: post_configure_phase(uvm_phase phase);
    $display("dadd_environment, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_environment :: pre_main_phase(uvm_phase phase);
    $display("dadd_environment, Starting pre_main_phase");
endtask : pre_main_phase

task dadd_environment :: main_phase(uvm_phase phase);
    $display("dadd_environment, Starting main_phase");
endtask: main_phase

task          dadd_environment :: post_main_phase(uvm_phase phase);
    $display("dadd_environment, Starting post_main_phase");
endtask : post_main_phase
task          dadd_environment :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_environment, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_environment :: shutdown_phase(uvm_phase phase);
    $display("dadd_environment, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_environment :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_environment, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_environment :: extract_phase(uvm_phase phase);
    $display("dadd_environment, Starting extract_phase");
endfunction : extract_phase
function void dadd_environment :: check_phase(uvm_phase phase);
    $display("dadd_environment, Starting check_phase");
endfunction : check_phase
function void dadd_environment :: report_phase(uvm_phase phase);
    $display("dadd_environment, Starting report_phase");
endfunction : report_phase
function void dadd_environment :: final_phase(uvm_phase phase);
    $display("dadd_environment, Starting final_phase");
endfunction : final_phase
