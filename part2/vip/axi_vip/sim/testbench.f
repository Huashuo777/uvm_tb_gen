-timescale=1ns/1ps

//-------------------------------------
// SV Define
//-------------------------------------
+define+AXI_MASTER_NUM=1
+define+AXI_SLAVE_NUM=1
+define+AXI_STRB_WIDTH=16
+define+AXI_ADDR_WIDTH=32
+define+AXI_DATA_WIDTH=32
+define+AXI_SIZE_WIDTH=4
//-------------------------------------
// Apb env filelist
//-------------------------------------
-f ../env/axi_env.f
// Case List
//-------------------------------------
../test/axi_base_test.sv
../test/axi_direct_test.sv
../test/axi_ral_test.sv
../test/axi_reset_test.sv

//-------------------------------------
// Top Module
//-------------------------------------
testbench.sv

