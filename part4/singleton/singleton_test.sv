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
//     File for singleton_test.sv                                                       
//----------------------------------------------------------------------------------
class msingleton;
    local static msingleton msgt;
    
    local function new();
    endfunction
 
    static function msingleton get();
        if(msgt == null)
            msgt = new();
        return msgt;
    endfunction 
endclass
 
module top;
    initial begin
        msingleton s1 = msingleton::get();
        msingleton s2 = msingleton::get();
        if(s1 == s2)
        begin
            $display("***************************");
            $display("s1 and s2 are the same msgt");
            $display("***************************");
        end
    end
endmodule
