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
//     File for tb_dsel.v                                                       
//----------------------------------------------------------------------------------
`ifndef TB_TEST__V
`define TB_TEST__V
module tb_test();
    logic clk;
    logic rst_n;
    logic                       psel    ;   
    logic [31:0]                paddr   ;   
    logic                       penable ;   
    logic                       pwrite  ;   
    logic [31:0]                pwdata  ;   
    logic                       pready  ;   
    logic [31:0]                prdata  ;   
    

	logic [7:0]                 axi_aw_id;
	logic [32-1:0]              axi_aw_addr;
	logic [7:0]                 axi_aw_len;
	logic [2:0]                 axi_aw_size;
	logic                       axi_aw_valid;
	logic                       axi_aw_ready;
	logic [32-1:0]              axi_w_data;
	logic [3:0]                 axi_w_strb;
	logic                       axi_w_last;
	logic                       axi_w_valid;
	logic                       axi_w_ready;
	logic  [3-1:0]              axi_b_id;
	logic                       axi_b_valid;
	logic                       axi_b_ready;
    logic                       loc_data_out_en;
    logic  [32-1:0]             loc_data_out_addr;
    logic  [32-1:0]             loc_data_out;

	logic [7:0]             axi_ar_id;
	logic [31:0]    axi_ar_addr;
	logic [3:0]             axi_ar_len;
	logic [2:0]             axi_ar_size;
	logic                   axi_ar_valid;
	logic                   axi_ar_ready;
	logic   [7:0]           axi_r_id;
	logic   [31:0]  axi_r_data;
	logic                   axi_r_last;
	logic                   axi_r_valid;
	logic                   axi_r_ready;
    logic                   loc_data_in_en;
    logic  [31:0]     loc_data_in_addr;
    logic  [31:0]     loc_data_in;
    logic        loc_data_in_en_b  ;
    logic [31:0] loc_data_in_addr_b;
    logic [31:0] loc_data_in_b     ;
    initial begin
        psel        =0; 
        paddr       =0; 
        penable     =0; 
        pwrite      =0; 
        pwdata      =0; 
        //apb write
        wait(rst_n == 1);
        @(posedge clk);
        #0ns;
        psel        =1; 
        paddr       =0; 
        penable     =0; 
        pwrite      =1; 
        pwdata      =2'b10; 
        @(posedge clk);
        #0ns;
        psel        =1; 
        paddr       =0; 
        penable     =1; 
        pwrite      =1; 
        pwdata      =2'b10; 
        @(posedge clk);
        #0ns;
        psel        =0; 
        paddr       =0; 
        penable     =0; 
        pwrite      =0; 
        pwdata      =0; 
        //apb_read
        @(posedge clk);
        #0ns;
        psel        =1; 
        paddr       =0; 
        penable     =0; 
        pwrite      =0; 
        pwdata      =0; 
        @(posedge clk);
        #0ns;
        psel        =1; 
        paddr       =0; 
        penable     =1; 
        pwrite      =0; 
        pwdata      =0; 
        @(posedge clk);
        #0ns;
        psel        =0; 
        paddr       =0; 
        penable     =0; 
        pwrite      =0; 
        pwdata      =0; 

        repeat(10)@(posedge clk);
        #0ns;

	    axi_aw_valid = 0;
	    axi_w_valid  = 0;
	    axi_aw_id    = 0;
	    axi_aw_addr  = 0;
	    axi_aw_len   = 0;
	    axi_aw_size  = 0;
	    axi_w_data   = 0;
	    axi_w_strb   = 0;
	    axi_w_last   = 0;
	    axi_b_ready  = 0;
        loc_data_in_en_b   = 0;
        loc_data_in_addr_b = 0;
        loc_data_in_b      = 0; 

        wait(rst_n == 1);
        // first transfer
        //axi_waddr
        @(posedge clk);
        #0ns;
	    axi_aw_valid = 1;
	    axi_aw_id    = 1;
	    axi_aw_addr  = 0;
	    axi_aw_len   = 1;
	    axi_aw_size  = 1;
        loc_data_in_en_b   = 1;
        loc_data_in_addr_b = 0;
        loc_data_in_b      = 32'h2323; 
        @(posedge clk);
        #0ns;
	    axi_aw_valid = 0;
	    axi_aw_id    = 0;
	    axi_aw_addr  = 0;
	    axi_aw_len   = 0;
	    axi_aw_size  = 0;
        loc_data_in_en_b   = 0;
        loc_data_in_addr_b = 0;
        loc_data_in_b      = 0; 
        //axi_wdata
        @(posedge clk);
        #0ns;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 1;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 0;
        loc_data_in_en_b   = 1;
        loc_data_in_addr_b = 32'h4;
        loc_data_in_b      = 32'h2623; 
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 0;
	    axi_w_data   = 0;
	    axi_w_strb   = 0;
	    axi_w_last   = 0;
        loc_data_in_en_b   = 0;
        loc_data_in_addr_b = 0;
        loc_data_in_b      = 0; 
        repeat(10) @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 2;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 1;
        loc_data_in_en_b   = 1;
        loc_data_in_addr_b = 32'h8;
        loc_data_in_b      = 32'h2e23; 
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 0;
	    axi_w_data   = 0;
	    axi_w_strb   = 0;
	    axi_w_last   = 0;
        loc_data_in_en_b   = 1;
        loc_data_in_addr_b = 32'hc;
        loc_data_in_b      = 32'h23b3; 
        //axi_wresponse
        @(posedge clk);
        #0ns;
        loc_data_in_en_b   = 1;
        loc_data_in_addr_b = 32'h10;
        loc_data_in_b      = 32'h23a3; 
	    axi_b_ready  = 1;

        // second transfer
        //axi_waddr
        @(posedge clk);
        #0ns;
	    axi_aw_valid = 1;
	    axi_aw_id    = 31;
	    axi_aw_addr  = 8;
	    axi_aw_len   = 5;
	    axi_aw_size  = 1;
        loc_data_in_en_b   = 0;
        loc_data_in_addr_b = 0;
        loc_data_in_b      = 0; 
        @(posedge clk);
        #0ns;
	    axi_aw_valid = 0;
	    axi_aw_id    = 0;
	    axi_aw_addr  = 0;
	    axi_aw_len   = 0;
	    axi_aw_size  = 0;
        //axi_wdata
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 3;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 0;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 4;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 0;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 5;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 0;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 6;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 0;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 7;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 0;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 0;
	    axi_w_data   = 0;
	    axi_w_strb   = 0;
	    axi_w_last   = 0;
        repeat(10) @(posedge clk);
        #0ns;
	    axi_w_valid  = 1;
	    axi_w_data   = 8;
	    axi_w_strb   = 'hf;
	    axi_w_last   = 1;
        @(posedge clk);
        #0ns;
	    axi_w_valid  = 0;
	    axi_w_data   = 0;
	    axi_w_strb   = 0;
	    axi_w_last   = 0;
        //axi_wresponse
        @(posedge clk);
        #0ns;
	    axi_b_ready  = 1;

        //****************axi read****************
	    axi_ar_id       = 0;
	    axi_ar_addr     = 0;
	    axi_ar_len      = 0;
	    axi_ar_size     = 0;
	    axi_ar_valid    = 0;
        loc_data_in     = 0;
        axi_r_ready     = 0;
        wait(rst_n == 1);
        // first transfer
        //axi_raddr
        @(posedge clk);
        #0ns;
	    axi_ar_id       = 1;
	    axi_ar_addr     = 0;
	    axi_ar_len      = 2;
	    axi_ar_size     = 3;
	    axi_ar_valid    = 1;
        axi_r_ready     = 1;
        @(posedge clk);
        #0ns;
	    axi_ar_id       = 1;
	    axi_ar_addr     = 4;
	    axi_ar_len      = 3;
	    axi_ar_size     = 4;
	    axi_ar_valid    = 1;
        axi_r_ready     = 0;
        repeat(2)@(posedge clk);
        #0ns;
	    axi_ar_id       = 0;
	    axi_ar_addr     = 0;
	    axi_ar_len      = 0;
	    axi_ar_size     = 0;
	    axi_ar_valid    = 0;
        loc_data_in     = 0;
        axi_r_ready     = 1;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 0;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 1;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 0;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 1;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 0;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 1;
        repeat(2)@(posedge clk);
        #0ns;
        axi_r_ready     = 1;

        @(posedge clk);
        #0ns;
	    axi_ar_id       = 0;
	    axi_ar_addr     = 0;
	    axi_ar_len      = 0;
	    axi_ar_size     = 0;
	    axi_ar_valid    = 0;
        loc_data_in     = 0;

    end


    initial
    begin
        clk = 0;
        rst_n = 0;
        #100ns;
        rst_n = 1;
        #4000ns;
        $finish();
    end
    initial
    begin
        $vcdpluson();
    end

    initial
    begin
        forever
        begin
            #10ns clk = ~clk;
        end
    end
