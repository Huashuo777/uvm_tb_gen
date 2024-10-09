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
//     File for dadd_refmodel.sv                                                       
//----------------------------------------------------------------------------------
class dadd_refmodel extends uvm_component;
    `uvm_component_utils(dadd_refmodel)

    uvm_analysis_port #(dadd_item) ap;
    uvm_blocking_get_port #(dadd_item) port;

    extern function new(string name, uvm_component parent);
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
    extern task get_dadd_pkt(output dadd_item item); 
endclass: dadd_refmodel

function dadd_refmodel :: new(string name, uvm_component parent);
    super.new(name, parent);
endfunction: new

task dadd_refmodel :: get_dadd_pkt(output dadd_item item); 
    dadd_item item_tmp;
    port.get(item_tmp);
    item = new item_tmp;
endtask : get_dadd_pkt

function void dadd_refmodel :: build_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting build_phase");
    ap = new("ap",this);
    port = new("port", this);
endfunction : build_phase
function void dadd_refmodel :: connect_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting connect_phase");
endfunction : connect_phase
function void dadd_refmodel :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_refmodel :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_refmodel :: run_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting run_phase");
endtask : run_phase
task          dadd_refmodel :: pre_reset_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_refmodel :: reset_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting reset_phase");
endtask : reset_phase
task          dadd_refmodel :: post_reset_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_refmodel :: pre_configure_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_refmodel :: configure_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting configure_phase");
endtask : configure_phase
task          dadd_refmodel :: post_configure_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_refmodel :: pre_main_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_refmodel :: main_phase(uvm_phase phase);
    dadd_item item;
    $display("dadd_refmodel, Starting main_phase");
    while(1)
    begin
        get_dadd_pkt(item);
        item.data =item.data+ 1;
        ap.write(item);
    end
endtask: main_phase

task          dadd_refmodel :: post_main_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting post_main_phase");
endtask : post_main_phase
task          dadd_refmodel :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_refmodel :: shutdown_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_refmodel :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_refmodel :: extract_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting extract_phase");
endfunction : extract_phase
function void dadd_refmodel :: check_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting check_phase");
endfunction : check_phase
function void dadd_refmodel :: report_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting report_phase");
endfunction : report_phase
function void dadd_refmodel :: final_phase(uvm_phase phase);
    $display("dadd_refmodel, Starting final_phase");
endfunction : final_phase
