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
//     File for axi_master_interface.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_MASTER_INTERFACE__SV
`define AXI_MASTER_INTERFACE__SV
interface axi_master_interface();
    //System signals
    logic                           aclk;
    logic                           areset_n;
    //Write address channel signals
    logic [`AXI_ID_WIDTH-1:0]       awid;
    logic [`AXI_ADDR_WIDTH-1:0]     awaddr;
    logic [`AXI_REGION_WIDTH-1:0]   awregion;
    logic [`AXI_LEN_WIDTH-1:0]      awlen;
    logic [`AXI_SIZE_WIDTH-1:0]     awsize;
    logic [`AXI_BURST_WIDTH-1:0]    awburst;
    logic                           awlock;
    logic [`AXI_CACHE_WIDTH-1:0]    awcache;
    logic [`AXI_PROT_WIDTH-1:0]     awprot;
    logic [`AXI_QOS_WIDTH-1:0]      awqos;
    logic [`AXI_USER_WIDTH-1:0]     awuser;
    logic                           awvalid;
    logic                           awready;
    //Write data channel signals
    logic [`AXI_USER_WIDTH-1:0]     wuser;
    logic [`AXI_DATA_WIDTH-1:0]     wdata;
    logic [`AXI_DATA_WIDTH/8-1:0]   wstrb;
    logic                           wlast;
    logic                           wvalid;
    logic                           wready;
    //Write response channel signals
    logic [`AXI_USER_WIDTH-1:0]     buser;
    logic [`AXI_ID_WIDTH-1:0]       bid;
    logic [`AXI_RESP_WIDTH-1:0]     bresp;
    logic                           bvalid;
    logic                           bready;
    //Read address channel signals
    logic [`AXI_ID_WIDTH-1:0]       arid;
    logic [`AXI_ADDR_WIDTH-1:0]     araddr;
    logic [`AXI_REGION_WIDTH-1:0]   arregion;
    logic [`AXI_LEN_WIDTH-1:0]      arlen;
    logic [`AXI_SIZE_WIDTH-1:0]     arsize;
    logic [`AXI_BURST_WIDTH-1:0]    arburst;
    logic                           arlock;
    logic [`AXI_CACHE_WIDTH-1:0]    arcache;
    logic [`AXI_PROT_WIDTH-1:0]     arprot;
    logic [`AXI_QOS_WIDTH-1:0]      arqos;
    logic [`AXI_USER_WIDTH-1:0]     aruser;
    logic                           arvalid;
    logic                           arready;
    //Read data channel signals
    logic [`AXI_ID_WIDTH-1:0]       rid;
    logic [`AXI_DATA_WIDTH-1:0]     rdata;
    logic [`AXI_RESP_WIDTH-1:0]     rresp;
    logic                           rlast;
    logic                           rvalid;
    logic                           rready;
    logic [`AXI_USER_WIDTH-1:0]     ruser;

    // master mode
    clocking mcb @ (posedge aclk);
        //default input #`AXI_MASTER_INPUT_TIME output #`AXI_MASTER_OUTPUT_TIME;
        input  areset_n;
        output awid;
        output awaddr;
        output awregion;
        output awlen;
        output awsize;
        output awburst;
        output awlock;
        output awcache;
        output awprot;
        output awqos;
        output awvalid;
        input  awready;
        output wdata;
        output wstrb;
        output wlast;
        output wvalid;
        input  wready;
        input  bid;
        input  bresp;
        input  bvalid;
        output bready;
        output arid;
        output araddr;
        output arregion;
        output arlen;
        output arsize;
        output arburst;
        output arlock;
        output arcache;
        output arprot;
        output arqos;
        output arvalid;
        input  arready;
        input  rid;
        input  rdata;
        input  rresp;
        input  rlast;
        input  rvalid;
        output rready;
        output awuser;
        output wuser;
        output aruser;
        output ruser;
        output buser;
    endclocking: mcb


    // passive mode
    clocking pcb @ (posedge aclk);
        default input #`AXI_PASSIVE_INPUT_TIME output #`AXI_PASSIVE_INPUT_TIME;
        input areset_n;
        input awid;
        input awaddr;
        input awregion;
        input awlen;
        input awsize;
        input awburst;
        input awlock;
        input awcache;
        input awprot;
        input awqos;
        input awvalid;
        input awready;
        input wdata;
        input wstrb;
        input wlast;
        input wvalid;
        input wready;
        input bid;
        input bresp;
        input bvalid;
        input bready;
        input arid;
        input araddr;
        input arregion;
        input arlen;
        input arsize;
        input arburst;
        input arlock;
        input arcache;
        input arprot;
        input arqos;
        input arvalid;
        input arready;
        input rid;
        input rdata;
        input rresp;
        input rlast;
        input rvalid;
        input rready;
        input awuser;
        input wuser;
        input aruser;
        input ruser;
        input buser;
    endclocking: pcb

endinterface : axi_master_interface
`endif //AXI_MASTER_INTERFACE__SV
