#----------------------------------------------------------------------------------
# This code is copyrighted by BrentWang and cannot be used for commercial purposes
# The github address:https://github.com/brentwang-lab/uvm_tb_gen                   
# You can refer to the book <UVM Experiment Guide> for learning, this is on this github
# If you have any questions, please contact email:brent_wang@foxmail.com          
#----------------------------------------------------------------------------------
#                                                                                  
# Author  : BrentWang                                                              
# Project : UVM study                                                              
# Date    : Sat Jan 26 06:05:52 WAT 2022                                           
#----------------------------------------------------------------------------------
#                                                                                  
# Description:                                                                     
#     File for json2list.py                                                       
#----------------------------------------------------------------------------------
#!/usr/bin/python3
import os 
import sys
import argparse
import json
import re 

modules=[]

def getparse():
    parser = argparse.ArgumentParser(description="input json file , sim type and output filelist")
    parser.add_argument('-i','--input_file',help='there is no json file',required=True, default='No_Json_File')
    parser.add_argument('-t','--sim_type',help='please input simulation type:case or module or smoke or full',required=True, default='No_sim_type')
    parser.add_argument('-n','--sim_name',help='input case name or module name or special name',required=False, default='No_Name')
    parser.add_argument('-o','--output_file',help='there is no define uvm register model name',required=True, default='NO_Uvm_Register_Model')
    args = parser.parse_args()
    return args

class JsonHighLevelStruct():                                                                                                                                                                                                    
    globalmacroopt="global_macor_opt"
    modules="modules"

class moduleStruct():
    name="name"
    commonmacroopt="common_macro_opt"
    tests="tests"

class teststruct():
    module="module"
    smoke="smoke"
    full="full"
    codecoverage="codecoverage"
    iteration="iteration"
    uvmtestname="uvm_testname"
    macroopt="macro_opt"
    plusargs="plusargs_opt"


def read_alltest_json(input_file):
    global modules
    global globalmacroopt
    try:
        with open(input_file,"r") as all_test_f:
            all_tests=json.load(all_test_f)
    except json.JSONDecodeError as e:
        print(f"*****JSON file code format error!!!:\n{e}*****")
    except json.FileNotFoundError:
        print(f"*****JSON file Not Found !!!*****")
    except Exception as e:
        print(f"*****An unknown error occurred !!!*****")
    all_test_f.close()
    modules = all_tests[JsonHighLevelStruct.modules]
    globalmacroopt = all_tests[JsonHighLevelStruct.globalmacroopt]

def json2list_full(output_file):
    global modules
    for module in modules:
        f = open(output_file,"a+")
        f.write("module_name:"+module)
        f.write("\n")
        module_path= modules[module]
        try:
            with open(module_path,"r") as module_f:
                module=json.load(module_f)
        except json.JSONDecodeError as e:
            print(f"*****JSON file code format error!!!:\n{e}*****")
        except json.FileNotFoundError:
            print(f"*****JSON file Not Found !!!*****")
        except Exception as e:
            print(f"*****An unknown error occurred !!!*****")
        module_f.close()
        tests = module[moduleStruct.tests]  
        modulecommonopt = module[moduleStruct.commonmacroopt]
        for test in tests:
            if not tests[test][teststruct.full] == "true": 
                continue
            uvmtestname="uvm_testname="+tests[test][teststruct.uvmtestname]
            iteration=" iteration="+tests[test][teststruct.iteration]
            vcsopt = " macro_opt=empty" if tests[test][teststruct.macroopt]== "" else " macro_opt=+define"+globalmacroopt+modulecommonopt+tests[test][teststruct.macroopt]
            plusargs=" plusargs_opt=empty" if tests[test][teststruct.plusargs] == "" else " plusargs_opt="+tests[test][teststruct.plusargs]
            coverage=" codecoverage=open" if tests[test][teststruct.codecoverage] == "true" else " codecoverage=close"
            line=uvmtestname+iteration+coverage+vcsopt+plusargs
            f.write(line)
            f.write("\n")
        f.close()
