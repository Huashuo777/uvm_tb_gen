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
//     File for tb_dsel.sv                                                       
//----------------------------------------------------------------------------------
`ifndef TB_DSEL__SV
`define TB_DSEL__SV
module tb_dsel;
    import uvm_pkg::*;

    real  clk_period = 10;
    logic clk;
    logic reset_n;

    apb_env_interface dsel_apb_if();
    axi_env_interface dsel_axi_if();
    dsel_loc_interface dsel_loc_if(clk,reset_n);

    initial
        $timeformat(-9, 2,"ns", 10);

    initial
        run_test();

    initial
    begin
        uvm_config_db#(virtual dsel_loc_interface)::set(uvm_root::get(),"uvm_test_top","dsel_loc_vif", dsel_loc_if);
        uvm_config_db#(virtual apb_env_interface)::set(uvm_root::get(), "uvm_test_top", "dsel_apb_vif", dsel_apb_if);
        uvm_config_db#(virtual axi_env_interface)::set(uvm_root::get(), "uvm_test_top", "dsel_axi_vif", dsel_axi_if);
    end

    //clock generater
    initial
    begin
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
    assign dsel_apb_if.mst_if[0].pclk = clk;
    assign dsel_apb_if.mst_if[0].preset_n = reset_n;
    assign dsel_apb_if.mst_if[0].pslverr = 0;

    assign dsel_axi_if.mst_if[0].aclk = clk;
    assign dsel_axi_if.mst_if[0].areset_n = reset_n;


    initial
    begin
        reset_n = 0;
        #200ns;
        reset_n = 1;
    end

    initial begin
        $vcdplusautoflushon;
        $vcdpluson();
    end

    dsel dsel_inst(
	.clk             (clk),
	.rst_n           (reset_n),
    .psel                (dsel_apb_if.mst_if[0].psel   ),
    .paddr               (dsel_apb_if.mst_if[0].paddr  ),
    .penable             (dsel_apb_if.mst_if[0].penable),
    .pwrite              (dsel_apb_if.mst_if[0].pwrite ),
    .pwdata              (dsel_apb_if.mst_if[0].pwdata ),
    .pready              (dsel_apb_if.mst_if[0].pready ),
    .prdata              (dsel_apb_if.mst_if[0].prdata ),
	.axi_aw_id           (dsel_axi_if.mst_if[0].awid ),
	.axi_aw_addr         (dsel_axi_if.mst_if[0].awaddr),
	.axi_aw_len          (dsel_axi_if.mst_if[0].awlen),
	.axi_aw_size         (dsel_axi_if.mst_if[0].awsize),
	.axi_aw_valid        (dsel_axi_if.mst_if[0].awvalid),
	.axi_aw_ready        (dsel_axi_if.mst_if[0].awready),
	.axi_w_data          (dsel_axi_if.mst_if[0].wdata),
	.axi_w_strb          (dsel_axi_if.mst_if[0].wstrb),
	.axi_w_last          (dsel_axi_if.mst_if[0].wlast),
	.axi_w_valid         (dsel_axi_if.mst_if[0].wvalid),
	.axi_w_ready         (dsel_axi_if.mst_if[0].wready),
	.axi_b_id            (dsel_axi_if.mst_if[0].bid),
	.axi_b_valid         (dsel_axi_if.mst_if[0].bvalid),
	.axi_b_ready         (dsel_axi_if.mst_if[0].bready),
	.axi_ar_id           (dsel_axi_if.mst_if[0].arid),
	.axi_ar_addr         (dsel_axi_if.mst_if[0].araddr),
	.axi_ar_len          (dsel_axi_if.mst_if[0].arlen),
	.axi_ar_size         (dsel_axi_if.mst_if[0].arsize),
	.axi_ar_valid        (dsel_axi_if.mst_if[0].arvalid),
	.axi_ar_ready        (dsel_axi_if.mst_if[0].arready),
	.axi_r_id            (dsel_axi_if.mst_if[0].rid),
	.axi_r_data          (dsel_axi_if.mst_if[0].rdata),
	.axi_r_last          (dsel_axi_if.mst_if[0].rlast),
	.axi_r_valid         (dsel_axi_if.mst_if[0].rvalid),
	.axi_r_ready         (dsel_axi_if.mst_if[0].rready),
    .loc_data_in_en_b    (dsel_loc_if.dsel_in_en),
    .loc_data_in_addr_b  (dsel_loc_if.dsel_in_addr),
    .loc_data_in_b       (dsel_loc_if.dsel_in)
    );
endmodule: tb_dsel

`endif // TB_DSEL__SV
