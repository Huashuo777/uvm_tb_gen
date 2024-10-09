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
    axi_master_interface m_if,
    axi_slave_interface  s_if
);
    assign s_if.awid        = m_if.awid    ;
    assign s_if.awaddr      = m_if.awaddr  ;
    assign s_if.awregion    = m_if.awregion;
    assign s_if.awlen       = m_if.awlen   ;
    assign s_if.awsize      = m_if.awsize  ;
    assign s_if.awburst     = m_if.awburst ;
    assign s_if.awlock      = m_if.awlock  ;
    assign s_if.awcache     = m_if.awcache ;
    assign s_if.awprot      = m_if.awprot  ;
    assign s_if.awqos       = m_if.awqos   ;
    assign s_if.awuser      = m_if.awuser  ;
    assign s_if.awvalid     = m_if.awvalid ;
    assign m_if.awready     = s_if.awready ;
    assign s_if.aruser      = m_if.aruser  ;
    assign s_if.wuser       = m_if.wuser   ;
    assign s_if.wdata       = m_if.wdata   ;
    assign s_if.wstrb       = m_if.wstrb   ;
    assign s_if.wlast       = m_if.wlast   ;
    assign s_if.wvalid      = m_if.wvalid  ;
    assign m_if.wready      = s_if.wready  ;
    assign m_if.bid         = s_if.bid     ;
    assign m_if.bresp       = s_if.bresp   ;
    assign m_if.bvalid      = s_if.bvalid  ;
    assign s_if.bready      = m_if.bready  ;
    assign s_if.buser       = m_if.buser   ;
    assign s_if.arid        = m_if.arid    ;
    assign s_if.araddr      = m_if.araddr  ;
    assign s_if.arregion    = m_if.arregion;
    assign s_if.arlen       = m_if.arlen   ;
    assign s_if.arsize      = m_if.arsize  ;
    assign s_if.arburst     = m_if.arburst ;
    assign s_if.arlock      = m_if.arlock  ;
    assign s_if.arcache     = m_if.arcache ;
    assign s_if.arprot      = m_if.arprot  ;
    assign s_if.arqos       = m_if.arqos   ;
    assign s_if.arvalid     = m_if.arvalid ;
    assign m_if.arready     = s_if.arready ;
    assign m_if.rid         = s_if.rid     ;
    assign m_if.rdata       = s_if.rdata   ;
    assign s_if.ruser       = m_if.ruser   ;
    assign m_if.rresp       = s_if.rresp   ;
    assign m_if.rlast       = s_if.rlast   ;
    assign m_if.rvalid      = s_if.rvalid  ;
    assign s_if.rready      = m_if.rready  ;
endmodule

module top;
    logic clk;
    logic rst_n;

    axi_env_interface axi_if();


    initial begin
        uvm_config_db#(virtual axi_env_interface)::set(null, "*", "vif", axi_if);

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

    assign axi_if.mst_if[0].aclk = clk;
    assign axi_if.slv_if[0].aclk = clk;
    assign axi_if.mst_if[0].areset_n = rst_n;
    assign axi_if.slv_if[0].areset_n = rst_n;


    dummy dmy_inst(axi_if.mst_if[0], axi_if.slv_if[0]);
endmodule
`endif //TESTBENCH__SV
