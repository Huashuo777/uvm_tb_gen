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
//     File for reg_model.sv                                                       
//----------------------------------------------------------------------------------
class reg_version_info extends uvm_reg;
 
   rand uvm_reg_field version;
 
   `uvm_object_utils(reg_version_info)
 
   function new(string name = "reg_version_info");
      super.new(name, 32, 1);
   endfunction : new
 
   virtual function void build();
      version = uvm_reg_field::type_id::create("version");
      version.configure(.parent(this), .size(16), .lsb_pos(0), .access("RW"), .volatile(0), .reset(1), .has_reset(1), .is_rand(1), .individually_accessible(1));
   endfunction : build
endclass : reg_version_info


class reg_model extends uvm_reg_block;
   `uvm_object_utils(reg_model)
 
   rand reg_version_info version_info;
 
   function new(string name = "reg_model");
      super.new(name, UVM_CVR_ALL);
      version_info=reg_version_info ::type_id::create("version_info");
   endfunction : new
 
   virtual function void build();
      default_map = create_map("default_map",0,4,UVM_LITTLE_ENDIAN);
      
      version_info.configure(this, null, "version");
      version_info.build();
      default_map.add_reg(version_info,0,"RW");
 
   endfunction : build
endclass : reg_model