def json2list_module(module,output_file):
    global modules
    f = open(output_file,"a+")
    f.write("module_name:"+module)
    f.write("\n")
    module_path= modules[module]
    try:
        with open(module_path,"r") as module_f:
            module=json.load(module_f)
    except json.JSONDecodeError as e:
        print(f"*****JSON file code format error!!!:\n{e}*****")
    except json.FileNotFoundError:
        print(f"*****JSON file Not Found !!!*****")
    except Exception as e:
        print(f"*****An unknown error occurred !!!*****")
    module_f.close()
    tests = module[moduleStruct.tests]  
    modulecommonopt = module[moduleStruct.commonmacroopt]
    for test in tests:
        if not tests[test][teststruct.full] == "true": 
            continue
        uvmtestname="uvm_testname="+tests[test][teststruct.uvmtestname]
        iteration=" iteration="+tests[test][teststruct.iteration]
        vcsopt = " macro_opt=empty" if tests[test][teststruct.macroopt]== "" else " macro_opt=+define"+globalmacroopt+modulecommonopt+tests[test][teststruct.macroopt]
        plusargs=" plusargs_opt=empty" if tests[test][teststruct.plusargs] == "" else " plusargs_opt="+tests[test][teststruct.plusargs]
        coverage=" codecoverage=open" if tests[test][teststruct.codecoverage] == "true" else " codecoverage=close"
        line=uvmtestname+iteration+coverage+vcsopt+plusargs
        f.write(line)
        f.write("\n")
    f.close()

def json2list_special(special_type,output_file):
    global modules
    for module in modules:
        f = open(output_file,"a+")
        f.write("module_name:"+module)
        f.write("\n")
        module_path= modules[module]
        try:
            with open(module_path,"r") as module_f:
                module=json.load(module_f)
        except json.JSONDecodeError as e:
            print(f"*****JSON file code format error!!!:\n{e}*****")
        except json.FileNotFoundError:
            print(f"*****JSON file Not Found !!!*****")
        except Exception as e:
            print(f"*****An unknown error occurred !!!*****")
        module_f.close()
        tests = module[moduleStruct.tests]  
        modulecommonopt = module[moduleStruct.commonmacroopt]
        for test in tests:
            if not tests[test][special_type] == "true": 
                continue
            uvmtestname="uvm_testname="+tests[test][teststruct.uvmtestname]
            iteration=" iteration="+tests[test][teststruct.iteration]
            vcsopt = " macro_opt=empty" if tests[test][teststruct.macroopt]== "" else " macro_opt=+define"+globalmacroopt+modulecommonopt+tests[test][teststruct.macroopt]
            plusargs=" plusargs_opt=empty" if tests[test][teststruct.plusargs] == "" else " plusargs_opt="+tests[test][teststruct.plusargs]
            coverage=" codecoverage=open" if tests[test][teststruct.codecoverage] == "true" else " codecoverage=close"
            line=uvmtestname+iteration+coverage+vcsopt+plusargs
            f.write(line)
            f.write("\n")
        f.close()

def json2list_case(case_name,output_file):
    global modules
    match= re.match(r'^([a-z]+)_.*',case_name); 
    module = match.group(1);
    f = open(output_file,"a+")
    f.write("module_name:"+module)
    f.write("\n")
    module_path= modules[module]
    try:
        with open(module_path,"r") as module_f:
            module=json.load(module_f)
    except json.JSONDecodeError as e:
        print(f"*****JSON file code format error!!!:\n{e}*****")
    except json.FileNotFoundError:
        print(f"*****JSON file Not Found !!!*****")
    except Exception as e:
        print(f"*****An unknown error occurred !!!*****")
    module_f.close()
    tests = module[moduleStruct.tests]  
    modulecommonopt = module[moduleStruct.commonmacroopt]
    if case_name not in tests:
        print("*****Error !!!,no this case*****");
        exit()
    for test in tests:
        if test == case_name:
            uvmtestname="uvm_testname="+tests[test][teststruct.uvmtestname]
            iteration=" iteration="+tests[test][teststruct.iteration]
            vcsopt = " macro_opt=empty" if tests[test][teststruct.macroopt]== "" else " macro_opt=+define"+globalmacroopt+modulecommonopt+tests[test][teststruct.macroopt]
            plusargs=" plusargs_opt=empty" if tests[test][teststruct.plusargs] == "" else " plusargs_opt="+tests[test][teststruct.plusargs]
            coverage=" codecoverage=open" if tests[test][teststruct.codecoverage] == "true" else " codecoverage=close"
            line=uvmtestname+iteration+coverage+vcsopt+plusargs
            f.write(line)
            f.write("\n")
    f.close()

def output_list_file(sim_type,input_file,sim_name,output_file):
    if sim_type == "full":
            json2list_full(output_file);
    if sim_type == "module":
            json2list_module(sim_name,output_file);
    if sim_type == "case":
            json2list_case(sim_name,output_file);
    if sim_type == "special":
            json2list_special(sim_name,output_file);

if __name__=="__main__":
    args_t = getparse()
    read_alltest_json(args_t.input_file)
    output_list_file(args_t.sim_type,args_t.input_file,args_t.sim_name,args_t.output_file)
