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
#     File for regress.py                                                       
#----------------------------------------------------------------------------------
#!/usr/bin/python3
import os 
import sys
import getopt
import json
import re 
import time
import threading
import random
import argparse
from art import *
#print("regress script!!!")

def gen_debug_file(execute_cmd,sim_dir):
    file_path =sim_dir+"/execute_cmd.txt"
    f = open(file_path,"a")
    f.write(execute_cmd)
    f.write("\n")
    f.close()

def run_sim(compile_cmd,sim_cmd):
    os.system(compile_cmd);
    os.system(sim_cmd);
def get_time():
    current_time = int(time.time())
    localtime = time.localtime(current_time)
    dt = time.strftime('%Y_%m_%d_%H_%M_%S', localtime)
    return dt;
def write_file(file_path,write_content):
    f = open(file_path,"a")
    f.write(write_content)
    f.write("\n");
    f.close()
def print_result_art(result_info,sim_path):
    sim_log_path = sim_path + "/sim.log"
    cmp_log_path = sim_path + "/compile.log"
    art_string = text2art(result_info,font='block')
    print(art_string)
    if result_info == "PASS" or result_info == "FAIL" or result_info == "EXIT": 
        with open(sim_log_path,'a') as file:
            file.write(art_string)
    elif result_info == "CMPERR":
        with open(cmp_log_path,'a') as file:
            file.write(art_string)

def wait_finish_and_check(sim_thread_list,sim_dir_list,result_path):
    """
        result(PASS/FAIL/EXIT) list of case simulation finish 
    """
    result_total_case_num = len(sim_thread_list)
    result_pass_case_num = 0
    result_fail_case_num = 0
    result_cmperror_case_num = 0
    result_exit_case_num = 0
    result_run_case_num = 0
    case_finish_result_list = []
    # case list of finish simulation
    finish_sim_dir_list = []
    thread_num=0
    while thread_num < len(sim_thread_list):
        if sim_thread_list[thread_num].is_alive()==False:
            #if thread is not alive,the simulation is finish
            #check sim.log for uvm_error/uvm_fatal
            result_info=check_sim_log(sim_dir_list[thread_num])
            if(result_info == "PASS"):
                result_pass_case_num = result_pass_case_num+1
            elif(result_info == "FAIL"):
                result_fail_case_num = result_fail_case_num+1
            elif(result_info == "CMPERR"):
                result_cmperror_case_num = result_cmperror_case_num+1
            elif(result_info == "EXIT"):
                result_exit_case_num = result_exit_case_num+1
            #print result info
            print_result_art(result_info,sim_dir_list[thread_num])
            case_finish_result_list.append(result_info)
            finish_sim_dir_list.append(sim_dir_list[thread_num])
            del sim_dir_list[thread_num]
            del sim_thread_list[thread_num] 
            thread_num = 0
            #result file is update
            if os.path.exists(result_path):
                os.remove(result_path)
            write_file(result_path,"[RESULT_INFO] Dir="+result_path)
            write_file(result_path,"-------------------------------------------------------------------------------------------------")
            write_file(result_path,"TEST                        STATUS")
            write_file(result_path,"-------------------------------------------------------------------------------------------------")
            #if case is finish,check log and write result.list
            finish_case_n=0
            while finish_case_n < len(finish_sim_dir_list):
                match_casename = re.match(r'.*\/(\S*)$',finish_sim_dir_list[finish_case_n])
                casename = match_casename.group(1)
                #write .result
                write_file(result_path,casename+"    "+case_finish_result_list[finish_case_n])
                finish_case_n=finish_case_n+1
            #if case is not finish,write running to result.list
            result_run_case_num = len(sim_dir_list) 
            runing_case_n = 0
            while runing_case_n < len(sim_dir_list):
                match_casename = re.match(r'.*\/(\S*)$',sim_dir_list[runing_case_n])
                casename = match_casename.group(1)
                write_file(result_path,casename+"    Running")
                runing_case_n=runing_case_n+1
                #result_run_case_num = result_run_case_num+1
            result_pass_rate = result_pass_case_num/result_total_case_num*100
            write_file(result_path,"-------------------------------------------------------------------------------------------------")
            write_file(result_path,"TOTAL:"+str(result_total_case_num)+"    PASS:"+str(result_pass_case_num)+"    FAIL:"+str(result_fail_case_num)+"    CMPERR:"+str(result_cmperror_case_num)+"    RUNNING:"+str(result_run_case_num)+"    EXIT:"+str(result_exit_case_num)+"    PASS_RATE:"+str(result_pass_rate)[:5]+"%")
            write_file(result_path,"-------------------------------------------------------------------------------------------------")
            pass_rate_string = "TOTAL:"+str(result_total_case_num)+"    PASS:"+str(result_pass_case_num)+"    FAIL:"+str(result_fail_case_num)+"    CMPERR:"+str(result_cmperror_case_num)+"    RUNNING:"+str(result_run_case_num)+"    EXIT:"+str(result_exit_case_num)+"    PASS_RATE:"+str(result_pass_rate)[:5]+"%"
        else:
            thread_num=thread_num+1
            if thread_num>=len(sim_thread_list):
                thread_num=0
    print(pass_rate_string)
