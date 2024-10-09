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
//     File for tb_dtc.sv                                                       
//----------------------------------------------------------------------------------
`ifndef TB_DTC__SV
`define TB_DTC__SV
module tb_dtc;

    real  clk_period = 10;
    import uvm_pkg::*;
    reg clk;
    bit reset_n ;
    dadd_loc_interface dadd_loc_if(clk,reset_n);
    dsel_loc_interface dsel_loc_if(clk,reset_n);
    dtc_loc_interface dtc_loc_if(clk,reset_n);
    apb_env_interface dadd_apb_if();
    apb_env_interface dsel_apb_if();
    axi_env_interface dsel_axi_if();
    apb_env_interface dtc_apb_if();
    axi_env_interface dtc_axi_if();

    //clock generater
    initial begin 
        clk = 1'b0;
        if($value$plusargs("CLK_PERIOD=%d",clk_period))
        begin
            $display("This simulation CLK_PERIOD is %f",clk_period);
            if(clk_period > 0);
            forever
                clk = #(clk_period/2.0) ~ clk;
        end
        else
        begin
            $display("This simulation CLK_PERIOD is %f",clk_period);
            forever
                clk = #(clk_period/2.0) ~ clk;
        end
    end

    initial begin
        run_test();
    end

    initial begin
        uvm_config_db #(virtual dadd_loc_interface) :: set (uvm_root::get(),"uvm_test_top","dadd_loc_vif",dadd_loc_if);
        uvm_config_db #(virtual dsel_loc_interface) :: set (uvm_root::get(),"uvm_test_top","dsel_loc_vif",dsel_loc_if);
        uvm_config_db #(virtual apb_env_interface):: set(uvm_root::get(), "uvm_test_top", "dadd_apb_vif", dadd_apb_if);
        uvm_config_db #(virtual apb_env_interface):: set(uvm_root::get(), "uvm_test_top", "dsel_apb_vif", dsel_apb_if);
        uvm_config_db #(virtual axi_env_interface):: set(uvm_root::get(), "uvm_test_top", "dsel_axi_vif", dsel_axi_if);
        uvm_config_db #(virtual dtc_loc_interface) :: set (uvm_root::get(),"uvm_test_top","dtc_loc_vif",dtc_loc_if);
        uvm_config_db #(virtual apb_env_interface):: set(uvm_root::get(), "uvm_test_top", "dtc_apb_vif", dtc_apb_if);
        uvm_config_db #(virtual axi_env_interface):: set(uvm_root::get(), "uvm_test_top", "dtc_axi_vif", dtc_axi_if);
    end

    initial begin
        reset_n = 0;
        #100ns;
        reset_n = 1;
    end

    assign dadd_apb_if.mst_if[0].pclk = clk;
    assign dadd_apb_if.mst_if[0].preset_n = reset_n;
    assign dadd_apb_if.mst_if[0].pslverr = 0;

    assign dsel_apb_if.mst_if[0].pclk = clk;
    assign dsel_apb_if.mst_if[0].preset_n = reset_n;
    assign dsel_apb_if.mst_if[0].pslverr = 0;

    assign dsel_axi_if.mst_if[0].aclk =clk;
    assign dsel_axi_if.mst_if[0].areset_n =reset_n;

    assign dtc_apb_if.mst_if[0].pclk = clk;
    assign dtc_apb_if.mst_if[0].preset_n = reset_n;
    assign dtc_apb_if.mst_if[0].pslverr = 0;

    assign dtc_axi_if.mst_if[0].aclk =clk;
    assign dtc_axi_if.mst_if[0].areset_n =reset_n;

    initial begin
        $vcdplusautoflushon;
        $vcdpluson();
    end
    //OOMR (Out Of Module Reference)
    //dadd
    assign dadd_loc_if.dadd_in_en   = dtc_inst.dadd_inst.dadd_in_en;
    assign dadd_loc_if.dadd_in_addr = dtc_inst.dadd_inst.dadd_in_addr;
    assign dadd_loc_if.dadd_in      = dtc_inst.dadd_inst.dadd_in;
    assign dadd_loc_if.dadd_out_en  = dtc_inst.dadd_inst.dadd_out_en;
    assign dadd_loc_if.dadd_out_addr= dtc_inst.dadd_inst.dadd_out_addr;
    assign dadd_loc_if.dadd_out     = dtc_inst.dadd_inst.dadd_out;
    assign dadd_apb_if.mst_if[0].psel    = dtc_inst.dadd_inst.psel   ;
    assign dadd_apb_if.mst_if[0].paddr   = dtc_inst.dadd_inst.paddr  ;
    assign dadd_apb_if.mst_if[0].penable = dtc_inst.dadd_inst.penable;
    assign dadd_apb_if.mst_if[0].pwrite  = dtc_inst.dadd_inst.pwrite ;
    assign dadd_apb_if.mst_if[0].pwdata  = dtc_inst.dadd_inst.pwdata ;
    assign dadd_apb_if.mst_if[0].pready  = dtc_inst.dadd_inst.pready ;
    assign dadd_apb_if.mst_if[0].prdata  = dtc_inst.dadd_inst.prdata ;
    //dsel
    assign dsel_loc_if.dsel_in_en   = dtc_inst.dsel_inst.loc_data_in_en_b;
    assign dsel_loc_if.dsel_in_addr = dtc_inst.dsel_inst.loc_data_in_addr_b;
    assign dsel_loc_if.dsel_in      = dtc_inst.dsel_inst.loc_data_in_b;
    assign dsel_apb_if.mst_if[0].psel    = dtc_inst.dsel_inst.psel   ;
    assign dsel_apb_if.mst_if[0].paddr   = dtc_inst.dsel_inst.paddr  ;
    assign dsel_apb_if.mst_if[0].penable = dtc_inst.dsel_inst.penable;
    assign dsel_apb_if.mst_if[0].pwrite  = dtc_inst.dsel_inst.pwrite ;
    assign dsel_apb_if.mst_if[0].pwdata  = dtc_inst.dsel_inst.pwdata ;
    assign dsel_apb_if.mst_if[0].pready  = dtc_inst.dsel_inst.pready ;
    assign dsel_apb_if.mst_if[0].prdata  = dtc_inst.dsel_inst.prdata ;
    assign dsel_axi_if.mst_if[0].awid        = dtc_inst.dsel_inst.axi_aw_id    ;
    assign dsel_axi_if.mst_if[0].awaddr      = dtc_inst.dsel_inst.axi_aw_addr  ;
    assign dsel_axi_if.mst_if[0].awlen       = dtc_inst.dsel_inst.axi_aw_len   ;
    assign dsel_axi_if.mst_if[0].awsize      = dtc_inst.dsel_inst.axi_aw_size  ;
    assign dsel_axi_if.mst_if[0].awvalid     = dtc_inst.dsel_inst.axi_aw_valid ;
    assign dsel_axi_if.mst_if[0].awready     = dtc_inst.dsel_inst.axi_aw_ready ;
    assign dsel_axi_if.mst_if[0].wdata       = dtc_inst.dsel_inst.axi_w_data   ;
    assign dsel_axi_if.mst_if[0].wstrb       = dtc_inst.dsel_inst.axi_w_strb   ;
    assign dsel_axi_if.mst_if[0].wlast       = dtc_inst.dsel_inst.axi_w_last   ;
    assign dsel_axi_if.mst_if[0].wvalid      = dtc_inst.dsel_inst.axi_w_valid  ;
    assign dsel_axi_if.mst_if[0].wready      = dtc_inst.dsel_inst.axi_w_ready  ;
    assign dsel_axi_if.mst_if[0].bid         = dtc_inst.dsel_inst.axi_b_id     ;
    assign dsel_axi_if.mst_if[0].bvalid      = dtc_inst.dsel_inst.axi_b_valid  ;
    assign dsel_axi_if.mst_if[0].bready      = dtc_inst.dsel_inst.axi_b_ready  ;
    assign dsel_axi_if.mst_if[0].arid        = dtc_inst.dsel_inst.axi_ar_id    ;
    assign dsel_axi_if.mst_if[0].araddr      = dtc_inst.dsel_inst.axi_ar_addr  ;
    assign dsel_axi_if.mst_if[0].arlen       = dtc_inst.dsel_inst.axi_ar_len   ;
    assign dsel_axi_if.mst_if[0].arsize      = dtc_inst.dsel_inst.axi_ar_size  ;
    assign dsel_axi_if.mst_if[0].arvalid     = dtc_inst.dsel_inst.axi_ar_valid ;
    assign dsel_axi_if.mst_if[0].arready     = dtc_inst.dsel_inst.axi_ar_ready ;
    assign dsel_axi_if.mst_if[0].rid         = dtc_inst.dsel_inst.axi_r_id     ;
    assign dsel_axi_if.mst_if[0].rdata       = dtc_inst.dsel_inst.axi_r_data   ;
    assign dsel_axi_if.mst_if[0].rlast       = dtc_inst.dsel_inst.axi_r_last   ;
    assign dsel_axi_if.mst_if[0].rvalid      = dtc_inst.dsel_inst.axi_r_valid  ;
    assign dsel_axi_if.mst_if[0].rready      = dtc_inst.dsel_inst.axi_r_ready  ;

