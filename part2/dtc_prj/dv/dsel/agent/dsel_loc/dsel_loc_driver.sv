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
//     File for dsel_loc_driver.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL_LOC_DRIVER__SV
`define DSEL_LOC_DRIVER__SV
class dsel_loc_driver extends uvm_driver #(dsel_loc_item);
    virtual dsel_loc_interface vif;
    dsel_loc_config cfg;
    uvm_event_pool events;

    `uvm_component_utils(dsel_loc_driver)

    extern                      function new(string name ="dsel_loc_driver", uvm_component parent = null);
    extern              virtual task        main_phase(uvm_phase phase);
    extern              virtual task        reset_phase(uvm_phase phase); 
    extern              virtual function void connect_phase(uvm_phase phase);
    extern protected    virtual task        get_and_drive();
endclass: dsel_loc_driver

function dsel_loc_driver :: new(string name ="dsel_loc_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void dsel_loc_driver :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    events = cfg.events;
    vif = cfg.vif;
endfunction : connect_phase

task dsel_loc_driver :: reset_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"Starting task reset_phase...", UVM_HIGH)
    phase.raise_objection(this);
    vif.mcb.dsel_in_en      <= 0 ;
    vif.mcb.dsel_in_addr    <= 0 ;
    vif.mcb.dsel_in         <= 0 ;
    while(!vif.reset_n)                                                                                                                                                                                               
    begin
        @(posedge vif.clk);
    end
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"Starting task reset_phase...", UVM_HIGH)
endtask: reset_phase

task dsel_loc_driver :: main_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"Starting task main_phase...", UVM_HIGH)
    forever get_and_drive();
    `uvm_info(get_type_name(),"Finish task main_phase...", UVM_HIGH)
endtask: main_phase

task dsel_loc_driver :: get_and_drive();
    bit data_en;
    `uvm_info(get_type_name(),"Starting task get_and_drive...", UVM_HIGH)
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), $sformatf("Get item:%0s", req.sprint()), UVM_HIGH)
    for(int i=0;i<req.trans_num;)
    begin
        std::randomize(data_en);
        if(data_en)
        begin
            vif.mcb.dsel_in_en <= 1;
            vif.mcb.dsel_in <= req.data_arr[i];
            vif.mcb.dsel_in_addr <= req.addr_arr[i];
            i++;
        end
        else
        begin
            vif.mcb.dsel_in_en <= 0;
            vif.mcb.dsel_in <= 0;
            vif.mcb.dsel_in_addr <= 0;
        end
        @(posedge vif.clk);
        vif.mcb.dsel_in_en <= 0;
        vif.mcb.dsel_in <= 0;
        vif.mcb.dsel_in_addr <= 0;
    end
    seq_item_port.item_done();
    `uvm_info(get_type_name(),"Finish task get_and_drive...", UVM_HIGH)
endtask: get_and_drive

`endif // DSEL_LOC_DRIVER__SV