def read_list_and_run(case_info_list,sim_dir):
    compile_parameter=""
    sim_parameter=""
    coverage_parameter=""
    dump_vpd_parameter=""
    sim_dir_list=[]
    sim_thread_list = []
    case_info_list_f = open(case_info_list,"r")
    case_info_content =case_info_list_f.readlines()
    case_info_rows = len(case_info_content);
    case_info_row=0;
    for case_info_row in range(case_info_rows):
        match_module = re.match(r'module_name:(\S+)',case_info_content[case_info_row])
        #get module name 
        if(match_module):
            module_js =match_module.group(1)
            module_file = "../"+module_js+"/top/tb_"+module_js+".f"
            continue
        #get case info
        else:
            match_case_info = re.match(r'uvm_testname=(\S+)\siteration=([0-9]+)\scodecoverage=(\S+)\smacro_opt=(\S+)\splusargs_opt=(\S+)',case_info_content[case_info_row])
            casename_js = match_case_info.group(1)
            iteration_js = match_case_info.group(2)
            codecoverage_js = match_case_info.group(3)
            macro_js = match_case_info.group(4)
            plusage_js = match_case_info.group(5)
            case_iter=0
            while case_iter< int(iteration_js):
                sim_iteration_dir = sim_dir+"/sim_"+casename_js+"_iter"+str(case_iter)
                if(sim_seed != None):
                    seed = sim_seed
                    iteration_js = 1 #If seed is specified, simulation is execute once.
                else:
                    seed = random.randint(0, 999999);
                if(macro_js != "empty"):
                    compile_parameter=macro_js;
                if(plusage_js != "empty"):
                    sim_parameter=plusage_js;
                if(codecoverage_js == "open" and  collect_coverage == True):
                    coverage_parameter = " -cm line+cond+fsm+tgl+branch+assert -cm_log "+sim_iteration_dir+"/cover.log "
                if(dump_vpd == True):
                    dump_vpd_parameter =" +define+DUMP_VPD";

                #compile_cmd = "vcs -full64 +vpdfile+"+sim_iteration_dir+"/simv.vpd -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 -f "+module_file+" -l "+sim_iteration_dir+"/compile.log +define+C_MODEL -o "+sim_iteration_dir+"/simv -Mdir="+sim_iteration_dir+"/csrc -k "+sim_iteration_dir+"/ucli.key"+" "+compile_parameter+" "+coverage_parameter+dump_vpd_parameter 
                #sim_cmd = sim_iteration_dir+"/simv -full64 +ntb_random_seed="+str(seed)+" +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME="+casename_js+" -l "+sim_iteration_dir+"/sim.log  +notimingcheck +vpdfile+"+sim_iteration_dir+"/simv.vpd -k "+sim_iteration_dir+"/ucli.key "+sim_parameter+coverage_parameter+dump_vpd_parameter
                compile_cmd = "vcs -full64 +vpdfile+"+sim_iteration_dir+"/simv.vpd -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 -f "+module_file+" -l "+sim_iteration_dir+"/compile.log +define+C_MODEL -o "+sim_iteration_dir+"/simv -Mdir="+sim_iteration_dir+"/csrc -k "+sim_iteration_dir+"/ucli.key"+" "+compile_parameter+" "+coverage_parameter+dump_vpd_parameter 
                sim_cmd = sim_iteration_dir+"/simv -full64 +ntb_random_seed="+str(seed)+" +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME="+casename_js+" -l "+sim_iteration_dir+"/sim.log  +notimingcheck +vpdfile+"+sim_iteration_dir+"/simv.vpd -k "+sim_iteration_dir+"/ucli.key "+sim_parameter+coverage_parameter+dump_vpd_parameter
                sim_dir_list.append(sim_iteration_dir)
                os.makedirs(sim_iteration_dir)
                t=threading.Thread(target=run_sim,args=(compile_cmd,sim_cmd,))
                sim_thread_list.append(t)
                t.start()
                case_iter=case_iter+1
                #generate debug file
                debug_iteration_dir = sim_iteration_dir+"/debug"
                compile_cmd_for_debug = "vcs -full64 +vpdfile+"+debug_iteration_dir+"/simv.vpd -sverilog -debug_access+all -timescale=1ns/1ns -ntb_opts uvm-1.1 -f "+module_file+" -l "+debug_iteration_dir+"/compile.log +define+C_MODEL -o "+debug_iteration_dir+"/simv -Mdir="+debug_iteration_dir+"/csrc -k "+debug_iteration_dir+"/ucli.key"+" "+compile_parameter+" "+coverage_parameter+dump_vpd_parameter
                sim_cmd_for_debug = debug_iteration_dir+"/simv -full64 +ntb_random_seed="+str(seed)+" +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME="+casename_js+" -l "+debug_iteration_dir+"/sim.log  +notimingcheck +vpdfile+"+debug_iteration_dir+"/simv.vpd -k "+debug_iteration_dir+"/ucli.key "+sim_parameter+coverage_parameter+dump_vpd_parameter
                execute_cmd = "python3 regress.py -c "+casename_js+" -vpd "+"-seed "+str(seed)
                gen_debug_file(execute_cmd,sim_iteration_dir)
            num=0
    return sim_thread_list,sim_dir_list;