dtc dtc_inst
    (
    .sys_clk        (clk),
    .sys_rst_n      (reset_n),
    .dadd_in_en     (dtc_loc_if.dadd_in_en),
    .dadd_in        (dtc_loc_if.dadd_in),
    .dadd_in_addr   (dtc_loc_if.dadd_in_addr),
    .psel           (dtc_apb_if.mst_if[0].psel   ),
    .paddr          (dtc_apb_if.mst_if[0].paddr  ),
    .penable        (dtc_apb_if.mst_if[0].penable),
    .pwrite         (dtc_apb_if.mst_if[0].pwrite ),
    .pwdata         (dtc_apb_if.mst_if[0].pwdata ),
    .pready         (dtc_apb_if.mst_if[0].pready ),
    .prdata         (dtc_apb_if.mst_if[0].prdata ),
	.axi_aw_id      (dtc_axi_if.mst_if[0].awid ),  
	.axi_aw_addr    (dtc_axi_if.mst_if[0].awaddr), 
	.axi_aw_len     (dtc_axi_if.mst_if[0].awlen),  
	.axi_aw_size    (dtc_axi_if.mst_if[0].awsize), 
	.axi_aw_valid   (dtc_axi_if.mst_if[0].awvalid),
	.axi_aw_ready   (dtc_axi_if.mst_if[0].awready),
	.axi_w_data     (dtc_axi_if.mst_if[0].wdata),  
	.axi_w_strb     (dtc_axi_if.mst_if[0].wstrb),  
	.axi_w_last     (dtc_axi_if.mst_if[0].wlast),  
	.axi_w_valid    (dtc_axi_if.mst_if[0].wvalid), 
	.axi_w_ready    (dtc_axi_if.mst_if[0].wready), 
	.axi_b_id       (dtc_axi_if.mst_if[0].bid),    
	.axi_b_valid    (dtc_axi_if.mst_if[0].bvalid), 
	.axi_b_ready    (dtc_axi_if.mst_if[0].bready), 
	.axi_ar_id      (dtc_axi_if.mst_if[0].arid),   
	.axi_ar_addr    (dtc_axi_if.mst_if[0].araddr), 
	.axi_ar_len     (dtc_axi_if.mst_if[0].arlen),  
	.axi_ar_size    (dtc_axi_if.mst_if[0].arsize), 
	.axi_ar_valid   (dtc_axi_if.mst_if[0].arvalid),
	.axi_ar_ready   (dtc_axi_if.mst_if[0].arready),
	.axi_r_id       (dtc_axi_if.mst_if[0].rid),    
	.axi_r_data     (dtc_axi_if.mst_if[0].rdata),  
	.axi_r_last     (dtc_axi_if.mst_if[0].rlast),  
	.axi_r_valid    (dtc_axi_if.mst_if[0].rvalid), 
	.axi_r_ready    (dtc_axi_if.mst_if[0].rready) 
    );
endmodule
`endif//TB_DTC__SV
