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
//     File for axir2ram.v                                                       
//----------------------------------------------------------------------------------
`ifndef AXIR2RAM__V
`define AXIR2RAM__V
module axir2ram#(
    parameter AXI_AWIDTH = 32,
    parameter AXI_DWIDTH = 32,
    parameter AXI_IDWIDTH = 3,
    parameter AXI_LWIDTH = 8,
    parameter AXI_SIZE = 3,
    parameter AXI_STRB = 4,
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32
)(
    input                   clk,
    input                   rst_n,
	//AXI read channel
	input [AXI_IDWIDTH-1:0] axi_ar_id,
	input [AXI_AWIDTH-1:0]  axi_ar_addr,
	input [AXI_LWIDTH-1:0]  axi_ar_len,
	input [AXI_SIZE-1:0]    axi_ar_size,
	input                   axi_ar_valid,
	output                  axi_ar_ready,
	output [AXI_IDWIDTH-1:0]axi_r_id,
	output [AXI_DWIDTH-1:0] axi_r_data,
	output                  axi_r_last,
	output                  axi_r_valid,
	input                   axi_r_ready,
    //Local signal
    output                  ram_data_out_en,
    output [LOC_AWIDTH-1:0] ram_data_out_addr,
    input  [LOC_DWIDTH-1:0] ram_data_in
);

    reg r_ram_read_data_en;
    wire ar_full;
    reg [AXI_LWIDTH-1:0] r_ram_data_cnt;
	wire [AXI_LWIDTH-1+1:0]  len_counter_max;
    wire [AXI_IDWIDTH-1:0] id_mark_r;
    wire [AXI_AWIDTH-1:0] addr_mark_r;
    wire [AXI_LWIDTH-1:0] len_mark_r;
    //wire [AXI_LWIDTH-1:0] axi_ar_len;
    wire [AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:0] ar_dout;
    wire [AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:0] ar_din;
    reg  ram_data_valid;
    wire ar_sync;
    wire ar_wren;
    wire ar_rden;
    reg ar_read_dly,ar_read;
    reg r_last;
    wire trans_finish;
    wire ar_empty;
    wire r_empty;
    wire [AXI_IDWIDTH+LOC_DWIDTH-1:0] r_dout;
    wire [AXI_IDWIDTH+LOC_DWIDTH-1:0] r_din;
    wire r_rden;
    reg  r_valid;
    reg  r_empty_dly;


    /*ramal write fifo opreat*/
    assign ram_data_out_en =r_ram_read_data_en;
    assign ram_data_out_addr = addr_mark_r[AXI_AWIDTH-1:2]+r_ram_data_cnt;
	/*axi addr read fifo opreat*/ 
	assign axi_ar_ready = !ar_full;
	assign {id_mark_r,addr_mark_r,len_mark_r} = ar_dout;
	assign ar_din = {axi_ar_id,axi_ar_addr,axi_ar_len};
	assign ar_sync = axi_ar_valid && axi_ar_ready;
	assign ar_wren = ar_sync;
    assign ar_rden = ar_read && ! ar_read_dly;

    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            ar_read<=0;
            ar_read_dly<=0;
        end
    	else if(trans_finish)
        begin
            ar_read <=0;
            ar_read_dly <=0;
    	end
        else if(!ar_empty)
        begin
           ar_read <= 1; 
           ar_read_dly <= ar_read; 
        end
        else
        begin
           ar_read <= ar_read; 
           ar_read_dly <=ar_read_dly; 
        end
    end
    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
           r_ram_read_data_en <= 0; 
        end
        else if((r_ram_data_cnt == len_counter_max-1) && r_ram_read_data_en)
        begin
            r_ram_read_data_en <= 0;
        end
        else if(ar_rden)
        begin
            r_ram_read_data_en <= 1;
        end
    end

    always@(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
    		r_ram_data_cnt <= 'b0;
    	else begin
    		if(r_ram_data_cnt == len_counter_max-1)
            begin
    			r_ram_data_cnt <= 'b0;
            end
    		else if(r_ram_read_data_en)
    			r_ram_data_cnt <= r_ram_data_cnt + 1'b1;
    		else
    			r_ram_data_cnt <= r_ram_data_cnt;
    	end
    end

	/*axi data read fifo opreat*/
    assign axi_r_id = r_dout[AXI_DWIDTH+AXI_IDWIDTH-1:AXI_AWIDTH];
    //assign r_last = r_empty && !r_empty_dly;
    //assign r_last = r_empty && r_valid && axi_r_ready;
    assign r_last = r_empty && r_valid;
    assign axi_r_valid= r_valid;
    assign axi_r_data =r_dout[AXI_DWIDTH-1:0];
    assign r_rden = axi_r_ready && !r_empty;
    assign axi_r_last =r_last;
    assign trans_finish = axi_r_last;
	assign len_counter_max = len_mark_r + 1'b1 ;
    assign r_din = {id_mark_r,ram_data_in};

    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            r_valid<=0;
        end
        else if(r_rden)
        begin
            r_valid <=1;
        end
        else if(axi_r_ready)
        begin
            r_valid <=0;
        end
        else 
        begin
            r_valid <=r_valid;
        end
    end

    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            r_empty_dly<=0;
        end
        else 
        begin
            r_empty_dly <= r_empty;
        end
    end

    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            ram_data_valid<=0;
        end
        else if(r_ram_read_data_en)
        begin
            ram_data_valid<= 1;
        end
        else
        begin
            ram_data_valid <= 0;
        end
    end

	sync_fifo #(.WIDTH(AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH))  arfifo(
		.rst_n(rst_n),
		.clk(clk),
		.wr_en(ar_wren),
		.din(ar_din),
		.rd_en(ar_rden),
        .dout(ar_dout),	
		.empty(ar_empty),
		.full(ar_full),
		.fifo_cnt()
	);

	sync_fifo #(.WIDTH(AXI_IDWIDTH+LOC_DWIDTH))   rfifo(
		.rst_n(rst_n),
		.clk(clk),
		.wr_en(ram_data_valid),
		.din(r_din),
		.rd_en(r_rden),
        .dout(r_dout),	
		.empty(r_empty),
		.full(),
		.fifo_cnt()
	);

endmodule
`endif //AXIR2RAM__V
