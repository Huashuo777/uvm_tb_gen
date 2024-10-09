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
//     File for dadd_omonitor.sv                                                       
//----------------------------------------------------------------------------------
class dadd_omonitor extends uvm_monitor;
    `uvm_component_utils(dadd_omonitor)
    uvm_analysis_port #(dadd_item) ap;
    extern function new(string name ="dadd_omonitor", uvm_component parent = null);
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
endclass: dadd_omonitor

function dadd_omonitor :: new(string name ="dadd_omonitor", uvm_component parent = null);
    super.new(name, parent);
    ap = new("ap",this);
endfunction: new

function void dadd_omonitor :: build_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting build_phase");
endfunction : build_phase
function void dadd_omonitor :: connect_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting connect_phase");
endfunction : connect_phase
function void dadd_omonitor :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_omonitor :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_omonitor :: run_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting run_phase");
endtask : run_phase
task          dadd_omonitor :: pre_reset_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_omonitor :: reset_phase(uvm_phase phase);
    wait(tb_dadd.dadd_if.reset_n);
    $display("dadd_omonitor, Starting reset_phase");
endtask : reset_phase
task          dadd_omonitor :: post_reset_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_omonitor :: pre_configure_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_omonitor :: configure_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting configure_phase");
endtask : configure_phase
task          dadd_omonitor :: post_configure_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_omonitor :: pre_main_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting pre_main_phase");
endtask : pre_main_phase

task          dadd_omonitor :: main_phase(uvm_phase phase);
    dadd_item item;
    $display("dadd_omonitor, Starting main_phase");

    forever 
    begin
        @(posedge tb_dadd.dadd_if.clk);
        if(tb_dadd.dadd_if.pcb.dadd_out_en)
        begin
            item = new();
            item.data_en = tb_dadd.dadd_if.pcb.dadd_out_en;
            item.data    = tb_dadd.dadd_if.pcb.dadd_out;
            item.addr    = tb_dadd.dadd_if.pcb.dadd_out_addr;
            ap.write(item);
        end
    end
endtask: main_phase

task          dadd_omonitor :: post_main_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting post_main_phase");
endtask : post_main_phase
task          dadd_omonitor :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_omonitor :: shutdown_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_omonitor :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_omonitor :: extract_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting extract_phase");
endfunction : extract_phase
function void dadd_omonitor :: check_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting check_phase");
endfunction : check_phase
function void dadd_omonitor :: report_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting report_phase");
endfunction : report_phase
function void dadd_omonitor :: final_phase(uvm_phase phase);
    $display("dadd_omonitor, Starting final_phase");
endfunction : final_phase
