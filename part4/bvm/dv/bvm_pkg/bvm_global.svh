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
//     File for bvm_global.svh                                                       
//----------------------------------------------------------------------------------
task run_test (string name = "");
    string bvm_testname;
    bvm_root top;
    top = bvm_root :: get();
    if($value$plusargs("BVM_TESTNAME=%s",bvm_testname))
        top.run_test(bvm_testname);
    else
    begin
        if(name=="")
        begin
            $display("[Error] The testcase has not been specified, please confirm!!!");
            $finish();
        end
        top.run_test(name);
    end
endtask : run_test
