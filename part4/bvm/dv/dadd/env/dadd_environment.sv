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
`ifndef DADD_ENVIRONMENT__SV
`define DADD_ENVIRONMENT__SV
class dadd_environment extends bvm_env;
    dadd_loc_iagent dadd_loc_iagt;
    dadd_loc_oagent dadd_loc_oagt;
    dadd_refmodel refmdl;
    dadd_scoreboard scb;
    virtual dadd_loc_interface vif;

    `bvm_component_utils(dadd_environment)

    extern function new(string name ="dadd_environment", bvm_component parent);
    extern function void build_phase();
endclass: dadd_environment

function dadd_environment :: new(string name ="dadd_environment", bvm_component parent);
    super.new(name, parent);
endfunction: new

function void dadd_environment :: build_phase();
    super.build_phase();
    dadd_loc_iagt = dadd_loc_iagent::type_id::create("dadd_loc_iagt", this);
    dadd_loc_oagt = dadd_loc_oagent::type_id::create("dadd_loc_oagt", this);
    refmdl = dadd_refmodel :: type_id :: create("refmdl",this);          
    scb = dadd_scoreboard :: type_id :: create("scb",this);

    bvm_config_db #(virtual dadd_loc_interface) :: get("vif",vif);

    dadd_loc_iagt.vif = vif;
    dadd_loc_oagt.vif = vif;
endfunction: build_phase

`endif // DADD_ENVIRONMENT__SV
