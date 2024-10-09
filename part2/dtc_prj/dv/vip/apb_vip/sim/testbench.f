-timescale=1ns/1ps

//-------------------------------------
// SV Define
//-------------------------------------
+define+APB_MASTER_NUM=1
+define+APB_SLAVE_NUM=1
+define+APB_ADDR_WIDTH=32
+define+APB_DATA_WIDTH=32
//-------------------------------------
// Apb env filelist
//-------------------------------------
-f ../env/apb_env.f
// Case List
//-------------------------------------
../test/apb_base_test.sv
../test/apb_direct_test.sv
../test/apb_reset_test.sv
../test/apb_ral_test.sv

//-------------------------------------
// Top Module
//-------------------------------------
testbench.sv
