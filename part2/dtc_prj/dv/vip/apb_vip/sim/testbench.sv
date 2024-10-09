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
//     File for testbench.sv                                                       
//----------------------------------------------------------------------------------
`ifndef TESTBENCH__SV
`define TESTBENCH__SV
module dummy(
    apb_master_interface m_if,
    apb_slave_interface  s_if
);
    assign s_if.paddr   = m_if.paddr;
    assign s_if.penable = m_if.penable;
    assign s_if.pwrite  = m_if.pwrite;
    assign s_if.pwdata  = m_if.pwdata;
    assign s_if.psel    = m_if.psel;

    assign m_if.prdata  = s_if.prdata;
    assign m_if.pready  = s_if.pready;
    assign m_if.pslverr = s_if.pslverr;
endmodule

module top;
    logic clk;
    logic rst_n;

    apb_env_interface apb_if();


    initial begin
        uvm_config_db#(virtual apb_env_interface)::set(null, "*", "vif", apb_if);

        run_test();
    end

    initial begin
        clk = 'b0;
        rst_n = 'b0;
        #12;
        rst_n = 'b1;
    end
    initial 
    begin
        $vcdplusautoflushon;
        $vcdpluson();
    end

    always #5 clk = ~clk;

    assign apb_if.mst_if[0].pclk = clk;
    assign apb_if.slv_if[0].pclk = clk;
    assign apb_if.mst_if[0].preset_n = rst_n;
    assign apb_if.slv_if[0].preset_n = rst_n;


    dummy dmy_inst(apb_if.mst_if[0], apb_if.slv_if[0]);
endmodule
`endif //TESTBENCH__SV