def check_sim_log(sim_iter_dir):
    #fixme need to change check log line number
    if os.path.exists(sim_iter_dir+"/sim.log"):
        sim_f = open(sim_iter_dir+"/sim.log","r")
        content = sim_f.readlines()
        row=len(content)
        i=0
        while i < row:
            match1 = re.match(r'UVM_ERROR :\s*([0-9]+)',content[i])
            if match1:
                match2 = re.match(r'UVM_FATAL :\s*([0-9]+)',content[i+1])
                if match1.group(1) == "0" and match2.group(1) == "0":
                    return "PASS" 
                else:
                    return "FAIL" 
                break
            i=i+1
        return "EXIT"
    else:
        return "CMPERR" 
                    
def get_cmd_line():
    global case_name
    global module_name
    global dump_vpd
    global full_sim
    global smoke_sim
    global module_sim
    global case_sim
    global collect_coverage
    global sim_seed
    case_name   = ""
    module_name = ""
    sim_seed = ""
    dump_vpd    = False
    case_sim    = False
    full_sim    = False
    smoke_sim   = False
    module_sim  = False
    collect_coverage = False


    parser = argparse.ArgumentParser()
    parser.add_argument('-c','-case',dest='case_name',help='simulation type is case')
    parser.add_argument('-m','-module',dest='module_name',help='simulation type is module')
    parser.add_argument('-full',dest='full_sim',action='store_true',help='simulation type is full')
    parser.add_argument('-smoke',dest='smoke_sim',action='store_true',help='simulation type is smoke')
    parser.add_argument('-vpd',dest='dump_vpd',action='store_true',help='dump vpd wavefile')
    parser.add_argument('-cov',dest='collect_coverage',action='store_true',help='collect coverage in simulation')
    parser.add_argument('-seed',dest='sim_seed',help='seed for simulation')
    args = parser.parse_args()

    case_name = args.case_name
    module_name = args.module_name
    full_sim = args.full_sim
    smoke_sim = args.smoke_sim
    dump_vpd = args.dump_vpd

    sim_seed = args.sim_seed
    collect_coverage = args.collect_coverage
    if(case_name != None):
        case_sim = True
    if(module_name != None):
        module_sim = True
