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
    string field_automation_config_db;
    `uvm_component_utils_begin(dadd_driver)
        `uvm_field_string(field_automation_config_db,UVM_ALL_ON)
    `uvm_component_utils_end
    virtual dadd_interface vif;
    extern function new(string name ="dadd_driver", uvm_component parent = null);
    extern task          reset_phase(uvm_phase phase);
    extern task          main_phase(uvm_phase phase);
endclass: dadd_driver

function dadd_driver :: new(string name ="dadd_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

task          dadd_driver :: reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    vif.mcb.dadd_in_en      <= 0 ;
    vif.mcb.dadd_in_addr    <= 0 ;
    vif.mcb.dadd_in         <= 0 ;
    wait(vif.reset_n);
    phase.drop_objection(this);
endtask : reset_phase

task dadd_driver :: main_phase(uvm_phase phase);

    `uvm_info("DRV",$sformatf("The field_automation_config_db is: %s",field_automation_config_db),UVM_LOW);
    @(posedge vif.clk);
    forever 
    begin
        seq_item_port.get_next_item(req);
        if(req.data_en)
        begin
            vif.mcb.dadd_in_en <= req.data_en;
            vif.mcb.dadd_in <= req.data;
            vif.mcb.dadd_in_addr <= req.addr;
        end
        else 
        begin
            vif.mcb.dadd_in_en <= 0;
            vif.mcb.dadd_in <= 0;
            vif.mcb.dadd_in_addr <= 0;
        end
        @(posedge vif.clk);
        vif.mcb.dadd_in_en <= 0;
        vif.mcb.dadd_in <= 0;
        vif.mcb.dadd_in_addr <= 0;
        seq_item_port.item_done();
    end
endtask: main_phase