dsel dsel_inst (
	.sys_clk              (clk           ),  
	.sys_rst_n            (rst_n         ),  
    .psel                 (psel              ),  
    .paddr                (paddr             ),  
    .penable              (penable           ),  
    .pwrite               (pwrite            ),  
    .pwdata               (pwdata            ),  
    .pready               (pready            ),  
    .prdata               (prdata            ),  
	.axi_aw_id            (axi_aw_id         ),  
	.axi_aw_addr          (axi_aw_addr       ),
	.axi_aw_len           (axi_aw_len        ),
	.axi_aw_size          (axi_aw_size       ),
	.axi_aw_valid         (axi_aw_valid      ),
	.axi_aw_ready         (axi_aw_ready      ),
	.axi_w_data           (axi_w_data        ),
	.axi_w_strb           (axi_w_strb        ),
	.axi_w_last           (axi_w_last        ),
	.axi_w_valid          (axi_w_valid       ),
	.axi_w_ready          (axi_w_ready       ),
	.axi_b_id             (axi_b_id          ),
	.axi_b_valid          (axi_b_valid       ),
	.axi_b_ready          (axi_b_ready       ),
	.axi_ar_id            (axi_ar_id         ),
	.axi_ar_addr          (axi_ar_addr       ),
	.axi_ar_len           (axi_ar_len        ),
	.axi_ar_size          (axi_ar_size       ),
	.axi_ar_valid         (axi_ar_valid      ),
	.axi_ar_ready         (axi_ar_ready      ),
	.axi_r_id             (axi_r_id          ),
	.axi_r_data           (axi_r_data        ),
	.axi_r_last           (axi_r_last        ),
	.axi_r_valid          (axi_r_valid       ),
	.axi_r_ready          (axi_r_ready       ),
    .loc_data_in_en_b     (loc_data_in_en_b  ),
    .loc_data_in_addr_b   (loc_data_in_addr_b),
    .loc_data_in_b        (loc_data_in_b     )      
);
endmodule
`endif //TB_TEST__V
