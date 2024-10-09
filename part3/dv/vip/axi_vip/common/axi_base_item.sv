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
//     File for axi_base_item.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_BASE_ITEM__SV
`define AXI_BASE_ITEM__SV
class axi_base_item extends uvm_sequence_item;
    rand bit [31:0]         trans_num;
    rand bit [7:0]          burst_num;
    rand axi_addr_t         addr_start;

    rand axi_id_t           id_arr[int];
    rand axi_data_t         data_arr[int][int];
    rand axi_strb_t         strb_arr[int][int];
    rand axi_addr_t         addr_arr[int];
    rand axi_size_t         size_arr[int];
    rand axi_len_t          burst_len_arr[int];
    rand axi_burst_t        burst_type;
    rand axi_direction_e    direction;
    rand axi_response_e     response;
         //For collect package
         axi_len_t       c_burst_len;
         axi_id_t        c_id;
         axi_size_t      c_size;
         axi_addr_t      c_addr;
         axi_strb_t      c_strb;
         axi_data_t      c_data;
         bit             c_is_last;

    constraint trans_num_cst {
        trans_num > 0; 
    }

    constraint burst_type_cst {
        burst_type == INCR; 
    }
    constraint burst_num_cst {
        burst_num <= trans_num; 
        burst_num > trans_num/16;
    }
    constraint data_arr_cst {
        data_arr.size == burst_num; 
    }
    constraint strb_arr_cst {
        strb_arr.size == burst_num; 
    }
    constraint addr_arr_cst {
        addr_arr.size == burst_num; 
    }
    constraint burst_len_arr_cst {
        burst_len_arr.size == burst_num; 
    }
    constraint burst_len_cst {
        burst_len_arr.sum() == trans_num - burst_num;
        foreach (burst_len_arr[i]) {
            if(i==0) {
                if(addr_start % (`AXI_DATA_WIDTH/8))
                    burst_len_arr[0] == 0;
                else
                    burst_len_arr[0] inside {[0:15]};
                }
                if(i>0)
                    burst_len_arr[i] inside {[0:15]};
            }
        }
    constraint size_arr_cst {
        size_arr.size == burst_num; 
    }
    constraint id_arr_cst {
        id_arr.size == burst_num; 
    }

    `uvm_object_utils_begin(axi_base_item)
        `uvm_field_enum (axi_direction_e,direction,UVM_ALL_ON)      
        `uvm_field_int   (c_burst_len   ,UVM_ALL_ON)
        `uvm_field_int   (c_id          ,UVM_ALL_ON)
        `uvm_field_int   (c_size        ,UVM_ALL_ON)
        `uvm_field_int   (c_addr        ,UVM_ALL_ON)
        `uvm_field_int   (c_strb        ,UVM_ALL_ON)
        `uvm_field_int   (c_data        ,UVM_ALL_ON)
        `uvm_field_int   (c_is_last     ,UVM_ALL_ON)
    `uvm_object_utils_end
    extern function new(string name = "axi_base_item");
    extern function void post_randomize();
endclass

function axi_base_item :: new(string name = "axi_base_item");
    super.new(name);
endfunction : new

function void axi_base_item :: post_randomize();
    bit [7:0] number_bytes, data_bus_bytes, low_byte_lane, up_byte_lane;
    axi_addr_t addr_aligned;
    axi_addr_t addr_pre;
    data_bus_bytes =  `AXI_DATA_WIDTH/8;
    number_bytes = data_bus_bytes;
    addr_aligned = (addr_start/number_bytes) * number_bytes;
    low_byte_lane = addr_start - (addr_start/data_bus_bytes) * data_bus_bytes;
    up_byte_lane = addr_aligned + (number_bytes-1) - (addr_start/data_bus_bytes) * data_bus_bytes;
    //Burst num
    for(int i=0;i<burst_num;i++)
    begin
        id_arr[i] = $urandom();
        size_arr[i] = $clog2(`AXI_DATA_WIDTH/8); 
        if(i==0)
        begin
            addr_arr[i] = addr_start;
            addr_pre = addr_aligned;
            //If is unaligned,the first burst_len is 0;
            //if(addr_start%number_bytes)
            //begin
            //    burst_len_arr[i] = 0;
            //end
            //else begin
            //    burst_len_arr[i] = $urandom();
            //end
        end
        else
        begin
            addr_arr[i] =addr_pre + ((burst_len_arr[i-1]+1)* data_bus_bytes);
            //burst_len_arr[i] = $urandom();
            addr_pre = addr_arr[i];
        end
        //Strb
        for(int j=0;j<(burst_len_arr[i]+1);j++)
        begin
            strb_arr[i][j] = 0;
            if(j==0 && i==0)
            begin
                for(int m=low_byte_lane; m<=up_byte_lane; m++)
                begin
                    strb_arr[i][j][m] = 1'b1; 
                end
            end
            else
            begin
                strb_arr[i][j] = '1;
            end
            data_arr[i][j] = 0;
            for(int k=0;k<(`AXI_DATA_WIDTH/8);k++)
            begin
                if(strb_arr[i][j][k])
                begin
                    data_arr[i][j][k*8+:8] = $urandom();
                end
            end
        end
    end
    
endfunction : post_randomize

`endif//AXI_BASE_ITEM__SV
