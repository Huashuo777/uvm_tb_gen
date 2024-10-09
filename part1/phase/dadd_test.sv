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
//     File for dadd_test.sv                                                       
//----------------------------------------------------------------------------------
class dadd_rand_test extends uvm_test;
    `uvm_component_utils(dadd_rand_test)
    dadd_environment env;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_rand_test",uvm_component parent = null);
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
endclass: dadd_rand_test

function dadd_rand_test :: new(string name ="dadd_rand_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_rand_test :: build_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting build_phase");
    seq = dadd_rand_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase
function void dadd_rand_test :: connect_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting connect_phase");
endfunction : connect_phase
function void dadd_rand_test :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_rand_test :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_rand_test :: run_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting run_phase");
endtask : run_phase
task          dadd_rand_test :: pre_reset_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_rand_test :: reset_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting reset_phase");
endtask : reset_phase
task          dadd_rand_test :: post_reset_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_rand_test :: pre_configure_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_rand_test :: configure_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting configure_phase");
endtask : configure_phase
task          dadd_rand_test :: post_configure_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_rand_test :: pre_main_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_rand_test :: main_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting main_phase");
    super.main_phase(phase);
    phase.raise_objection(this);
    #100ns;
    seq.start(env.iagt.sqr);
    phase.drop_objection(this);
endtask: main_phase

task          dadd_rand_test :: post_main_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting post_main_phase");
endtask : post_main_phase
task          dadd_rand_test :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_rand_test :: shutdown_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_rand_test :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_rand_test :: extract_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting extract_phase");
endfunction : extract_phase
function void dadd_rand_test :: check_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting check_phase");
endfunction : check_phase
function void dadd_rand_test :: report_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting report_phase");
endfunction : report_phase
function void dadd_rand_test :: final_phase(uvm_phase phase);
    $display("dadd_rand_test, Starting final_phase");
endfunction : final_phase
//reset case
class dadd_reset_test extends uvm_test;
    `uvm_component_utils(dadd_reset_test)
    dadd_environment env;
    dadd_rand_sequence seq;
    extern function new(string name ="dadd_reset_test",uvm_component parent = null);
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
endclass: dadd_reset_test

function dadd_reset_test :: new(string name ="dadd_reset_test",uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void dadd_reset_test :: build_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting build_phase");
    seq = dadd_rand_sequence :: type_id :: create("seq");
    env = dadd_environment :: type_id :: create("env",this);
endfunction : build_phase
function void dadd_reset_test :: connect_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting connect_phase");
endfunction : connect_phase
function void dadd_reset_test :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_reset_test :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_reset_test :: run_phase(uvm_phase phase);
    #150ns;
    force tb_dadd.dadd_if.reset_n = 0;
    #20ns;
    force tb_dadd.dadd_if.reset_n = 1;
    $display("dadd_reset_test, Starting run_phase");
endtask : run_phase
task          dadd_reset_test :: pre_reset_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_reset_test :: reset_phase(uvm_phase phase);
    env.iagt.sqr.stop_sequences();
    $display("dadd_reset_test, Starting reset_phase");
endtask : reset_phase
task          dadd_reset_test :: post_reset_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_reset_test :: pre_configure_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_reset_test :: configure_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting configure_phase");
endtask : configure_phase
task          dadd_reset_test :: post_configure_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_reset_test :: pre_main_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_reset_test :: main_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting main_phase");
    super.main_phase(phase);
    phase.raise_objection(this);
    seq.start(env.iagt.sqr);
    phase.drop_objection(this);
endtask: main_phase

task          dadd_reset_test :: post_main_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting post_main_phase");
endtask : post_main_phase
task          dadd_reset_test :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_reset_test :: shutdown_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_reset_test :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_reset_test :: extract_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting extract_phase");
endfunction : extract_phase
function void dadd_reset_test :: check_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting check_phase");
endfunction : check_phase
function void dadd_reset_test :: report_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting report_phase");
endfunction : report_phase
function void dadd_reset_test :: final_phase(uvm_phase phase);
    $display("dadd_reset_test, Starting final_phase");
endfunction : final_phase
