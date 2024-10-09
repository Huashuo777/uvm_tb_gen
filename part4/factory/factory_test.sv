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
//     File for factory_test.sv                                                       
//----------------------------------------------------------------------------------
//base
class shape;
    virtual function void draw();
        $display("*******************");
        $display("Drawing a shape");
        $display("*******************");
    endfunction
endclass : shape 
//circle
class circle extends shape;
    virtual function void draw();
        $display("*******************");
        $display("Drawing a circle");
        $display("*******************");
    endfunction
endclass : circle
//rectangle
class rectangle extends shape;
    virtual function void draw();
        $display("*******************");
        $display("Drawing a rectangle");
        $display("*******************");
    endfunction
endclass : rectangle
//factory
class shapefactory;
    static circle circle_shape;
    static rectangle rectangle_shape;
    static function shape createshape(string shapeType);
        if (shapeType == "circle") 
        begin
            circle_shape = new();
            return circle_shape;
        end 
        else if (shapeType == "rectangle") 
        begin
            rectangle_shape = new(); 
            return rectangle_shape;
        end 
        else 
        begin
            $display("Invalid shape type");
            return null;
        end
    endfunction : createshape
endclass : shapefactory
//top
module tb;
    initial 
    begin
        circle circle_shape; 
        rectangle rectangle_shape;
        $cast(circle_shape,shapefactory::createshape("circle"));
        circle_shape.draw();
        $cast(rectangle_shape,shapefactory::createshape("rectangle"));
        rectangle_shape.draw();
    end
endmodule : tb
