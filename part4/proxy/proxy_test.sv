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
//     File for proxy_test.sv                                                       
//----------------------------------------------------------------------------------
virtual class object;
    string instname;
endclass : object

virtual class object_proxy;
    pure virtual function object create_object();
endclass : object_proxy

object_proxy factory[object_proxy];

class object_register #(type T) extends object_proxy;

    virtual function object create_object();
    begin
        T obj = new();
        return obj;
    end
    endfunction : create_object

    local static object_register #(T) me = get();

    static function object_register#(T) get();
        if(me == null)
        begin
            me = new();
            factory[me] = me;
        end
        return me;
    endfunction : get

    static function T create(input string instname);

        T obj;
        $cast(obj,factory[get()].create_object);
        obj.instname = instname;
        return obj;
    endfunction : create

endclass : object_register

class circle extends object;
    typedef object_register #(circle) type_id;
    virtual function void draw();
        $display("*******************");
        $display("Drawing a circle");
        $display("*******************");
    endfunction
endclass : circle

class rectangle extends object;
    typedef object_register #(rectangle) type_id;
    virtual function void draw();
        $display("*******************");
        $display("Drawing a rectangle");
        $display("*******************");
    endfunction
endclass : rectangle

class elliptic extends circle;
    typedef object_register #(elliptic) type_id;
    virtual function void draw();
        $display("*******************");
        $display("Drawing a elliptic");
        $display("*******************");
    endfunction
endclass : elliptic
//top
module tb;
    initial 
    begin
        circle circle_shape; 
        rectangle rectangle_shape;
        circle_shape = circle :: type_id :: create("circle_shape");
        circle_shape.draw();
        rectangle_shape = rectangle :: type_id :: create("rectangle_shape");
        rectangle_shape.draw();
        factory[circle :: type_id::get()] = elliptic :: type_id :: get();
        circle_shape = circle :: type_id :: create("circle_shape");
        circle_shape.draw();
    end
endmodule : tb
