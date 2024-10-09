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
    virtual dadd_interface vif;
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
    extern task          reset_phase(uvm_phase phase);
endclass: dadd_environment

function dadd_environment :: new(string name ="dadd_environment", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_environment :: build_phase(uvm_phase phase);
    iagt = dadd_iagent :: type_id :: create("iagt",this);
    oagt = dadd_oagent :: type_id :: create("oagt",this);
    refmdl = dadd_refmodel :: type_id :: create("refmdl",this);
    scb =  dadd_scoreboard :: type_id :: create("scb",this);
    dadd_iagt_to_refmdl_fifo = new("dadd_iagt_to_refmdl_fifo",this);
    dadd_oagt_to_scb_fifo = new("dadd_oagt_to_scb_fifo",this);
    dadd_refmdl_to_scb_fifo = new("dadd_refmdl_to_scb_fifo",this);
    if(!uvm_config_db #(virtual dadd_interface) :: get(this,"","vif",vif))
        $display("ERROR,The interface is not get !!!");
    iagt.vif = vif;
    oagt.vif = vif;

    uvm_config_db#(string)::set(uvm_root::get(),"*","use_uvm_root_get_different_level_set","Config_db use \"uvm_root::get(),different level set\",This is dadd_environment"); 
    uvm_config_db#(string)::set(this,"*","use_this_different_level_set","Config_db use \"this,different level set\",This is dadd_environment"); 
    
    uvm_config_db#(string)::set(this,"*","use_config_db_and_this_set","Config_db use \"this and config_db set\",This is use this"); 
    uvm_config_db#(string)::set(uvm_root::get(),"*","use_uvm_root_get_and_this_set","Config_db use \"this and uvm_root::get set\",This is use uvm_root::get"); 

    uvm_config_db#(string)::set(uvm_root::get(),"uvm_test_top.env.iagt.sqr.*","sequence_use_uvm_config_db_set","Can correctly use config_db in sequence..."); 
endfunction : build_phase

function void dadd_environment :: connect_phase(uvm_phase phase);
    iagt.ap.connect(dadd_iagt_to_refmdl_fifo.analysis_export);                                                                                                                                                          
    refmdl.port.connect(dadd_iagt_to_refmdl_fifo.blocking_get_export);

    oagt.ap.connect(dadd_oagt_to_scb_fifo.analysis_export);                                                                                                                                                          
    scb.act_port.connect(dadd_oagt_to_scb_fifo.blocking_get_export);

    refmdl.ap.connect(dadd_refmdl_to_scb_fifo.analysis_export);
    scb.exp_port.connect(dadd_refmdl_to_scb_fifo.blocking_get_export);


endfunction : connect_phase

task          dadd_environment :: reset_phase(uvm_phase phase);
    dadd_iagt_to_refmdl_fifo.flush();
    dadd_oagt_to_scb_fifo.flush();
    dadd_refmdl_to_scb_fifo.flush();
endtask : reset_phase