def gen_ral_file():
    reg_table_path = "../ral/reg_table.xlsx"
    ral_top_path = "../ral/ral_top.sv"
    if not os.path.exists(reg_table_path):
        raise FileNotFoundError(f"Reg_table file is not found !!!")
    os.system("python3 ./script/gen_ral_top.py -i "+reg_table_path+" -o "+ral_top_path)
    if not os.path.exists(ral_top_path):
        raise FileNotFoundError(f"Ral file generate error !!!")
          
def execute_sim():
    sim_dir_list=[]
    sim_thread_list = []
    gen_ral_file()
    if full_sim == True:
        tm = get_time()
        sim_dir = "./sim_full_"+tm;
        os.makedirs(sim_dir)
        case_info_list = sim_dir+"/"+"full.list";
        result_path = sim_dir+"/"+"full.result"
        os.system("python3 ./script/json2list.py -i ./script/test.json -t full -o "+case_info_list+"");
        sim_thread_list,sim_dir_list = read_list_and_run(case_info_list,sim_dir)
        wait_finish_and_check(sim_thread_list,sim_dir_list,result_path);

    if module_sim == True:
        tm = get_time()
        sim_dir = "./sim_"+module_name+"_"+tm;
        os.makedirs(sim_dir)
        case_info_list= sim_dir+"/"+module_name+".list";
        result_path = sim_dir+"/"+module_name+".result"
        os.system("python3 ./script/json2list.py -i ./script/test.json -t module -n "+module_name+" -o "+case_info_list+"");
        sim_thread_list,sim_dir_list = read_list_and_run(case_info_list,sim_dir)
        wait_finish_and_check(sim_thread_list,sim_dir_list,result_path);

    if smoke_sim == True:
        tm = get_time()
        sim_dir = "./sim_smoke_"+tm;
        os.makedirs(sim_dir)
        case_info_list= sim_dir+"/"+"smoke.list";
        result_path = sim_dir+"/smoke.result"
        os.system("python3 ./script/json2list.py -i ./script/test.json -t special -n smoke -o "+case_info_list+"");
        sim_thread_list,sim_dir_list = read_list_and_run(case_info_list,sim_dir)
        wait_finish_and_check(sim_thread_list,sim_dir_list,result_path);

    if case_sim == True:
        tm = get_time()
        sim_dir = "./sim_"+case_name+"_"+tm;
        os.makedirs(sim_dir)
        case_info_list = sim_dir+"/"+case_name+".list"
        result_path = sim_dir+"/"+case_name+".result"
        os.system("python3 ./script/json2list.py -i ./script/test.json -t case -n "+case_name+" -o "+case_info_list+"");
        sim_thread_list,sim_dir_list = read_list_and_run(case_info_list,sim_dir)
        wait_finish_and_check(sim_thread_list,sim_dir_list,result_path);

if __name__=="__main__":
    get_cmd_line()
    execute_sim()
