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
//     File for apb_env_interface.sv                                                       
//----------------------------------------------------------------------------------
`ifndef APB_ENV_INTERFACE__SV
`define APB_ENV_INTERFACE__SV
`include "apb_master_interface.sv"
`include "apb_slave_interface.sv"
interface apb_env_interface();

    apb_master_interface mst_if[16]();
    apb_slave_interface slv_if[16]();


    function virtual apb_master_interface get_master_if(int idx);
        if (idx>=`APB_MASTER_NUM) begin
            $display("[FATAL] apb_master_interface: the master index %0d has not been defined, check the APB_MASTER_NUM define", idx);
            $finish;
        end
        
        // Max: 16
        case(idx)
          00: return mst_if[00];
          01: return mst_if[01];
          02: return mst_if[02];
          03: return mst_if[03];
          04: return mst_if[04];
          05: return mst_if[05];
          06: return mst_if[06];
          07: return mst_if[07];
          08: return mst_if[08];
          09: return mst_if[09];
          10: return mst_if[10];
          11: return mst_if[11];
          12: return mst_if[12];
          13: return mst_if[13];
          14: return mst_if[14];
          15: return mst_if[15];
        endcase
    endfunction

    function virtual apb_slave_interface get_slave_if(int idx);
        if (idx>=`APB_SLAVE_NUM) begin
            $display("[FATAL] apb_slave_interface: the slave index %0d has not been defined, check the APB_MASTER_NUM define", idx);
            $finish;
        end
        
        // Max: 16
        case(idx)
          00: return slv_if[00];
          01: return slv_if[01];
          02: return slv_if[02];
          03: return slv_if[03];
          04: return slv_if[04];
          05: return slv_if[05];
          06: return slv_if[06];
          07: return slv_if[07];
          08: return slv_if[08];
          09: return slv_if[09];
          10: return slv_if[10];
          11: return slv_if[11];
          12: return slv_if[12];
          13: return slv_if[13];
          14: return slv_if[14];
          15: return slv_if[15];
        endcase
    endfunction

endinterface : apb_env_interface
`endif //APB_ENV_INTERFACE__SV
