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
//     File for axiw2ram.v                                                       
//----------------------------------------------------------------------------------
`ifndef AXIW2RAM__V
`define AXIW2RAM__V
module axiw2ram#(
    parameter AXI_AWIDTH = 32,
    parameter AXI_DWIDTH = 32,
    parameter AXI_IDWIDTH = 3,
    parameter AXI_LWIDTH = 8,
    parameter AXI_SIZE = 3,
    parameter AXI_STRB = 4,
    parameter LOC_AWIDTH = 32,
    parameter LOC_DWIDTH = 32
)(
    //AXI write channel and write response channle signal
	input                       clk,
	input                       rst_n,
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
    //Local signal
    output                      ram_data_out_en,
    output [LOC_AWIDTH-1:0]     ram_data_out_addr,
    output [LOC_DWIDTH-1:0]     ram_data_out

);
	wire aw_sync,aw_full,aw_empty,w_empty;
	wire ar_sync,ar_full,ar_empty,r_empty;
	wire w_sync,w_full;
	wire b_sync,b_empty;
	reg  [AXI_LWIDTH-1+1:0]  w_counter;
	wire [AXI_LWIDTH-1+1:0]  len_counter_max;
	wire [AXI_LWIDTH-1+1:0]	w_pointer;

	wire [AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:0] aw_din;
	wire [AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:0] aw_dout;

	wire [AXI_DWIDTH+AXI_STRB-1:0] w_din;
	wire [AXI_DWIDTH+AXI_STRB-1:0] w_dout;
    reg         rd_wdata_fifo_start;
	wire aw_rden;
	wire [AXI_IDWIDTH-1:0]  id_mark;
	wire [AXI_AWIDTH-1:0] addr_mark;
	wire w_rden;
	reg rd_wdata_fifo_state;
    reg         aw_read;
    reg         aw_read_dly;
	wire [AXI_LWIDTH-1:0]  len_mark;
    reg        data_trans_finish;
	wire [AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:0] b_din;
	wire [AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:0] b_dout ;
    reg             b_valid;

	assign axi_w_ready  = !w_full;
	assign axi_b_valid  = b_valid;

	/*axi addr write fifo opreat*/ 
	assign axi_aw_ready = !aw_full;
	assign aw_sync = axi_aw_valid && axi_aw_ready;
	assign aw_din = {axi_aw_id,axi_aw_addr,axi_aw_len};
	assign aw_wren = aw_sync; 
	assign {id_mark,addr_mark,len_mark} = aw_dout;
    assign aw_rden = aw_read && ! aw_read_dly;

    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            aw_read<=0;
            aw_read_dly<=0;
        end
    	else if(data_trans_finish)
        begin
            aw_read <=0;
            aw_read_dly <=0;
    	end
        else if(!aw_empty)
        begin
           aw_read <= 1; 
           aw_read_dly <= aw_read; 
        end
        else
        begin
           aw_read <= aw_read; 
           aw_read_dly <=aw_read_dly; 
        end
    end

 
	/*axi data write fifo opreat*/
	assign w_din = {axi_w_data,axi_w_strb};
	assign w_sync  = axi_w_valid  && axi_w_ready;  
	assign w_wren = w_sync;
	assign w_rden = rd_wdata_fifo_state && (w_counter!=1'b0); 
	assign len_counter_max = len_mark + 1'b1 ;

	always@(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
    	    rd_wdata_fifo_start <= 1'b0; 
    	else begin
    		if(!w_empty && (w_pointer >= len_counter_max) && !rd_wdata_fifo_state && aw_read_dly )
    			rd_wdata_fifo_start <= 1'b1;
    		else
    			rd_wdata_fifo_start <= 1'b0;
    	end
    end
	always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        	rd_wdata_fifo_state <= 1'b0;
        else begin
        	if(w_counter == len_counter_max)
        		rd_wdata_fifo_state <= 1'b0;
        	else if(rd_wdata_fifo_start)
        		rd_wdata_fifo_state <= 1'b1;
        	else
        		rd_wdata_fifo_state <= rd_wdata_fifo_state;
        end
    end
    always@(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
    		w_counter <= 'b0;
    	else begin
    		if(w_counter == len_counter_max)
            begin
    			w_counter <= 'b0;
            end
    		else if(rd_wdata_fifo_state)
    			w_counter <= w_counter + 1'b1;
    		else
    			w_counter <= w_counter;
    	end
    end
    reg w_rden_dly;
	reg  [AXI_LWIDTH-1+1:0]   w_counter_dly;

    always@(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            w_rden_dly <= 0 ;
            w_counter_dly <=0;
        end
    	else 
        begin
            w_rden_dly <= w_rden;
            w_counter_dly <= w_counter;
    	end
    end

	/*axi brespense fifo opreat*/
	assign b_din =  {axi_aw_id,axi_aw_addr,axi_aw_len};
	assign b_wren = aw_sync;
	assign b_rden = data_trans_finish;
	assign axi_b_id   = b_dout[AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH-1:AXI_LWIDTH+AXI_AWIDTH];

    always @(*)
    begin
    	if(!rst_n)
        begin
            data_trans_finish<=0;
        end
        else if(w_counter == len_counter_max)
        begin
            data_trans_finish <=1;
        end
        else
        begin
            data_trans_finish <=0;
        end
    end

    always @(posedge clk or negedge rst_n)
    begin
    	if(!rst_n)
        begin
            b_valid <=0;
        end
    	else if(data_trans_finish)
        begin
            b_valid <=1;
    	end
        else if(axi_b_ready)
        begin
            b_valid <=0;
        end
        else
        begin
            b_valid <= b_valid;
        end
    end
    //Local signal
    assign ram_data_out_en= w_rden_dly;
    //assign ram_data_out= w_dout[AXI_AWIDTH+AXI_LWIDTH-1:AXI_LWIDTH];
    assign ram_data_out= w_dout[AXI_DWIDTH+AXI_STRB-1:AXI_STRB];
    assign ram_data_out_addr= addr_mark[AXI_AWIDTH-1:2] + (w_counter_dly - 1'b1);

	sync_fifo #(.WIDTH(AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH)) awfifo(
		.rst_n(rst_n),
		.clk(clk),
		.wr_en(aw_wren),
		.din(aw_din),
		.rd_en(aw_rden),
        .dout(aw_dout),	
		.empty(aw_empty),
		.full(aw_full),
		.fifo_cnt()
	);
 
	sync_fifo #(.WIDTH(AXI_DWIDTH+AXI_STRB)) wfifo(
		.rst_n(rst_n),
		.clk(clk),
		.wr_en(w_wren),
		.din(w_din),
		.rd_en(w_rden),
        .dout(w_dout),	
		.empty(w_empty),
		.full(w_full),
		.fifo_cnt(w_pointer)
	);

	sync_fifo #(.WIDTH(AXI_IDWIDTH+AXI_AWIDTH+AXI_LWIDTH)) bfifo(
		.rst_n(rst_n),
		.clk(clk),
		.wr_en(b_wren),
		.din(b_din),
		.rd_en(b_rden),
        .dout(b_dout),	
		.empty(b_empty),
		.full(),
		.fifo_cnt()
	);

endmodule
`endif //AXIW2RAM__V
