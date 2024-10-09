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
//     File for parameter_class_test.sv                                                       
//----------------------------------------------------------------------------------
class parameter_class #(parameter type T=int);
    T value;
    
    function new(T value);
        this.value = value;
    endfunction
 
endclass
 
module top;
    initial begin
        parameter_class#(int) int_type;
        parameter_class#(string) string_type;

        int_type = new(10);
        string_type = new("This is string type");

        $display("************************************");
        $display("The inc is: %d",int_type.value);
        $display("The stringc is: %s",string_type.value);
        $display("************************************");
    end
endmodule
