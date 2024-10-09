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
    import bvm_pkg::*;
    import dadd_pkg::*;

    real  dadd_loc_clk_period = 10;
    logic dadd_loc_clk;
    logic dadd_loc_reset_n;
    logic addc;

    dadd_loc_interface dadd_loc_if(dadd_loc_clk,dadd_loc_reset_n);

    initial
        $timeformat(-9, 2,"ns", 10);
    initial
        run_test();
    initial
    begin
        bvm_config_db#(virtual dadd_loc_interface)::set("vif", dadd_loc_if);
    end

    initial
    begin
        dadd_loc_clk = 1'b0;
        wait(dadd_loc_clk_period > 0);
        forever
            dadd_loc_clk = #(dadd_loc_clk_period/2.0) ~ dadd_loc_clk;
    end

    initial
    begin
        dadd_loc_reset_n = 0;
        #200ns;
        dadd_loc_reset_n = 1;
    end

    initial begin
        $vcdplusautoflushon;
        $vcdpluson();
    end

    dadd dadd_inst
    (
        .clk       (dadd_loc_if.clk),
        .rst_n     (dadd_loc_if.reset_n),
        .dadd_in_en    (dadd_loc_if.dadd_in_en ),
        .dadd_in_addr  (dadd_loc_if.dadd_in_addr),
        .dadd_in       (dadd_loc_if.dadd_in),
        .dadd_out      (dadd_loc_if.dadd_out   ),
        .dadd_out_addr (dadd_loc_if.dadd_out_addr),
        .dadd_out_en   (dadd_loc_if.dadd_out_en)
    );
endmodule: tb_dadd
`endif // TB_DADD__SV
