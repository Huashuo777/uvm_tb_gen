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
//     File for dtc.v                                                       
//----------------------------------------------------------------------------------
`ifndef DTC__V
`define DTC__V
module dtc
    #(
    parameter APB_AWIDTH = 32,
    parameter APB_DWIDTH = 32,
    parameter AXI_AWIDTH = 32,
    parameter AXI_DWIDTH = 32,
    parameter AXI_IDWIDTH = 3,
    parameter AXI_LWIDTH = 8,
    parameter AXI_SIZE = 3,
    parameter AXI_STRB = 4,
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32
    )
    (
    input                       sys_clk     ,
    input                       sys_rst_n   ,
    input                       dadd_in_en  ,
    input      [LOC_DWIDTH-1:0] dadd_in     ,
    input      [LOC_AWIDTH-1:0] dadd_in_addr,
    //Dadd apb interface
    input                       psel        ,
    input [APB_AWIDTH-1:0]      paddr       ,
    input                       penable     ,
    input                       pwrite      ,
    input [APB_DWIDTH-1:0]      pwdata      ,
    output                      pready      ,
    output [APB_DWIDTH-1:0]     prdata      ,
    //AXI interface
	input [AXI_IDWIDTH-1:0]     axi_aw_id,
	input [AXI_AWIDTH-1:0]      axi_aw_addr,
	input [AXI_LWIDTH-1:0]      axi_aw_len,
	input [AXI_SIZE-1:0]        axi_aw_size,
	input                       axi_aw_valid,
	output                      axi_aw_ready,
	input [AXI_DWIDTH-1:0]      axi_w_data,
	input [AXI_STRB-1:0]        axi_w_strb,
	input                       axi_w_last,
	input                       axi_w_valid,
	output                      axi_w_ready,
	output [AXI_IDWIDTH-1:0]    axi_b_id,
	output                      axi_b_valid,
	input                       axi_b_ready,
	input [AXI_IDWIDTH-1:0]     axi_ar_id,
	input [AXI_AWIDTH-1:0]      axi_ar_addr,
	input [AXI_LWIDTH-1:0]      axi_ar_len,
	input [AXI_SIZE-1:0]        axi_ar_size,
	input                       axi_ar_valid,
	output                      axi_ar_ready,
	output [AXI_IDWIDTH-1:0]    axi_r_id,
	output [AXI_DWIDTH-1:0]     axi_r_data,
	output                      axi_r_last,
	output                      axi_r_valid,
	input                       axi_r_ready
    );
    wire                       dadd_psel        ;
    wire [APB_AWIDTH-1:0]      dadd_paddr       ;
    wire                       dadd_penable     ;
    wire                       dadd_pwrite      ;
    wire [APB_DWIDTH-1:0]      dadd_pwdata      ;
    wire                       dadd_pready      ;
    wire  [APB_DWIDTH-1:0] dadd_prdata          ;
    wire                       dsel_psel        ;
    wire [APB_AWIDTH-1:0]      dsel_paddr       ;
    wire                       dsel_penable     ;
    wire                       dsel_pwrite      ;
    wire [APB_DWIDTH-1:0]      dsel_pwdata      ;
    wire                       dsel_pready      ;
    wire  [APB_DWIDTH-1:0] dsel_prdata          ;

    wire [LOC_AWIDTH-1 : 0] loc_data_in_addr_b;
    wire [LOC_DWIDTH-1 : 0] loc_data_in_b;
    wire                    loc_data_in_en_b;

dtc_reg_config _dtc_reg_config_inst (
    .psel        (psel   ),
    .paddr       (paddr  ),
    .penable     (penable),
    .pwrite      (pwrite ),
    .pwdata      (pwdata ),
    .pready      (pready ),
    .prdata      (prdata ),     
    .dadd_psel   (dadd_psel   ),
    .dadd_paddr  (dadd_paddr  ),
    .dadd_penable(dadd_penable),
    .dadd_pwrite (dadd_pwrite ),
    .dadd_pwdata (dadd_pwdata ),
    .dadd_pready (dadd_pready ),
    .dadd_prdata (dadd_prdata ),     
    .dsel_psel   (dsel_psel   ),
    .dsel_paddr  (dsel_paddr  ),
    .dsel_penable(dsel_penable),
    .dsel_pwrite (dsel_pwrite ),
    .dsel_pwdata (dsel_pwdata ),
    .dsel_pready (dsel_pready ),
    .dsel_prdata (dsel_prdata )
    );
    dsel dsel_inst
    (
	.clk            (sys_clk           ),
	.rst_n          (sys_rst_n         ),
    .psel               (dsel_psel         ),
    .paddr              (dsel_paddr        ),
    .penable            (dsel_penable      ),
    .pwrite             (dsel_pwrite       ),
    .pwdata             (dsel_pwdata       ),
    .pready             (dsel_pready       ),
    .prdata             (dsel_prdata       ),
	.axi_aw_id          (axi_aw_id         ),
	.axi_aw_addr        (axi_aw_addr       ),
	.axi_aw_len         (axi_aw_len        ),
	.axi_aw_size        (axi_aw_size       ),
	.axi_aw_valid       (axi_aw_valid      ),
	.axi_aw_ready       (axi_aw_ready      ),
	.axi_w_data         (axi_w_data        ),
	.axi_w_strb         (axi_w_strb        ),
	.axi_w_last         (axi_w_last        ),
	.axi_w_valid        (axi_w_valid       ),
	.axi_w_ready        (axi_w_ready       ),
	.axi_b_id           (axi_b_id          ),
	.axi_b_valid        (axi_b_valid       ),
	.axi_b_ready        (axi_b_ready       ),
	.axi_ar_id          (axi_ar_id         ),
	.axi_ar_addr        (axi_ar_addr       ),
	.axi_ar_len         (axi_ar_len        ),
	.axi_ar_size        (axi_ar_size       ),
	.axi_ar_valid       (axi_ar_valid      ),
	.axi_ar_ready       (axi_ar_ready      ),
	.axi_r_id           (axi_r_id          ),
	.axi_r_data         (axi_r_data        ),
	.axi_r_last         (axi_r_last        ),
	.axi_r_valid        (axi_r_valid       ),
	.axi_r_ready        (axi_r_ready       ),
    .loc_data_in_en_b   (loc_data_in_en_b  ),
    .loc_data_in_addr_b (loc_data_in_addr_b),
    .loc_data_in_b      (loc_data_in_b     )
    );

    dadd dadd_inst
    (
    .clk         (sys_clk           ),
    .rst_n       (sys_rst_n         ),
    .dadd_in_en      (dadd_in_en        ),
    .dadd_in         (dadd_in           ),
    .dadd_in_addr    (dadd_in_addr      ),
    .dadd_out        (loc_data_in_b     ),   
    .dadd_out_addr   (loc_data_in_addr_b),
    .dadd_out_en     (loc_data_in_en_b  ), 
    .psel            (dadd_psel         ),
    .paddr           (dadd_paddr        ),
    .penable         (dadd_penable      ),
    .pwrite          (dadd_pwrite       ),
    .pwdata          (dadd_pwdata       ),
    .pready          (dadd_pready       ),
    .prdata          (dadd_prdata       )
    );
endmodule
`endif //DTC__V
