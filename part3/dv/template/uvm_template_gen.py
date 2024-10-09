#!usr/bin/python3

# ***********************************************************************
# *****   *********       Copyright (c) 2022 
# ***********************************************************************
# project_name        : 
# FILENAME       : uvm_tb_gen.py
# Author         : Brent Wang[brent_wang@foxmail.com]
# LAST MODIFIED  : 2022-03-24 16:06
# ***********************************************************************
# DESCRIPTION    :
# ***********************************************************************
# $Revision: $
# $Id: $
# ***********************************************************************
#--------------------------------------------------
import re
import sys
import os
import getopt

uvm_version = "uvm-1.1";
template_path = "./brent_uvm_template";
project_name = "sunbird";
input_opt = 0;

def tb_gen():
  select_uvm_version()
  #get_prj_name();
  if len(sys.argv) == 1:
    get_user_choice(); 
    get_var_value();

def select_uvm_version(): 
  print ("--------------------------------------------------------\n");
  print ("\t WELCOME TO WANGJIANLI UVM TEMPLATE GENERATOR");
  print ("--------------------------------------------------------\n");
  print ("UVM version %s is being used.\n" % uvm_version);

def get_user_choice(): 
  global input_opt;

  while True:
    print ("\t0) Enter 0 to Create Hello World");
    print ("\t1) Enter 1 to Create Complete Environment");
    print ("\t2) Enter 2 to Create Agent");
    print ('Select [0-2]:',end='');
    input_opt = input();
    if((input_opt != "") & (input_opt != " ")):
      input_opt = int(input_opt);
      if(((input_opt == 0) | ((input_opt == 1)) | ((input_opt == 2)))):
        break;

def get_var_value():
  global project_name;
  global agent_num;
  global tbname;    
  global envname;   
  global agent_name;
  global agent_list;

  agent=[];

  if(input_opt == 0):#hello_world example
    gen_hello_world();
  if(input_opt == 1):#Create Complete Environment
    while True:
      print ( "\nPlease input module name: ",end="");
      project_name = input();
      if(re.match(r'\S',project_name)):
        break;
    while True:
      print ( "\nPlease input agent num [1-9]: ",end="");
      agent_num = input();
      if(re.match(r'[0-9]',agent_num)):
        agent_num = int(agent_num);
        break;
    for i in range(agent_num):
      while True:
        if (i==0):
          print ( "\nPlease input agent[%d] name(maybe rgf port): " % i , end="");
        else:
          print ( "\nPlease input agent[%d] name: " % i , end="");
        agent_name = input();
        if(re.match(r'\S',agent_name)):
          agent.append(agent_name);
          break;

    if os.path.exists(project_name+"/dv/env/")!= True:
      os.makedirs(project_name+"/dv/env/")
    if os.path.exists(project_name+"/dv/top/")!= True:
      os.makedirs(project_name+"/dv/top/")
    if os.path.exists(project_name+"/dv/test/")!= True:
      os.makedirs(project_name+"/dv/test/")
    if os.path.exists(project_name+"/dv/seq") != True :
      os.makedirs(project_name+"/dv/seq")
    for agt in agent:
      if os.path.exists(project_name+"/dv/agent/"+agt)!= True:
        os.makedirs(project_name+"/dv/agent/"+agt)
      #create the agent files
      agent_name = agt
      gen_agent_define()
      gen_agent_type()
      gen_if() 
      gen_agent_type()
      gen_config()
      gen_item() 
      gen_config() 
      gen_driver() 
      gen_base_seq() 
      gen_sqr() 
      gen_monitor() 
      gen_agent() 
      gen_agent_include()
    gen_refm(agent_num,agent)
    gen_scb(agent_num,agent)
    gen_covm(agent_num,agent)
    gen_env(agent_num,agent)
    gen_env_cfg(agent_num,agent);
    gen_vsqr(agent_num,agent);
    gen_env_pkg(agent_num,agent);
    gen_env_flist(agent_num,agent);
    gen_seq(agent_num,agent);
    gen_test(agent_num,agent);
    gen_top(agent_num,agent);
    gen_top_define();
    gen_top_flist();
  if(input_opt == 2):#Create agent
    while True:
      print ( "\nPlease input module name: ",end="");
      project_name = input();
      if(re.match(r'\S',project_name)):
        break;
    while True:
      print ( "\nPlease input agent num [1-9]: ",end="");
      agent_num = input();
      if(re.match(r'[0-9]',agent_num)):
        agent_num = int(agent_num);
        break;
    for i in range(agent_num):
      while True:
        print ( "\nPlease input agent[%d] name: " % i , end="");
        agent_name = input();
        if(re.match(r'\S',agent_name)):
          agent.append(agent_name);
          break;
    for agt in agent:
      if os.path.exists(project_name+"/dv/agent/"+agt)!= True:
        os.makedirs(project_name+"/dv/agent/"+agt)
      #create the agent files
      agent_name = agt
      gen_agent_define()
      gen_agent_type()
      gen_if() 
      gen_agent_type()
      gen_config()
      gen_item() 
      gen_config() 
      gen_driver() 
      gen_base_seq() 
      gen_sqr() 
      gen_monitor() 
      gen_agent() 
      gen_agent_include()


def write_file_header(file_f,file_name):
  file_f.write(
              "//---------------------------------------------------------------------------\n"
              "//\n"
              "// This confidential and proprietary software must be used only as authorized\n"
              "// by a licensing agreement from COMPANY, Ltd.\n"
              "//\n"
              "// Copyright, 2023 COMPANY, Ltd.\n"
              "// All Rights Reserved\n"
              "//\n"
              "//---------------------------------------------------------------------------\n"
              "//\n"
              "// file_name :"+file_name+"\n"
              "// Author    :\n"
              "// Project   :\n"
              "// Date      :\n"
              "//---------------------------------------------------------------------------\n"
              "//\n"
              "// Description:This file for "+file_name+"\n"
              "//\n"
              "//---------------------------------------------------------------------------\n"
              "\n"
              );

def gen_hello_world():
  if os.path.exists("hello_world") != True:
      os.makedirs("hello_world")
  dir_path = "hello_world";
  try:
    hw_f = open("hello_world/hello_world.sv", "w" )
  except IOError:
    print ("Exiting due to Error: can't open data_item: hello_world")
  try:
    hw_m_f = open("hello_world/Makefile", "w" )
  except IOError:
    print ("Exiting due to Error: can't open data_item: Makefile")
  write_file_header(hw_f,"hello_world.sv");
  hw_f.write(
            "import uvm_pkg::*;\n"
            "`include \"uvm_macros.svh\"\n"
            "\n"
            "class hello_world extends uvm_test;\n"
            "  `uvm_component_utils(hello_world)\n"
            "\n"
            " function new(string name, uvm_component parent);\n"
            "  super.new(name, parent);\n"
            " endfunction // new\n"
            "\n"
            " task main_phase(uvm_phase phase);\n"
            "   super.main_phase(phase);\n"
            "   phase.raise_objection(this);\n"
            "   `uvm_info(this.get_name(),\"*******************Hello world from UVM*****************\", UVM_LOW)\n"
            "\n"
            "   //ToDo\n"
            "\n"
            "   phase.drop_objection(this);\n"
            " endtask // main_phase\n"
            "endclass // hello_world\n"
            "\n"
            "module tb();\n"
            "  import uvm_pkg::*;\n"
            " `include \"uvm_macros.svh\"\n"
            "  initial begin\n"
            "    run_test(\"hello_world\");\n"
            "  end\n"
            "endmodule // tb\n"
            );

  hw_f.close( ) 
  hw_m_f.write(
            "cmp:\n"
            "\tvcs +vcs+initreg+random -full64 -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts "+uvm_version+" hello_world.sv -l compile.log\n" 
            "sim:\n"
            "\t./simv -full64 +UVM_VERBOSITY=UVM_LOW -l sim.log  +notimingcheck\n"
            "clean:\n"
	        "\trm -rf  csrc/ run.log  simv*  simv.daidir/  ucli.key  vc_hdrs.h AN.DB *.log\n"
            "all:cmp sim\n"
  );
  hw_m_f.close( ) 
  print("Hello_world example is generate.");

