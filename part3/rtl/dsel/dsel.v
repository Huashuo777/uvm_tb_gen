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
//     File for dsel.v                                                       
//----------------------------------------------------------------------------------
`ifndef DSEL__V
`define DSEL__V
module dsel
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
	input                       clk,
	input                       rst_n,
    //Apb interface
    input                       psel   ,
    input [APB_AWIDTH-1:0]      paddr  ,
    input                       penable,
    input                       pwrite ,
    input [APB_DWIDTH-1:0]      pwdata ,
    output                      pready ,
    output reg [APB_DWIDTH-1:0] prdata ,
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
	input                       axi_r_ready,
    //Local interface
    input                       loc_data_in_en_b,
    input [LOC_AWIDTH-1:0]      loc_data_in_addr_b,
    input [LOC_DWIDTH-1:0]      loc_data_in_b
    );
    wire                        ram_data_in_en_a    ;
    wire [LOC_AWIDTH-1:0]       ram_data_in_addr_a  ;
    wire [LOC_DWIDTH-1:0]       ram_data_in_a       ;       
    wire                        ram_data_out_en     ;
    wire [LOC_AWIDTH-1:0]       ram_data_out_addr   ;
    wire [LOC_DWIDTH-1:0]       ram_data_in        ;
    wire [31:0]                 reg_value           ;

    wire                        loc2ram_en_b    ;
    wire [LOC_AWIDTH-1:0]       loc2ram_addr_b  ;
    wire [LOC_DWIDTH-1:0]       loc2ram_data_b       ;       

    dsel_data_handle dsel_data_handle_inst(
        .clk                (clk            ),
        .rst_n              (rst_n          ),
        .dsel_in_en_a       (ram_data_in_en_a   ),
        .dsel_in_addr_a     (ram_data_in_addr_a ),
        .dsel_in_a          (ram_data_in_a      ),
        .dsel_in_en_b       (loc2ram_en_b  ),
        .dsel_in_addr_b     (loc2ram_addr_b),
        .dsel_in_b          (loc2ram_data_b),
        .reg_value          (reg_value          ),
        .dsel_in_en         (ram_data_out_en    ),    
        .dsel_in_addr       (ram_data_out_addr  ),   
        .dsel_out           (ram_data_in       )    
    );                                          
    locw2ram locw2ram_inst(
        .loc_data_in_en     (loc_data_in_en_b),
        .loc_data_in_addr   (loc_data_in_addr_b),
        .loc_data_in        (loc_data_in_b),
        .loc_data_out_en    (loc2ram_en_b  ),
        .loc_data_out_addr  (loc2ram_addr_b),
        .loc_data_out       (loc2ram_data_b)
    );
    axir2ram axir2ram_inst(
        .clk                (clk       ),
        .rst_n              (rst_n     ),
    	.axi_ar_id          (axi_ar_id     ),
    	.axi_ar_addr        (axi_ar_addr   ),
    	.axi_ar_len         (axi_ar_len    ),
    	.axi_ar_size        (axi_ar_size   ),
    	.axi_ar_valid       (axi_ar_valid  ),
    	.axi_ar_ready       (axi_ar_ready  ),
    	.axi_r_id           (axi_r_id      ),
    	.axi_r_data         (axi_r_data    ),
    	.axi_r_last         (axi_r_last    ),
    	.axi_r_valid        (axi_r_valid   ),
    	.axi_r_ready        (axi_r_ready   ),
        .ram_data_out_en    (ram_data_out_en),
        .ram_data_out_addr  (ram_data_out_addr),
        .ram_data_in        (ram_data_in)
    );
    axiw2ram axiw2ram_inst(
    	.clk                (clk     ),
    	.rst_n              (rst_n   ),
    	.axi_aw_id          (axi_aw_id   ),
    	.axi_aw_addr        (axi_aw_addr ),
    	.axi_aw_len         (axi_aw_len  ),
    	.axi_aw_size        (axi_aw_size ),
    	.axi_aw_valid       (axi_aw_valid),
    	.axi_aw_ready       (axi_aw_ready),
    	.axi_w_data         (axi_w_data  ),
    	.axi_w_strb         (axi_w_strb  ),
    	.axi_w_last         (axi_w_last  ),
    	.axi_w_valid        (axi_w_valid ),
    	.axi_w_ready        (axi_w_ready ),
    	.axi_b_id           (axi_b_id    ),
    	.axi_b_valid        (axi_b_valid ),
    	.axi_b_ready        (axi_b_ready ),
        .ram_data_out_en    (ram_data_in_en_a   ),
        .ram_data_out_addr  (ram_data_in_addr_a ),
        .ram_data_out       (ram_data_in_a     )
    );

    dsel_regfile dsel_regfile_inst(
        .pclk                   (clk    ),
        .rst_n                  (rst_n  ),
        .psel                   (psel       ),
        .paddr                  (paddr      ),
        .penable                (penable    ),
        .pwrite                 (pwrite     ),
        .pwdata                 (pwdata     ),
        .pready                 (pready     ),
        .prdata                 (prdata     ),
        .reg_value              (reg_value  )
    );
endmodule
`endif //DSEL__V
