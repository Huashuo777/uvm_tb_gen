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
//     File for tb_dadd.sv                                                       
//----------------------------------------------------------------------------------
`ifndef TB_DADD__SV
`define TB_DADD__SV
module tb_dadd;
    import uvm_pkg::*;

    real  clk_period = 10;
    logic clk;
    logic reset_n;

    apb_env_interface dadd_apb_if();
    dadd_loc_interface dadd_loc_if(clk,reset_n);

    initial
        run_test();

    initial
    begin
        uvm_config_db#(virtual dadd_loc_interface)::set(uvm_root::get(),"uvm_test_top","dadd_loc_vif", dadd_loc_if);
        uvm_config_db#(virtual apb_env_interface)::set(uvm_root::get(), "uvm_test_top","dadd_apb_vif", dadd_apb_if);
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

    assign dadd_apb_if.mst_if[0].pclk = clk;
    assign dadd_apb_if.mst_if[0].preset_n = reset_n;
    assign dadd_apb_if.mst_if[0].pslverr = 0;
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

    initial
        $timeformat(-9, 2,"ns", 10);

    dadd dadd_inst
    (
        .clk       (clk),
        .rst_n     (reset_n),
        .dadd_in_en    (dadd_loc_if.dadd_in_en ),
        .dadd_in_addr  (dadd_loc_if.dadd_in_addr),
        .dadd_in       (dadd_loc_if.dadd_in),
        .dadd_out      (dadd_loc_if.dadd_out   ),
        .dadd_out_addr (dadd_loc_if.dadd_out_addr),
        .dadd_out_en   (dadd_loc_if.dadd_out_en),
        .psel          (dadd_apb_if.mst_if[0].psel   ),
        .paddr         (dadd_apb_if.mst_if[0].paddr  ),
        .penable       (dadd_apb_if.mst_if[0].penable),
        .pwrite        (dadd_apb_if.mst_if[0].pwrite ),
        .pwdata        (dadd_apb_if.mst_if[0].pwdata ),
        .pready        (dadd_apb_if.mst_if[0].pready ),
        .prdata        (dadd_apb_if.mst_if[0].prdata ) 
    );
endmodule: tb_dadd
`endif // TB_DADD__SV