def gen_agent_define(): 
    global project_name

    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
        if_f = open( dir_path+agent_name+"_define.sv","w" )
    except IOError:
        print ("Exiting due to Error: can't open define: "+agent_name);

    write_file_header(if_f,agent_name+"_define.sv")
    if_f.write(
              " `ifndef "+agent_name.upper()+"_DEFINE__SV\n"
              " `define "+agent_name.upper()+"_DEFINE__SV\n"
              "\n"
              "`ifndef "+agent_name.upper()+"_DATA_WIDTH\n"
              "    `define "+agent_name.upper()+"_DATA_WIDTH 32\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_ADD_WIDTH\n"
              "    `define "+agent_name.upper()+"_ADDR_WIDTH 32\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_MASTER_INPUT_TIME\n"
              "    `define "+agent_name.upper()+"_MASTER_INPUT_TIME 1ns\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_SLAVE_INPUT_TIME\n"
              "    `define "+agent_name.upper()+"_SLAVE_INPUT_TIME 1ns\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_PASSIVE_INPUT_TIME\n"
              "    `define "+agent_name.upper()+"_PASSIVE_INPUT_TIME 1ns\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_MASTER_OUTPUT_TIME\n"
              "    `define "+agent_name.upper()+"MASTER_OUTPUT_TIME 1ns\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_SLAVE_OUTPUT_TIME\n"
              "    `define "+agent_name.upper()+"_SLAVE_OUTPUT_TIME 1ns\n"
              "`endif\n"
              "`ifndef "+agent_name.upper()+"_PASSIVE_OUTPUT_TIME\n"
              "    `define "+agent_name.upper()+"_PASSIVE_OUTPUT_TIME 1ns\n"
              "`endif\n"
              "\n"
              " `endif //"+agent_name.upper()+"_DEFINE__SV\n"
              );                                    
    if_f.close( );

def gen_agent_type(): 
    global project_name

    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
        if_f = open( dir_path+agent_name+"_type.sv","w" )
    except IOError:
        print ("Exiting due to Error: can't open type: "+agent_name);

    write_file_header(if_f,agent_name+"_type.sv")
    if_f.write(
            "`ifndef "+agent_name.upper()+"_TYPE__SV\n"   
            "`define "+agent_name.upper()+"_TYPE__SV\n"
            "\n"
            "typedef bit [`"+agent_name.upper()+"_DATA_WIDTH-1:0] "+agent_name+"_data_t;\n"
            "typedef bit [`"+agent_name.upper()+"_ADDR_WIDTH-1:0] "+agent_name+"_addr_t;\n"
            "\n"
            "typedef enum bit {\n"
            "    "+agent_name.upper()+"_READ,\n"
            "    "+agent_name.upper()+"_WRITE\n"
            "} "+agent_name+"_direction_e;\n"
            "\n"
            "typedef enum bit {\n"
            "    "+agent_name.upper()+"_OK,\n"
            "    "+agent_name.upper()+"_ERROR\n"
            "} "+agent_name+"_status_e;\n"
            "\n"
            "`endif //+agent_name.upper()+_TYPE__SV\n"
            );
    if_f.close( );

