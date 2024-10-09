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
//     File for ral_top.sv                                                       
//----------------------------------------------------------------------------------
`ifndef RAL_TOP__SV
`define RAL_TOP__SV
package ral_top_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class dadd_register extends uvm_reg;
	`uvm_object_utils(dadd_register)
	rand uvm_reg_field dadd_en_field;
	rand uvm_reg_field daddend_value_field;
	function new(string name = "dadd_register");
		super.new(name,32,UVM_CVR_ALL);
	endfunction : new
	virtual function void build();
		dadd_en_field = uvm_reg_field :: type_id :: create("dadd_en_field");
		dadd_en_field.configure(.parent(this),.size(1),.lsb_pos(0),
					.access("RW"),.volatile(0),.reset('h0),
					.has_reset(1), .is_rand(1), .individually_accessible(0));
		daddend_value_field = uvm_reg_field :: type_id :: create("daddend_value_field");
		daddend_value_field.configure(.parent(this),.size(5),.lsb_pos(1),
					.access("RW"),.volatile(0),.reset('h1),
					.has_reset(1), .is_rand(1), .individually_accessible(0));
	endfunction : build
endclass : dadd_register
class dadd_block extends uvm_reg_block;
	`uvm_object_utils(dadd_block)
	rand dadd_register dadd_reg;
	function new(string name = "dadd_block");
		super.new(name,UVM_CVR_ALL);
	endfunction : new
	function void build();
		default_map = create_map("default_map",0,4,UVM_LITTLE_ENDIAN);
		dadd_reg = dadd_register :: type_id :: create("dadd_reg");
		dadd_reg.configure(this,null,"");
		dadd_reg.build();
		dadd_reg.add_hdl_path_slice("dadd_regfile_inst.reg_value[0]",0,1);
		dadd_reg.add_hdl_path_slice("dadd_regfile_inst.reg_value[5:1]",1,5);
		default_map.add_reg(dadd_reg,'h0,"RW");
	endfunction : build
endclass: dadd_block

class dsel_register extends uvm_reg;
	`uvm_object_utils(dsel_register)

	rand uvm_reg_field channel_sel_field;
	rand uvm_reg_field data_inv_field;
	function new(string name = "dsel_register");
		super.new(name,32,UVM_CVR_ALL);
	endfunction : new
	virtual function void build();

		channel_sel_field = uvm_reg_field :: type_id :: create("channel_sel_field");
		channel_sel_field.configure(.parent(this),.size(1),.lsb_pos(0),
					.access("RW"),.volatile(0),.reset('h0),
					.has_reset(1), .is_rand(1), .individually_accessible(0));
		data_inv_field = uvm_reg_field :: type_id :: create("data_inv_field");
		data_inv_field.configure(.parent(this),.size(1),.lsb_pos(1),
					.access("RW"),.volatile(0),.reset('h0),
					.has_reset(1), .is_rand(1), .individually_accessible(0));
	endfunction : build
endclass : dsel_register

class dsel_block extends uvm_reg_block;
	`uvm_object_utils(dsel_block)

	rand dsel_register dsel_reg;
	function new(string name = "dsel_block");
		super.new(name,UVM_CVR_ALL);
	endfunction : new
	function void build();
		default_map = create_map("default_map",0,4,UVM_LITTLE_ENDIAN);

		dsel_reg = dsel_register :: type_id :: create("dsel_reg");
		dsel_reg.configure(this,null,"");
		dsel_reg.build();

		dsel_reg.add_hdl_path_slice("dsel_regfile_inst.reg_value[0]",0,1);
		dsel_reg.add_hdl_path_slice("dsel_regfile_inst.reg_value[1]",1,1);
		default_map.add_reg(dsel_reg,'h0,"RW");
	endfunction : build
endclass: dsel_block
class ral_top_block extends uvm_reg_block;
	`uvm_object_utils(ral_top_block)
	rand dadd_block dadd_blk;
	rand dsel_block dsel_blk;
	function new(string name = "ral_top_block");
		super.new(name);
	endfunction : new
	function void build();
		default_map = create_map("default_map",0,4,UVM_LITTLE_ENDIAN);
		dadd_blk = dadd_block :: type_id :: create("dadd_blk",,get_full_name());
		dadd_blk.configure(this,"dadd_inst");
		dadd_blk.build();
		default_map.add_submap(dadd_blk.default_map,'h0);

		dsel_blk = dsel_block :: type_id :: create("dsel_blk",,get_full_name());
		dsel_blk.configure(this,"dsel_inst");
		dsel_blk.build();
		default_map.add_submap(dsel_blk.default_map,'h100);

	endfunction : build
endclass : ral_top_block
endpackage : ral_top_pkg
`endif //RAL_TOP__SV
