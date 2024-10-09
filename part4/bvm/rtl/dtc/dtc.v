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
(
    input           clk,
    input           rst_n,
    input           dtc_sel,
    input           dtc_in_en_a,
    input   [31:0]  dtc_in_addr_a,
    input   [31:0]  dtc_in_a,
    input           dtc_in_en_b,
    input   [31:0]  dtc_in_addr_b,
    input   [31:0]  dtc_in_b,
    output          dtc_out_en,    
    output  [31:0]  dtc_out, 
    output  [31:0]  dtc_out_addr 
);                                          

wire [31:0] dadd_to_dsel;
wire [31:0] dadd_to_dsel_addr;
wire        dadd_to_dsel_en;

dadd dadd_inst(
    .clk    (clk        ),
    .rst_n  (rst_n      ),
    .dadd_in_en (dtc_in_en_b    ),
    .dadd_in    (dtc_in_b       ),
    .dadd_in_addr(dtc_in_addr_b ),
    .dadd_out   (dadd_to_dsel   ),
    .dadd_out_addr(dadd_to_dsel_addr),
    .dadd_out_en(dadd_to_dsel_en) 
);                                          

dsel dsel_inst(
    .clk        (clk        ),
    .rst_n      (rst_n      ),
    .dsel_sel       (dtc_sel        ),
    .dsel_in_en_a   (dtc_in_en_a    ),
    .dsel_in_addr_a (dtc_in_addr_a  ),
    .dsel_in_a      (dtc_in_a       ),
    .dsel_in_en_b   (dadd_to_dsel_en),
    .dsel_in_addr_b (dadd_to_dsel_addr),
    .dsel_in_b      (dadd_to_dsel   ),
    .dsel_out       (dtc_out        ),
    .dsel_out_en    (dtc_out_en     ), 
    .dsel_out_addr  (dtc_out_addr   )
);                                          
endmodule
`endif //DTC__V
