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
//     File for dadd_loc_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DADD_LOC_DRIVER__SV
`define DADD_LOC_DRIVER__SV

class dadd_loc_driver extends bvm_driver;
    virtual dadd_loc_interface vif;
    `bvm_component_utils(dadd_loc_driver)
    extern function new(string name ="dadd_loc_driver", bvm_component parent = null);
    extern task run_phase();
    extern task get_and_drive();
endclass: dadd_loc_driver

function dadd_loc_driver :: new(string name ="dadd_loc_driver", bvm_component parent = null);
    super.new(name, parent);
endfunction: new

task dadd_loc_driver :: run_phase();
    `bvm_info("Starting run_phase...", BVM_HIGH)
    vif.dadd_in_en      <= 0 ;
    vif.dadd_in_addr    <= 0 ;
    vif.dadd_in         <= 0 ;
    forever
    begin
        wait(vif.reset_n);
        get_and_drive();
    end
endtask: run_phase

task dadd_loc_driver :: get_and_drive();
    dadd_loc_item req_old;
    bvm_sequence_item req;
    get_next_item(req);
    $cast(req_old,req);
    if(req_old.data_en)
    begin
        vif.mcb.dadd_in_en <= req_old.data_en;
        vif.mcb.dadd_in <=req_old.data;
        vif.mcb.dadd_in_addr <=req_old.addr;
    end
    @(posedge vif.clk);
    vif.mcb.dadd_in_en <= 0;
    vif.mcb.dadd_in <= 0;
    vif.mcb.dadd_in_addr <= 0;
endtask: get_and_drive

`endif // DADD_LOC_DRIVER__SV
