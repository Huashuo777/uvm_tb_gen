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
//     File for dtc_loc_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef DTC_LOC_ITEM__SV
`define DTC_LOC_ITEM__SV

class dtc_loc_item extends uvm_sequence_item;

    rand dtc_loc_direction_e  direction;
    rand bit [31:0] trans_num;
    rand bit [31:0] addr_start;
    rand bit [31:0] data_arr[int];
    rand bit [31:0] addr_arr[int];
    rand bit [31:0] c_data;
    rand bit [31:0] c_addr;

    constraint trans_num_cst {
        trans_num > 0;
    }

    constraint data_arr_cst {
        data_arr.size() == trans_num;
    }

    constraint addr_arr_cst {
        addr_arr.size() == trans_num;
        foreach(addr_arr[i]) {
            if(i==0)
                addr_arr[0] == addr_start;
            else
                addr_arr[i] == addr_arr[i-1] + 32'h4;
        }
    }


    `uvm_object_utils_begin(dtc_loc_item)
        `uvm_field_int(c_data,UVM_ALL_ON)
        `uvm_field_int(c_addr,UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name ="dtc_loc_item");
endclass: dtc_loc_item

function dtc_loc_item :: new(string name ="dtc_loc_item");
    super.new(name);
endfunction: new

`endif // DTC_LOC_ITEM__SV