def gen_config():
    global project_name

    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      cfg_f = open( dir_path+agent_name+"_config.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(cfg_f,agent_name+"_config.sv")
    cfg_f.write(
            "`ifndef "+agent_name.upper()+"_CONFIG__SV\n" 
            "`define "+agent_name.upper()+"_CONFIG__SV\n"
            "class "+agent_name+"_config extends uvm_object;\n"
            "\n"
            "    uvm_event_pool events;\n"
            "    virtual "+agent_name+"_interface vif;\n"
            "    `uvm_object_utils_begin("+agent_name+"_config)\n"
            "    `uvm_object_utils_end\n"
            "\n"
            "    uvm_active_passive_enum is_active = UVM_ACTIVE;\n"
            "\n"
            "    extern function new(string name = \""+agent_name+"_config\");\n"
            "endclass : "+agent_name+"_config\n"
            "\n"
            "function "+agent_name+"_config :: new(string name = \""+agent_name+"_config\");\n"
            "    super.new(name);\n"
            "endfunction : new\n"
            "`endif// "+agent_name.upper()+"_CONFIG__SV\n"
                )
    cfg_f.close();

def gen_if(): 
    global project_name

    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
        if_f = open( dir_path+agent_name+"_interface.sv","w" )
    except IOError:
        print ("Exiting due to Error: can't open interface: "+agent_name);

    write_file_header(if_f,agent_name+"_interface.sv")
    if_f.write(
                "`ifndef "+agent_name.upper()+"_INTERFACE__SV\n"
                "`define "+agent_name.upper()+"_INTERFACE__SV\n"
                "`include \""+agent_name+"_define.sv\"\n"
                " interface "+agent_name+"_interface\n"
                " (\n"
                "     input logic clk,\n"
                "     input logic reset_n\n"
                "\n"
                "// ToDo: Add signals here\n"
                "\n"
                "  );\n"
                "\n"
                "    // master mode\n"
                "    clocking mcb @ (posedge clk);\n"
                "        default input #`"+agent_name.upper()+"_MASTER_INPUT_TIME output #`"+agent_name.upper()+"_MASTER_OUTPUT_TIME;\n"
                "    endclocking: mcb\n"
                "\n"
                "    // passive mode\n"
                "    clocking pcb @ (posedge clk);\n"
                "        default input #`"+agent_name.upper()+"_PASSIVE_INPUT_TIME output #`"+agent_name.upper()+"_PASSIVE_OUTPUT_TIME;\n"
                "    endclocking: pcb\n"
                "\n"
                " endinterface: "+agent_name+"_interface\n"
                "\n"
                " `endif // "+agent_name.upper()+"_INTERFACE__SV\n"
              );                                    
    if_f.close( );

def gen_item():
    global project_name

    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      tr_f = open( dir_path+agent_name+"_item.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(tr_f,agent_name+"_item.sv")
    tr_f.write(
              "`ifndef "+agent_name.upper()+"_ITEM__SV\n"
              "`define "+agent_name.upper()+"_ITEM__SV\n"
              "\n"
              "class "+agent_name+"_item extends uvm_sequence_item;\n"
              "\n"
              "    rand "+agent_name+"direction_e direction;\n"
              "    rand "+agent_name+"status_e status;\n"
              "\n"
              "    rand bit "+agent_name+" address;\n"
              "    rand bit "+agent_name+" data;\n"
              "\n"
              "    constraint status_cst {\n"
              "\n"
              "    // ToDo: Define constraint to make descriptor valid\n"
              "\n"
              "    status == "+agent_name.upper()+"_OK;\n"
              "    }\n"
              "\n"
              "    `uvm_object_utils_begin("+agent_name+"_item)\n"
              "\n"
              "    // ToDo: Add properties using macros here\n"
              "\n"
              "    `uvm_field_enum(DIRECTION_e, direction, UVM_ALL_ON)\n"
              "    `uvm_field_enum(STATUS_e,    status,    UVM_ALL_ON)\n"
              "\n"
              "    `uvm_field_int (address, UVM_ALL_ON)\n"
              "    `uvm_field_int (data,    UVM_ALL_ON)\n"
              "    `uvm_object_utils_end\n"
              "\n"
              "     function new(string name =\""+agent_name+"_item\");\n"
              "         super.new(name);\n"
              "     endfunction: new\n"
              "endclass: "+agent_name+"_item\n"
              "\n"
              "`endif // "+agent_name.upper()+"_ITEM__SV\n"
              );
    tr_f.close();


def gen_driver():
    global project_name
    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      driver_f = open( dir_path+agent_name+"_driver.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(driver_f,agent_name+"_driver.sv")
    driver_f.write(
            "`ifndef "+agent_name.upper()+"_DRIVER__SV\n"
            "`define "+agent_name.upper()+"_DRIVER__SV\n"
            "class "+agent_name+"_driver extends uvm_driver #("+agent_name+"_item);\n"
            "    virtual "+agent_name+"_interface vif;\n"
            "    "+agent_name+"_config cfg;\n"
            "    uvm_event_pool events;\n"
            "    `uvm_component_utils("+agent_name+"_driver)\n"
            "    extern                      function    new(string name =\""+agent_name+"_driver\", uvm_component parent = null);\n"
            "    extern              virtual task        reset_phase(uvm_phase phase); \n"
            "    extern              virtual task        main_phase(uvm_phase phase);\n"
            "    extern              virtual function void connect_phase(uvm_phase phase);\n"
            "    extern protected    virtual task        get_and_drive();\n"
            "endclass: "+agent_name+"_driver\n"
            "\n"
            "function "+agent_name+"_driver :: new(string name =\""+agent_name+"_driver\", uvm_component parent = null);\n"
            "    super.new(name, parent);\n"
            "endfunction: new\n"
            "\n"
            "function void "+agent_name+"_driver :: connect_phase(uvm_phase phase);\n"
            "    super.connect_phase(phase);\n"
            "    events = cfg.events;\n"
            "    vif = cfg.vif;\n"
            "endfunction : connect_phase\n"
            "\n"
            "task "+agent_name+"_driver :: reset_phase(uvm_phase phase);\n"
            "    `uvm_info(get_type_name(),\"Starting task reset_phase...\", UVM_HIGH)\n"
            "    phase.raise_objection(this);\n"
            "\n"
            "   // ToDo: Reset output signals\n"
            "\n"
            "    while(!vif.reset_n)   \n"       
            "    begin\n"
            "        @(posedge vif.clk);\n"
            "    end\n"
            "    phase.drop_objection(this);\n"
            "    `uvm_info(get_type_name(),\"Finish task reset_phase...\", UVM_HIGH)\n"
            "endtask: reset_phase\n"
            "\n"
            "task "+agent_name+"_driver :: main_phase(uvm_phase phase);\n"
            "    `uvm_info(get_type_name(),\"Starting task main_phase...\", UVM_HIGH)\n"
            "    forever get_and_drive();\n"
            "    `uvm_info(get_type_name(),\"Finish task main_phase...\", UVM_HIGH)\n"
            "endtask: main_phase\n"
            "\n"
            "\n"
            "task "+agent_name+"_driver :: get_and_drive();\n"
            "    `uvm_info(get_type_name(),\"Starting task get_and_drive...\", UVM_HIGH)\n"
            "    seq_item_port.get_next_item(req);\n"
            "    `uvm_info(get_type_name(), $sformatf(\"Get item:%0s\", req.sprint()), UVM_HIGH)\n"
            "\n"
            "    // ToDo: Implement transaction and drive signal on interface\n"
            "\n"
            "    `uvm_info(get_type_name(),\"Finish task get_and_drive...\", UVM_HIGH)\n"
            "endtask: get_and_drive\n"
            "`endif // "+agent_name.upper()+"_DRIVER__SV\n"
            );

    driver_f.close();

def gen_base_seq():
    global project_name
    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      seq_f = open( dir_path+agent_name+"_base_sequence.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(seq_f,agent_name+"_base_sequence.sv")
    seq_f.write(
            "`ifndef "+agent_name.upper()+"_BASE_SEQUENCE__SV\n"
            "`define "+agent_name.upper()+"_BASE_SEQUENCE__SV\n"
            "\n"
            "typedef class "+agent_name+"_sequencer;\n"
            "class "+agent_name+"_base_sequence extends uvm_sequence #("+agent_name+"_item);\n"
            "    virtual "+agent_name+"_interface vif;\n"
            "\n"
            "    "+agent_name+"_config cfg;\n"
            "    uvm_event_pool events;\n"
            "\n"
            "    `uvm_object_utils("+agent_name+"_base_sequence)\n"
            "    `uvm_declare_p_sequencer("+agent_name+"_sequencer)\n"
            "    extern         function new(string name = \""+agent_name+"_base_sequence\");\n"
            "    extern virtual task pre_start();\n"
            "endclass\n"
            "\n"
            "function "+agent_name+"_base_sequence :: new(string name = \""+agent_name+"_base_sequence\");\n"
            "    super.new(name);\n"
            "endfunction : new\n"
            "\n"
            "task "+agent_name+"_base_sequence :: pre_start();\n"
            "    `uvm_info(get_type_name(),\"Starting task pre_start...\", UVM_HIGH)\n"
            "    cfg = p_sequencer.cfg;\n"
            "    events = cfg.events;\n"
            "    `uvm_info(get_type_name(),\"Finish task pre_start...\", UVM_HIGH)\n"
            "endtask : pre_start\n"
            "\n"
            "`endif //"+agent_name.upper()+"_BASE_SEQUENCE_SV\n"
               );

def gen_sqr():
    global project_name
    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      sqr_f = open( dir_path+agent_name+"_sequencer.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(sqr_f,agent_name+"sequencer.sv")
    sqr_f.write(
                "`ifndef "+agent_name.upper()+"_SEQUENCER__SV\n"
                "`define "+agent_name.upper()+"_SEQUENCER__SV\n"
                "class "+agent_name+"_sequencer extends uvm_sequencer #("+agent_name+"_item);\n"
                "    virtual "+agent_name+"_interface vif;\n"
                "    "+agent_name+"_config cfg;\n"
                "    uvm_event_pool events;\n"
                "    `uvm_component_utils("+agent_name+"_sequencer)\n"
                "    extern         function new(string name = \""+agent_name+"_sequencer\", uvm_component parent);\n"
                "    extern virtual function void connect_phase(uvm_phase phase);\n"
                "endclass : "+agent_name+"_sequencer\n"
                "\n"
                "function "+agent_name+"_sequencer :: new(string name = \""+agent_name+"_sequencer\", uvm_component parent);\n"
                "    super.new(name,parent);\n"
                "endfunction : new\n"
                "\n"
                "function void "+agent_name+"_sequencer :: connect_phase(uvm_phase phase);\n"
                "    super.connect_phase(phase);\n"
                "    this.events = cfg.events;\n"
                "endfunction : connect_phase\n"
                "`endif //"+agent_name.upper()+"_SEQUENCER__SV\n"
                );

    sqr_f.close();


def gen_monitor():
    global project_name
    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      mon_f = open( dir_path+agent_name+"_monitor.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(mon_f,agent_name+"_monitor.sv")
    mon_f.write(
                "`ifndef "+agent_name.upper()+"_MONITOR__SV\n"
                "`define "+agent_name.upper()+"_MONITOR__SV\n"
                "class "+agent_name+"_monitor extends uvm_monitor;\n"
                "    virtual "+agent_name+"_interface vif;\n"
                "    "+agent_name+"_config cfg;\n"
                "    uvm_event_pool events;\n"
                "    uvm_analysis_port #("+agent_name+"_item) ap;\n" 
                "\n"
                "    `uvm_component_utils("+agent_name+"_monitor)\n"
                "\n"
                "    extern                      function    new(string name =\""+agent_name+"_monitor\", uvm_component parent);\n"
                "    extern              virtual function void connect_phase(uvm_phase phase);\n"
                "    extern              virtual task        main_phase(uvm_phase phase);\n"
                "    extern  protected   virtual task        collect_input_item();\n"
                "    extern  protected   virtual task        collect_output_item();\n"
                "endclass: "+agent_name+"_monitor\n"
                "\n"
                "function "+agent_name+"_monitor :: new(string name =\""+agent_name+"_monitor\", uvm_component parent);\n"
                "    super.new(name, parent);\n"
                "    ap    = new(\"ap\", this);\n"
                "endfunction: new\n"
                "\n"
                "function void "+agent_name+"_monitor :: connect_phase(uvm_phase phase);\n"
                "    super.connect_phase(phase);\n"
                "    events = cfg.events;\n"
                "    vif = cfg.vif;\n"
                "endfunction : connect_phase\n"
                "\n"
                "task "+agent_name+"_monitor :: main_phase(uvm_phase phase);\n"
                "    `uvm_info(get_type_name(),\"Starting task main_phase...\", UVM_HIGH)\n"
                "    fork\n"
                "        forever collect_input_item();\n"
                "        forever collect_output_item();\n"
                "        begin\n"
                "            @(negedge vif.reset_n);\n"
                "            phase.jump(uvm_reset_phase::get());\n"
                "        end\n"
                "    join\n"
                "    `uvm_info(get_type_name(),\"Starting task main_phase...\", UVM_HIGH)\n"
                "endtask: main_phase\n"
                "\n"
                "task "+agent_name+"_monitor :: collect_input_item();\n"
                "    "+agent_name+"_item item;\n"
                "    `uvm_info(get_type_name(),\"Starting task collect_input_item...\", UVM_HIGH)\n"
                "    @(posedge vif.clk);\n"
                "\n"
                "        //TODO : collect input signals item.\n"
                "\n"
                "        ap.write(item);\n"
                "    end\n"
                "    `uvm_info(get_type_name(),\"Finish task collect_input_item...\", UVM_HIGH)\n"
                "endtask: collect_input_item\n"
                "\n"
                "task "+agent_name+"_monitor :: collect_output_item();\n"
                "    "+agent_name+"_item item;\n"
                "    `uvm_info(get_type_name(),\"Starting task collect_output_item...\", UVM_HIGH)\n"
                "    @(posedge vif.clk);\n"
                "\n"
                "        //TODO : collect outputput signals item.\n"
                "\n"
                "        ap.write(item);\n"
                "    end\n"
                "    `uvm_info(get_type_name(),\"Finish task collect_output_item...\", UVM_HIGH)\n"
                "endtask: collect_output_item\n"
                "\n"
                "`endif // "+agent_name.upper()+"_MONITOR__SV\n"
                )

    mon_f.close();

def gen_agent():
    global project_name
    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      agent_f = open( dir_path+agent_name+"_agent.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open data_item: "+agent_name);

    write_file_header(agent_f,agent_name+"_agent.sv")
    agent_f.write(
                "`ifndef "+agent_name.upper()+"_AGENT__SV\n"
                "`define "+agent_name.upper()+"_AGENT__SV\n"
                "class "+agent_name+"_agent extends uvm_agent;\n"
                "    "+agent_name+"_config     cfg;\n"
                "    "+agent_name+"_sequencer  sqr;\n"
                "    "+agent_name+"_driver     drv;\n"
                "    "+agent_name+"_monitor    mon;\n"
                "\n"
                "    uvm_analysis_port #("+agent_name+"_item) ap;\n"
                "\n"
                "    `uvm_component_utils("+agent_name+"_agent)\n"
                "    extern function new(string name =\""+agent_name+"_agent\", uvm_component parent);\n"
                "    extern function void build_phase(uvm_phase phase);\n"
                "    extern function void connect_phase(uvm_phase phase);\n"
                "    extern function void start_of_simulation_phase(uvm_phase phase); \n"
                "endclass: "+agent_name+"_agent\n"
                "\n"
                "function "+agent_name+"_agent :: new(string name =\""+agent_name+"_agent\", uvm_component parent);\n"
                "    super.new(name, parent);\n"
                "endfunction: new\n"
                "\n"
                "function void "+agent_name+"_agent :: start_of_simulation_phase(uvm_phase phase); \n"
                "    super.start_of_simulation_phase(phase); \n"
                "endfunction: start_of_simulation_phase\n"
                "\n"
                "function void "+agent_name+"_agent :: build_phase(uvm_phase phase);\n"
                "\n"
                "    super.build_phase(phase);\n"
                "    \n"
                "    if(cfg == null)\n"
                "    begin\n"
                "        `uvm_fatal(\"build_phase\", \"Get a null configuration\")\n"
                "    end\n"
                "\n"
                "    mon = "+agent_name+"_monitor::type_id::create(\"mon\", this);\n"
                "    mon.cfg = this.cfg;\n"
                "\n"
                "    if(cfg.is_active == UVM_ACTIVE)\n"
                "    begin\n"
                "        sqr = "+agent_name+"_sequencer::type_id::create(\"sqr\", this);\n"
                "        sqr.cfg = this.cfg;\n"
                "        drv = "+agent_name+"_driver::type_id::create(\"drv\", this);\n"
                "        drv.cfg = this.cfg;\n"
                "    end\n"
                "endfunction: build_phase\n"
                "\n"
                "function void "+agent_name+"_agent :: connect_phase(uvm_phase phase);\n"
                "    super.connect_phase(phase);\n"
                "\n"
                "    if(cfg.is_active == UVM_ACTIVE)\n"
                "    begin\n"
                "        drv.seq_item_port.connect(sqr.seq_item_export);\n"
                "    end\n"
                "\n"
                "    this.ap = mon.ap;\n"
                "endfunction: connect_phase\n"
                "\n"
                "`endif // "+agent_name.upper()+"_AGENT__SV\n"
                )

    agent_f.close();
def gen_agent_include():
    global project_name
    dir_path = project_name+"/dv/agent/"+agent_name+"/"
    try:
      agent_pkg_f = open( dir_path+agent_name+"_include.svh", "w" )
    except IOError:
      print ("Exiting due to Error: can't open agent include: "+agent_name);

    write_file_header(agent_pkg_f,agent_name+"_pkg.sv")
    agent_pkg_f.write(
                    "`ifndef "+agent_name.upper()+"_INCLUDE__SVH\n"
                    "`define "+agent_name.upper()+"_INCLUDE__SVH\n"
                    "    `include \""+agent_name+"_define.sv\"\n"
                    "    `include \""+agent_name+"_type.sv\"\n"
                    "    `include \""+agent_name+"_config.sv\"\n"
                    "    `include \""+agent_name+"_item.sv\"\n"
                    "    `include \""+agent_name+"_base_sequence.sv\"\n"
                    "    `include \""+agent_name+"_sequencer.sv\"\n"
                    "    `include \""+agent_name+"_driver.sv\"\n"
                    "    `include \""+agent_name+"_monitor.sv\"\n"
                    "    `include \""+agent_name+"_agent.sv\"\n"
                    "`endif // "+agent_name.upper()+"_INCLUDE__SVH\n"
                     )

    agent_pkg_f.close();
    
def gen_refm(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      refm_f = open( dir_path+project_name+"_refmodel.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open refmodel: "+agent_name);

    write_file_header(refm_f,project_name+"_refmodel.sv")
    refm_f.write(
                "`ifndef "+project_name.upper()+"_REFMODEL__SV\n"    
                "`define "+project_name.upper()+"_REFMODEL__SV\n"
                "\n"
                "ral_top_block rm;\n"
                "class "+project_name+"_refmodel extends uvm_component;\n"
                "    "+project_name+"_env_config cfg;\n"
                "    uvm_event_pool events;\n"
                "\n"
                );
    for i in range(agent_num): 
      refm_f.write(
                "    uvm_blocking_get_port #("+agent[i]+"item) "+agent[i]+"_port;\n"
                "    uvm_analysis_port     #("+agent[i]+"item) "+agent[i]+"_ap;\n"
                );

    refm_f.write(
                "    `uvm_component_utils("+project_name+"_model)\n"
                "\n"
                "extern           function new(string name, uvm_component parent);\n"
                "extern           virtual function void build_phase(uvm_phase phase);\n"
                "extern           virtual function void connect_phase(uvm_phase phase);\n"
                "extern           virtual task main_phase(uvm_phase phase);\n"
                "\n"
                "endclass: "+project_name+"_refmodel\n"
                "\n"
                "function void "+project_name+" ::build_phase(uvm_phase phase);\n"
                "  super.build_phase(phase);\n"
                "\n"
                );
    for i in range(agent_num): 
      refm_f.write(
                "  "+agent[i]+"_port = new(\""+agent[i]+"_port\", this);\n"
                "  "+agent[i]+"_ap   = new(\""+agent[i]+"_ap\",   this);\n"
                );
    refm_f.write(
                "\n"
                "endfunction : build_phase\n"
                "\n"
                "function void "+project_name+"_refmodel :: connect_phase(uvm_phase phase);\n"
                "    super.connect_phase(phase);\n"
                "    events = cfg.events;\n"
                "    rm = cfg.rm;\n"
                "endfunction : connect_phase\n"
                "\n"
                "task "+project_name+"_model::main_phase(uvm_phase phase);\n"
                "\n"
                "\n"
                "    //TODO : Add reference code.\n"
                "\n"
                "\n"
                "endtask: main_phase\n"
                "\n"
                "`endif // "+project_name.upper()+"_REFMODEL\n"
                 );

    refm_f.close();
def gen_scb(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      scb_f = open( dir_path+project_name+"_scoreboard.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open scb: "+agent_name);

    write_file_header(scb_f,project_name+"_scoreboard.sv")
    scb_f.write(
                "`ifndef "+project_name.upper()+"_SCOREBOARD__SV\n"
                "`define "+project_name.upper()+"_SCOREBOARD__SV\n"
                "\n"
                "class "+project_name+"_scoreboard extends uvm_scoreboard;\n"
                );
    for i in range(agent_num): 
      scb_f.write(
                "    uvm_blocking_get_port #("+agent[i]+"item) "+agent[i]+"_exp_port;\n" 
                "    uvm_blocking_get_port #("+agent[i]+"item) "+agent[i]+"_act_port;\n" 
                );
    scb_f.write(
                "\n"
                );
    for i in range(agent_num): 
      scb_f.write(
                "    "+agent[i]+"item "+agent[i]+"_exp_queue[$];\n"
                "    `uvm_component_utils("+project_name+"_scoreboard)\n"
                "    "+project_name+"env_config cfg; \n"
                );
    scb_f.write(
                "\n"
                "    extern         function new(string name, uvm_component parent = null);\n"
                "    extern virtual function void build_phase(uvm_phase phase);\n"
                "    extern virtual task main_phase(uvm_phase phase);\n"
                "    extern task reset_phase(uvm_phase phase); \n"
                "endclass: "+project_name+"_scoreboard\n"
                "\n"
                "function "+project_name+"_scoreboard :: new(string name, uvm_component parent = null);\n"
                "    super.new(name, parent);\n"
                "endfunction: new\n"
                "\n"
                "function void "+project_name+"_scoreboard::build_phase(uvm_phase phase);\n"
                "    super.build_phase(phase);\n"
                "\n"
                );
    for i in range(agent_num): 
      scb_f.write(
                "    "+agent[i]+"_exp_port = new(\""+agent[i]+"_exp_port\", this);\n"
                "    "+agent[i]+"_act_port = new(\""+agent[i]+"_act_port\", this);\n"
                );
    scb_f.write(
                "endfunction: build_phase\n"
                "\n"
                );
    for i in range(agent_num): 
      scb_f.write(
                "task "+project_name+"_scoreboard :: reset_phase(uvm_phase phase);\n"
                "    "+agent[i]+"_exp_queue.delete();\n"
                "endtask : reset_phase\n"
                );
    scb_f.write(
                "\n"
                "task "+project_name+"_scoreboard::main_phase(uvm_phase phase);\n"
                );
    for i in range(agent_num): 
      scb_f.write(
                "    "+agent[i]+"item "+agent[i]+"_exp_item, "+agent[i]+"_act_item, tmp_"+agent[i]+"_exp_item;\n"
                "    fork\n"
                );
    for i in range(agent_num): 
      scb_f.write(
                "        while(1)\n"
                "        begin\n"
                "            "+agent[i]+"_exp_port.get("+agent[i]+"_exp_item);\n"
                "            "+agent[i]+"_exp_queue.push_front("+agent[i]+"_exp_item);\n"
                "        end\n"
                "        while(1)\n"
                "        begin\n"
                "            "+agent[i]+"_act_port.get("+agent[i]+"_act_item);\n"
                "            wait("+agent[i]+"_exp_queue.size()>0);\n"
                "            tmp_"+agent[i]+"_exp_item = "+agent[i]+"_exp_queue.pop_back();\n"
                "            if(!tmp_"+agent[i]+"_exp_item.compare("+agent[i]+"_act_item))\n"
                "            begin\n"
                "                `uvm_error(get_type_name(), $sformatf(\"Transaction miss match!\\nExpect:\\n%0s\\nActual:\\n%0s\\n\", tmp_"+agent[i]+"_exp_item.sprint()," +agent[i]+"_act_item.sprint()))\n"
                "            end\n"
                "        end\n"
                );
    scb_f.write(
                "  join\n"
                "endtask: main_phase\n"
                "`endif // "+project_name.upper()+"_SCOREBOARD__SV\n"
                );
    scb_f.close();

def gen_covm(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      covm_f = open( dir_path+project_name+"_cov_monitor.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open cover monitor: "+agent_name);

    write_file_header(covm_f,project_name+"_cov_monitor.sv")
    covm_f.write(
                "`ifndef "+project_name.upper()+"_COV_MON__SV\n"
                "`define "+project_name.upper()+"_COV_MON__SV\n"
                "\n"
                );
    for i in range(agent_num): 
      covm_f.write(
                "`uvm_analysis_imp_decl(_"+agent[i]+")\n"
                );
    covm_f.write(
                "class "+project_name+"_cov_mon extends uvm_component;\n"
                );
    for i in range(agent_num): 
      covm_f.write(
                "    uvm_analysis_imp_"+agent[i]+"#("+agent[i]+"_item, "+project_name+"_cov_mon) "+agent[i]+"_export;\n"
                );
    covm_f.write(
                "    "+project_name+"_env_config cfg;\n"
                "    `uvm_component_utils("+project_name+"_cov_mon)\n"
                "\n"
                "extern         function new(string name = "+project_name+"_cov_mon, uvm_component parent = null);\n"
                );
    for i in range(agent_num): 
      covm_f.write(
                "extern virtual function void write_"+agent[i]+"("+agent[i]+"_item item);\n"
                );
    covm_f.write(
                "endclass: "+project_name+"_cov_mon\n"
                "\n"
                );
    covm_f.write(

                "function "+project_name+"_cov_mon :: new(string name = "+project_name+"_cov_mon, uvm_component parent = null);\n"
                "    super.new(name, parent);\n"
                "    "+project_name+"_cov = new();\n"
                )
    for i in range(agent_num): 
      covm_f.write(
                "    "+agent[i]+"_export = new(\""+agent[i]+"_imp\", this);\n"
                );
    covm_f.write(
                "endfunction: new\n"
                "\n"
                );
    for i in range(agent_num): 
      covm_f.write(
                "function void "+project_name+"_cov_mon :: write_"+agent[i]+"("+agent[i]+"_item item);\n"
                "\n"
                "    // ToDo: Add master coverage monitor behavior\n"
                "\n"
                "endfunction: write_"+agent[i]+"\n"
                );
    covm_f.write(
                "endclass: "+project_name+"_cov_mon\n"
                "\n"
                "`endif // "+project_name.upper()+"_COV_MON__SV\n"
                )
    covm_f.close();

def gen_env(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      env_f = open( dir_path+project_name+"_environment.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open environment");

    write_file_header(env_f,project_name+"_environment.sv")
    env_f.write(
                "`ifndef "+project_name.upper()+"_ENVIRONMENT__SV\n"
                "`define "+project_name.upper()+"_ENVIRONMENT__SV\n"
                "\n"
                "class "+project_name+"_env extends uvm_env;\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "  "+agent[i]+"_agent "+agent[i]+"_agt;\n"
                );
    env_f.write(
                "  "+project_name+"env_config        cfg;\n"
                "  "+project_name+"_refmodel     refmdl;\n"
                "  "+project_name+"_scoreboard    scb;\n"
                "  "+project_name+"_virtual_sequencer  vsqr;\n"
                "  "+project_name+"_env_config  cfg;\n"
                "  "+project_name+"_cov_mon       cov_mon;\n"
                "\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "  uvm_tlm_analysis_fifo #("+agent[i]+"item) "+agent[i]+"_agt_refmdl_fifo;\n"
                "  uvm_tlm_analysis_fifo #("+agent[i]+"item) "+agent[i]+"_agt_scb_fifo;\n"
                "  uvm_tlm_analysis_fifo #("+agent[i]+"item) "+agent[i]+"_refmdl_scb_fifo;\n"
                )
    env_f.write(
                "  // ToDo: Add other componentss, callbacks and TLM ports\n"
                "\n"
                "  `uvm_component_utils("+project_name+"_environment)\n"
                "\n"
                "  extern function new(string name =\""+project_name+"_environment\", uvm_component parent);\n"
                "  extern virtual function void build_phase(uvm_phase phase);\n"
                "  extern virtual function void connect_phase(uvm_phase phase);\n"
                "  extern task reset_phase(uvm_phase phase); \n"
                "\n"
                "endclass: "+project_name+"_env\n"
                "\n"
                "function "+project_name+" :: new(string name =\""+project_name+"_environment\", uvm_component parent);\n"
                "    super.new(name, parent);\n"
                "  endfunction: new\n"
                "\n"
                "function void "+project_name+"_env::build_phase(uvm_phase phase);\n"
                "  super.build_phase(phase);\n"
                "\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "  "+agent[i]+"_agt = "+agent[i]+"_agent::type_id::create(\""+agent[i]+"_agt\", this);\n"
                );
    env_f.write(
                "  ref = "+project_name+"_refmodel::type_id::create(\"refmdl\",  this);\n"
                "  scb = "+project_name+"_scoreboard::type_id::create(\"scb\", this);\n"
                "  cov_mon = "+project_name+"_cov_mon::type_id::create(\"cov_mon\", this);\n"
                "\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "  "+agent[i]+"_agt_ref_fifo = new(\""+agent[i]+"_agt_refmdl_fifo\", this);\n"
                "  "+agent[i]+"_agt_scb_fifo = new(\""+agent[i]+"_agt_scb_fifo\", this);\n"
                "  "+agent[i]+"_ref_scb_fifo = new(\""+agent[i]+"_refmdl_scb_fifo\", this);\n"
                );
    env_f.write(
                "  if(cfg == null)\n"
                "  begin\n"
                "      `uvm_fatal(\"build_phase\", \"Get a null configuration\")\n"
                "  end\n"
                "\n"
                )
    for i in range(agent_num): 
      env_f.write(
                "  "+agent[i]+"_iagt.cfg = cfg."+agent[i]+"_cfg\n"
                );
    env_f.write(
                "  refmdl.cfg = cfg;\n"
                "  scb.cfg = cfg;\n"
                "  cov_mon.cfg = cfg;\n"
                "  vsqr.cfg = cfg;\n"
                "\n"
                "endfunction: build_phase\n"
                "\n"
                "function void "+project_name+"_env::connect_phase(uvm_phase phase);\n"
                "  super.connect_phase(phase);\n"
                "\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "  "+agent[i]+"_agt.ap.connect("+agent[i]+"_agt_refmdl_fifo.analysis_export);\n"
                "  refmdl."+agent[i]+"_port.connect("+agent[i]+"_agt_refmdl_fifo.blocking_get_export);\n"
                "  refmdl."+agent[i]+"_ap.connect("+agent[i]+"_refmdl_scb_fifo.analysis_export);\n"
                "  scb."+agent[i]+"_exp_port.connect("+agent[i]+"_refmdl_scb_fifo.blocking_get_export);\n"
                "  scb."+agent[i]+"_act_port.connect("+agent[i]+"_agt_scb_fifo.blocking_get_export);\n"
                "\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "  "+agent[i]+"_agt.ap.connect(cov_mon."+agent[i]+"_export);\n"
                );
    env_f.write(
                "endfunction: connect_phase\n"
                "`endif // "+project_name.upper()+"_ENVIRONMENT__SV\n"
                );
    for i in range(agent_num): 
      env_f.write(
                "task "+project_name+"_environment :: reset_phase(uvm_phase phase);\n"
                "    "+agent[i]+"_agt_refmdl_fifo.flush();\n"
                "    "+agent[i]+"_agt_scb_fifo.flush();\n"
                "    "+agent[i]+"_refmdl_scb_fifo.flush();\n"
                "endtask : reset_phase\n"
                )

    env_f.close();
def gen_env_cfg(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      env_cfg_f = open( dir_path+project_name+"_env_config.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open env_config");

    write_file_header(env_cfg_f,project_name+"_env_config.sv")
    env_cfg_f.write(
                "`ifndef "+project_name.upper()+"_ENV_CONFIG__SV\n"
                "`define "+project_name.upper()+"_ENV_CONFIG__SV\n"
                "\n"
                "class "+project_name+"_env_config extends uvm_object;\n"
                "    uvm_event_pool events;\n"
                "    ral_top_block rm;\n"

                );
    for i in range(agent_num): 
      env_cfg_f.write(
                "    "+agent[i]+"_interface "+agent[i]+"_vif;\n"
                "    "+agent[i]+"_config "+agent[i]+"_cfg;\n"
                );
    env_cfg_f.write(
                "    //ToDo: Add environment configuration variables\n"
                "\n"
                "    `uvm_object_utils_begin("+project_name+"_env_config)\n"
                "\n"
                "    `uvm_object_utils_end\n"
                "\n"
                "    extern virtual function new(string name =\""+project_name+"_config\");\n"
                "\n"
                "endclass: "+project_name+"_env_config\n"
                "\n"
                "function "+project_name+" :: new(string name =\""+project_name+"_env_config\");\n"
                );
    for i in range(agent_num): 
      env_cfg_f.write(
                "   "+agent[i]+"_env_cfg = new(\""+agent[i]+"_env_cfg\");\n"
                );
    env_cfg_f.write(
                "endfunction: new\n"
                "\n"
                "`endif // "+project_name.upper()+"_ENV_CONFIG__SV\n"
                );
    env_cfg_f.close();
def gen_vsqr(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      vsqr_f = open( dir_path+project_name+"_virtual_sequencer.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open vsequencer");

    write_file_header(vsqr_f,project_name+"_virtual_sequencer.sv")
    vsqr_f.write(
                "`ifndef "+project_name.upper()+"_VIRTUAL_SEQUENCER__SV\n"
                "`define "+project_name.upper()+"_VIRTUAL_SEQUENCER__SV\n"
                "\n"
                "class "+project_name+"_virtual_sequencer extends uvm_virtual_sequencer;\n"
                "    `uvm_component_utils("+project_name+"_virtual_sequencer)\n"
                "\n"
                );
    for i in range(agent_num): 
      vsqr_f.write(
                  "    "+agent[i]+"_sequencer "+agent[i]+"_sqr;\n"
                  );
    vsqr_f.write(
                "\n"
                "    extern function new(string name =\""+project_name+"_virtual_sequencer\",uvm_component parent = null);\n"
                "endclass\n"
                )
    vsqr_f.write(
                "\n"
                "    function "+project_name+" :: new(string name =\""+project_name+"_virtual_sequencer\",uvm_component parent = null);\n"
                "        super.new(name,parent);\n"
                "    endfunction\n"
                "`endif //"+project_name.upper()+"_VIRTUAL_SEQUENCE__SV\n"
                );
    vsqr_f.close();

def gen_env_pkg(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      env_pkg_f = open( dir_path+project_name+"_pkg.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open env_pkg");

    write_file_header(env_pkg_f,project_name+"_pkg.sv")
    env_pkg_f.write(
                    "`ifndef "+project_name.upper()+"_PKG__SV\n"
                    "`define "+project_name.upper()+"_PKG__SV\n"
                    "`timescale 1ns/100ps\n"
                    )
    for i in range(agent_num): 
      env_pkg_f.write(
                    "  `include "+agent[i]+"_interface.sv\n"
                    );
    env_pkg_f.write(
                    "\n"
                    "package "+project_name+"_pkg;\n"
                    "    import uvm_pkg::*;\n"
                    "    `include\"uvm_macros.svh\"\n"
                    "    `include\"ral_top_block.sv\"\n"
                    );
    for i in range(agent_num): 
      env_pkg_f.write(
                    "    `include \""+agent[i]+"_include.svh\"\n"
                    );
    env_pkg_f.write(
                    "    `include\""+project_name+"_env_config.sv\"\n"
                    "    `include\""+project_name+"_refmodel.sv\"\n"
                    "    `include\""+project_name+"_scoreboard.sv\"\n"
                    "    `include\""+project_name+"_cov_monitor.sv\"\n"
                    "    `include\""+project_name+"_virtual_sequencer.sv\"\n"
                    "    `include\""+project_name+"_environment.sv\"\n"
                    "    `include\""+project_name+"_sequence.sv\"\n"
                    "    `include\""+project_name+"_test.sv\"\n"
                    "endpackage: "+project_name+"_pkg\n"
                    "`endif // "+project_name.upper()+"_PKG__SV\n"
                    );

    env_pkg_f.close();

def gen_env_flist(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/env/";
    try:
      env_file_f = open( dir_path+""+project_name+"_env.f", "w" )
    except IOError:
      print ("Exiting due to Error: can't open env_file");

    env_file_f.write(
        "+incdir+../"+project_name+"/env\n"
        "+incdir+../"+project_name+"/seq\n"
        "+incdir+../"+project_name+"/test\n"
        "\n"
        );
    for i in range(agent_num): 
      env_file_f.write(
        "+incdir+../"+project_name+"/agent/"+agent[i]+"\n"
        );
    env_file_f.write(
        "../"+project_name+"/env/"+project_name+"_pkg.sv\n"
        "\n"
        "//ral\n"
        "../../ral/ral_top_block.sv\n"
        );
    env_file_f.close();




def gen_top(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/top/";
    try:
      top_f = open( dir_path+"tb_"+project_name+".sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open top");

    write_file_header(top_f,"tb_"+project_name+".sv")
    top_f.write(
                "`ifndef TB_"+project_name.upper()+"__SV\n"
                "`define TB_"+project_name.upper()+"__SV\n"
                "\n"
                "`include\"tb_"+project_name+".sv\"\n"
                "\n"
                "module tb_"+project_name+";\n"
                "    import uvm_pkg::*;\n"
                "    import "+project_name+"_pkg::*;\n"
                "\n"
                );
    for i in range(agent_num): 
      top_f.write(
                "    real  "+agent[i]+"_clk_period;\n"
                "    logic "+agent[i]+"_clk;\n"
                "    logic "+agent[i]+"reset_n;\n"
                );
    for i in range(agent_num): 
      top_f.write(
                "\n"
                "    "+agent[i]+"_interface "+agent[i]+"_if("+agent[i]+"_clk,"+agent[i]+"_reset_n);\n"
                );
    top_f.write(
                "\n"
                "    initial\n"
                "        $timeformat(-9, 2,\"ns\", 10);\n"
                "\n"
                "    initial\n"
                "        run_test();\n"
                "\n"
                "    initial\n"
                "    begin\n"
                );
    for i in range(agent_num): 
      top_f.write(
                "        uvm_config_db#(virtual "+agent[i]+"_interface)::set(uvm_root::get(),\"*\",\""+agent[i]+"_vif\", "+agent[i]+"_if);\n"
                );
    top_f.write(
                "    end\n"
                "\n"
                );
    for i in range(agent_num): 
      top_f.write(
                "    assign "+agent[i]+"_clk_period = "+agent[i]+"_if."+agent[i]+"_clk_period;\n"
                "    initial\n"
                "    begin\n"
                "        "+agent[i]+"_clk = 1'b0;\n"
                "        wait("+agent[i]+"_clk_period > 0);\n"
                "        forever\n"
                "            "+agent[i]+"_clk = #("+agent[i]+"_clk_period/2.0) ~ "+agent[i]+"_clk;\n"
                "    end\n"
                "\n"
                "    initial\n"
                "    begin\n"
                "        "+agent[i]+"_reset_n = 0;\n"
                "        #200ns;\n"
                "        "+agent[i]+"_reset_n = 1;\n"
                "    end\n"
                "\n"
                );
    top_f.write(
                "    initial begin\n"
                "        $vcdplusautoflushon;\n"
                "        $vcdpluson();\n"
                "    end\n"
                "\n"
                "    // ToDo: Implement DUT here\n"
                "    "+project_name+"\n "+project_name+"_inst\n"
                "      (\n"
                "        .clk(clk)\n"
                "      );\n"
                "endmodule: tb_"+project_name+"\n"
                "\n"
                "`endif // TB_"+project_name+"__SV\n"
                );
    top_f.close();

def gen_top_define():
    global project_name
    dir_path = project_name+"/dv/top/";
    try:
      top_define_f = open( dir_path+"tb_"+project_name+"_define.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open top_svh");

    write_file_header(top_define_f,"tb_"+project_name+"_define.sv")
    top_define_f.write(
                "`ifndef TB_"+project_name.upper()+"_DEFINE__SVH\n"
                "`define TB_"+project_name.upper()+"_DEFINE__SVH\n"
                "    `define TB_TOP tb_"+project_name+"\n"
                "\n"
                "`endif //TB_"+project_name.upper()+"_DEFINE_SVH\n"
                "\n"
                );

    top_define_f.close();
def gen_top_flist():
    global project_name
    dir_path = project_name+"/dv/top/";
    try:
      top_filelist_f = open( dir_path+"tb_"+project_name+".f", "w" )
    except IOError:
      print ("Exiting due to Error: can't open top filelist");

    top_filelist_f.write(
                "+incdir+../"+project_name+"/env\n"
                "+incdir+../../rtl/\n"
                "../"+project_name+"/top/tb_"+project_name+"_define.sv\n"
                "-f ../../rtl/"+project_name+"/"+project_name+".f\n"
                "-f ../../dv/"+project_name+"/env/"+project_name+"_env.f\n"
                "../"+project_name+"/seq/"+project_name+"_sequence.sv\n"
                "../"+project_name+"/test/"+project_name+"_test.sv\n"
                "../"+project_name+"/top/tb_"+project_name+".sv\n"
                "\n"
                );

    top_filelist_f.close();


def gen_seq(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/seq/";
    try:
      seq_f = open( dir_path+project_name+"_virtual_sequence.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open vsequence.sv");

    write_file_header(seq_f,project_name+"_virtual_sequence.sv")
    seq_f.write(
                "`ifndef "+project_name.upper()+"__SEQUENCE__SV\n"
                "`define "+project_name.upper()+"__SEQUENCE__SV\n"
                "/*************************************************************************************/\n"
                "/**********************************Base Sequence**************************************/\n"
                "/*************************************************************************************/\n"
                "class "+project_name+"_virtual_base_sequence extends uvm_sequence;\n"
                "    "+project_name+"_env_config cfg;\n"
                "    uvm_event_pool events;\n"
                "    ral_top_block rm;\n"
                "    uvm_status_e status;\n"
                "    uvm_reg_data_t data;\n"
                "    `uvm_object_utils("+project_name+"_virtual_base_sequence)\n"
                "    `uvm_declare_p_sequencer("+project_name+"_virtual_sequencer)\n"
                "\n"
                "    function new(string name = \""+project_name+"_virtual_base_sequence\");\n"
                "        super.new(name);\n"
                "    endfunction : new\n"
                "\n"
                "    task pre_start();\n"
                "        `uvm_info(get_type_name(),\"Starting task pre_start...\", UVM_HIGH)\n"
                "        cfg = p_sequencer.cfg;\n"
                "        events = cfg.events;\n"
                "        rm  = cfg.rm;\n"
                "        vif = p_sequencer.vif;\n"
                "        `uvm_info(get_type_name(),\"Finish task pre_start...\", UVM_HIGH)\n"
                "    endtask\n"
                "\n"
                "endclass : "+project_name+"_virtual_base_sequence\n"
                "\n"
                "\n"
                "\n"
                "//TODO : Add sequence class code.\n"
                "\n"
                "\n"
                "\n"
                "\n"
                "\n"
                )

    seq_f.close();

def gen_test(agent_num,agent):
    global project_name
    dir_path = project_name+"/dv/test/";
    try:
      test_f = open( dir_path+project_name+"_test.sv", "w" )
    except IOError:
      print ("Exiting due to Error: can't open test.sv");

    write_file_header(test_f,project_name+"test.sv")
    test_f.write(
                "`ifndef "+project_name.upper()+"_TEST__SV\n"
                "`define "+project_name.upper()+"_TEST__SV\n"
                "/*************************************************************************************/\n"
                "/**********************************Base Test******************************************/\n"
                "/*************************************************************************************/\n"
                "class "+project_name+"_base_test extends uvm_test;\n"
                "    `uvm_component_utils("+project_name+"_base_test)\n"
                "\n"
                "    uvm_event_pool events;\n"
                )
    for i in range(agent_num): 
      test_f.write(
                "    virtual "+agent[i]+"_interface "+agent[i]+"_vif;\n"
                )
    test_f.write(
                "    "+project_name+"_env_config "+project_name+"_env_cfg;\n"
                "    ral_top_block rm;\n"
                "\n"
                "    "+project_name+"_environment "+project_name+"_env;\n"
                "\n"
                "    function new(string name =\""+project_name+"_base_test\",uvm_component parent = null);\n"
                "        super.new(name,parent);\n"
                "    endfunction : new\n"
                "    \n"
                "    virtual function void build_phase(uvm_phase phase);\n"
                "\n"
                "        super.build_phase(phase);\n"
                )
    for i in range(agent_num): 
      test_f.write(
                "        if(!uvm_config_db #(virtual "+agent[i]+"_loc_interface) :: get(this,\"\",\""+agent[i]+"_vif\","+agent[i]+"_vif))\n"
                "            `uvm_fatal(get_type_name(),\"The interface is not get !!!\");\n"
                )
    test_f.write(
                "\n"
                "        rm = ral_top_block :: type_id :: create(\"rm\");\n"
                "        "+project_name+"_env = "+project_name+"_environment :: type_id :: create(\""+project_name+"_env\",this);\n"
                "        rm.build(); \n"
                "        rm.lock_model();\n"
                "        rm.reset();\n"
                "        rm.configure(null,\"\");\n"
                "        rm.set_hdl_path_root(\"tb_"+project_name+"."+project_name+"_inst\");\n"
                "\n"
                "        events = new(\"events\");\n"
                "        "+project_name+"_env_cfg = new(\""+project_name+"_env_cfg\");\n"
                "        "+project_name+"_env_cfg.events = events;\n"
                "        "+project_name+"_env_cfg.rm = rm;\n"
                )
    for i in range(agent_num): 
      test_f.write(
                "        "+project_name+"_env_cfg."+agent[i]+"_vif = "+agent[i]+"_vif;\n"
                )
    test_f.write(
                "\n"
                "        "+project_name+"_env.cfg = "+project_name+"_env_cfg;\n"
                "    endfunction : build_phase\n"
                "\n"
                "    virtual function void connect_phase(uvm_phase phase);\n"
                "        super.connect_phase(phase);\n"
                "        "+project_name+"_env.apb_env.mst_agt[0].pred.map = rm.default_map;\n"
                "        rm.default_map.set_sequencer("+project_name+"_env.vsqr."+agent[0]+"_vsqr.sqr,"+project_name+"_env."+agent[0]+".adpt);\n"
                "        rm.default_map.set_auto_predict(0);\n"
                "    endfunction : connect_phase\n"
                "    \n"
                "    virtual function void  report_phase(uvm_phase phase);\n"
                "        uvm_top.print_topology();\n"
                "    endfunction : report_phase\n"
                "\n"
                "endclass: "+project_name+"_base_test\n"
                "\n"
                "\n"
                "\n"
                "\n"
                "//TODO : Add testcase class code.\n"
                "\n"
                "\n"
                "\n"
                "\n"
                      );
    test_f.close();



if __name__ == "__main__":
    tb_gen()
