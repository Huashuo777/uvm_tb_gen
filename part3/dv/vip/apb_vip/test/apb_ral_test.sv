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
//     File for apb_ral_test.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_RAL_TEST__SV
`define APB_RAL_TEST__SV
//------------RAL MODEL----------------//
class reg_auth_info0 extends uvm_reg;
  rand uvm_reg_field info;

  `uvm_object_utils_begin(reg_auth_info0)
    `uvm_field_object(info, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="reg_auth_info0");
    super.new(name, 32, UVM_CVR_ALL);
  endfunction

  virtual function void build();
    info = uvm_reg_field::type_id::create("info");
    info.configure(.parent(this), .size(32), .lsb_pos(0),
                               .access("RO"), .volatile(0), .reset(32'h616e6c69),
                               .has_reset(1), .is_rand(0), .individually_accessible(0));
  endfunction
endclass : reg_auth_info0

class reg_auth_info1 extends uvm_reg;
  rand uvm_reg_field info;

  `uvm_object_utils_begin(reg_auth_info1)
    `uvm_field_object(info, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="reg_auth_info1");
    super.new(name, 32, UVM_CVR_ALL);
  endfunction

  virtual function void build();
    info = uvm_reg_field::type_id::create("info");
    info.configure(.parent(this), .size(32), .lsb_pos(0),
                               .access("RO"), .volatile(0), .reset(32'h6e676a69),
                               .has_reset(1), .is_rand(0), .individually_accessible(0));
  endfunction
endclass : reg_auth_info1

class reg_auth_info2 extends uvm_reg;
  rand uvm_reg_field info;

  `uvm_object_utils_begin(reg_auth_info2)
    `uvm_field_object(info, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="reg_auth_info2");
    super.new(name, 32, UVM_CVR_ALL);
  endfunction

  virtual function void build();
    info = uvm_reg_field::type_id::create("info");
    info.configure(.parent(this), .size(32), .lsb_pos(0),
                               .access("RO"), .volatile(0), .reset(32'h00007761),
                               .has_reset(1), .is_rand(0), .individually_accessible(0));
  endfunction
endclass : reg_auth_info2

class reg_model extends uvm_reg_block;
  rand reg_auth_info0 auth_info0;
  rand reg_auth_info1 auth_info1;
  rand reg_auth_info2 auth_info2;

  `uvm_object_utils_begin(reg_model)
    `uvm_field_object(auth_info0, UVM_ALL_ON)
    `uvm_field_object(auth_info1, UVM_ALL_ON)
    `uvm_field_object(auth_info2, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="reg_model");
    super.new(name, UVM_CVR_ALL);
  endfunction

  function void build();
    default_map = create_map("default_map", 32'h00000000, 4, UVM_LITTLE_ENDIAN);

    auth_info0 = reg_auth_info0::type_id::create("auth_info0");
    auth_info0.configure(this, null, "");
    auth_info0.build();
    default_map.add_reg(auth_info0, 32'h00, "RO");

    auth_info1 = reg_auth_info1::type_id::create("auth_info1");
    auth_info1.configure(this, null, "");
    auth_info1.build();
    default_map.add_reg(auth_info1, 32'h04, "RO");

    auth_info2 = reg_auth_info2::type_id::create("auth_info2");
    auth_info2.configure(this, null, "");
    auth_info2.build();
    default_map.add_reg(auth_info2, 32'h08, "RO");

  endfunction
endclass : reg_model

class apb_slave_ral_sequence extends apb_slave_sequence_base;
    `uvm_object_utils(apb_slave_ral_sequence)
    extern         function new(string name = "apb_slave_ral_sequence"); 
    extern virtual task body();
endclass : apb_slave_ral_sequence

function apb_slave_ral_sequence :: new(string name ="apb_slave_ral_sequence");
    super.new(name);
endfunction : new

task apb_slave_ral_sequence :: body();
    apb_slave_item item;
    forever 
    begin
        `uvm_do_with(item,{
            response == OKAY;
        });
    end
endtask : body

class apb_ral_virtual_sequence extends apb_virtual_sequence;
    `uvm_object_utils(apb_ral_virtual_sequence)
    reg_model rm;
    extern         function new(string name = "apb_ral_virtual_sequence");
    extern virtual task body();
endclass : apb_ral_virtual_sequence

function apb_ral_virtual_sequence :: new(string name = "apb_ral_virtual_sequence");
    super.new(name);
endfunction : new

task apb_ral_virtual_sequence :: body();
    apb_slave_ral_sequence slv_seq;
    uvm_status_e status;
    uvm_reg_data_t data;
    slv_seq = apb_slave_ral_sequence::type_id :: create("slv_seq");
    fork
        begin
        rm.auth_info0.info.write(status,31'h1234);
        rm.auth_info0.info.read(status,data);
        end
        slv_seq.start(p_sequencer.slv_sqr[0]);
    join_any
endtask : body

class apb_ral_test extends apb_base_test;
    `uvm_component_utils(apb_ral_test)
    reg_model rm;
    extern          function new(string name = "apb_ral_test", uvm_component parent = null);
    extern  virtual function void build_phase(uvm_phase phase);
    extern  virtual function void connect_phase(uvm_phase phase);
    extern  virtual task          run_phase(uvm_phase phase);
endclass : apb_ral_test

function apb_ral_test :: new(string name = "apb_ral_test", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void apb_ral_test :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg.mst_cfg[0].use_reg_model = True;
endfunction : build_phase

function void apb_ral_test :: connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    rm = reg_model :: type_id :: create("rm");
    rm.build();
    rm.lock_model();
    rm.reset();
    rm.default_map.set_sequencer(env.vsqr.mst_sqr[0],env.mst_agt[0].adpt);
    env.mst_agt[0].pred.map = rm.default_map;
endfunction : connect_phase

task apb_ral_test :: run_phase(uvm_phase phase);
    apb_ral_virtual_sequence vseq;
    vseq = apb_ral_virtual_sequence :: type_id:: create("vseq");
    vseq.rm  = rm;
    phase.raise_objection(this);
    vseq .start(vsqr);
    #1000ns;
    phase.drop_objection(this);
endtask : run_phase

`endif //APB_RAL_TEST__SV
