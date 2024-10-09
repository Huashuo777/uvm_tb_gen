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
//     File for dadd_driver.sv                                                       
//----------------------------------------------------------------------------------
class dadd_driver extends uvm_driver #(dadd_item);
    `uvm_component_utils(dadd_driver)
    extern function new(string name ="dadd_driver", uvm_component parent = null);
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
endclass: dadd_driver

function dadd_driver :: new(string name ="dadd_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dadd_driver :: build_phase(uvm_phase phase);
    $display("dadd_driver, Starting build_phase");
endfunction : build_phase
function void dadd_driver :: connect_phase(uvm_phase phase);
    $display("dadd_driver, Starting connect_phase");
endfunction : connect_phase
function void dadd_driver :: end_of_elaboration_phase(uvm_phase phase);
    $display("dadd_driver, Starting end_of_elaboration_phase");
endfunction : end_of_elaboration_phase
function void dadd_driver :: start_of_simulation_phase(uvm_phase phase);
    $display("dadd_driver, Starting start_of_simulation_phase");
endfunction : start_of_simulation_phase
task          dadd_driver :: run_phase(uvm_phase phase);
    $display("dadd_driver, Starting run_phase");
endtask : run_phase
task          dadd_driver :: pre_reset_phase(uvm_phase phase);
    $display("dadd_driver, Starting pre_reset_phase");
endtask : pre_reset_phase
task          dadd_driver :: reset_phase(uvm_phase phase);
    $display("dadd_driver, Starting reset_phase");
    phase.raise_objection(this);
    tb_dadd.dadd_if.mcb.dadd_in_en      <= 0 ;
    tb_dadd.dadd_if.mcb.dadd_in_addr    <= 0 ;
    tb_dadd.dadd_if.mcb.dadd_in         <= 0 ;
    wait(tb_dadd.dadd_if.reset_n);
    phase.drop_objection(this);
endtask : reset_phase
task          dadd_driver :: post_reset_phase(uvm_phase phase);
    $display("dadd_driver, Starting post_reset_phase");
endtask : post_reset_phase
task          dadd_driver :: pre_configure_phase(uvm_phase phase);
    $display("dadd_driver, Starting pre_configure_phase");
endtask : pre_configure_phase
task          dadd_driver :: configure_phase(uvm_phase phase);
    $display("dadd_driver, Starting configure_phase");
endtask : configure_phase
task          dadd_driver :: post_configure_phase(uvm_phase phase);
    $display("dadd_driver, Starting post_configure_phase");
endtask : post_configure_phase
task          dadd_driver :: pre_main_phase(uvm_phase phase);
    $display("dadd_driver, Starting pre_main_phase");
endtask : pre_main_phase

task dadd_driver :: main_phase(uvm_phase phase);
    $display("dadd_driver, Starting main_phase");
    forever 
    begin
        seq_item_port.get_next_item(req);
        @(posedge tb_dadd.dadd_if.clk);
        if(req.data_en)
        begin
            tb_dadd.dadd_if.mcb.dadd_in_en <= req.data_en;
            tb_dadd.dadd_if.mcb.dadd_in <= req.data;
            tb_dadd.dadd_if.mcb.dadd_in_addr <= req.addr;
        end
        else 
        begin
            tb_dadd.dadd_if.mcb.dadd_in_en <= 0;
            tb_dadd.dadd_if.mcb.dadd_in <= 0;
            tb_dadd.dadd_if.mcb.dadd_in_addr <= 0;
        end
        seq_item_port.item_done();
    end
endtask: main_phase

task          dadd_driver :: post_main_phase(uvm_phase phase);
    $display("dadd_driver, Starting post_main_phase");
endtask : post_main_phase
task          dadd_driver :: pre_shutdown_phase(uvm_phase phase);
    $display("dadd_driver, Starting pre_shutdown_phase");
endtask : pre_shutdown_phase
task          dadd_driver :: shutdown_phase(uvm_phase phase);
    $display("dadd_driver, Starting shutdown_phase");
endtask : shutdown_phase
task          dadd_driver :: post_shutdown_phase(uvm_phase phase);
    $display("dadd_driver, Starting post_shutdown_phase");
endtask : post_shutdown_phase
function void dadd_driver :: extract_phase(uvm_phase phase);
    $display("dadd_driver, Starting extract_phase");
endfunction : extract_phase
function void dadd_driver :: check_phase(uvm_phase phase);
    $display("dadd_driver, Starting check_phase");
endfunction : check_phase
function void dadd_driver :: report_phase(uvm_phase phase);
    $display("dadd_driver, Starting report_phase");
endfunction : report_phase
function void dadd_driver :: final_phase(uvm_phase phase);
    $display("dadd_driver, Starting final_phase");
endfunction : final_phase
