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
//     File for axi_type.sv                                                       
//----------------------------------------------------------------------------------
`ifndef AXI_TYPE__SV
`define AXI_TYPE__SV
typedef bit [`AXI_ADDR_WIDTH-1:0]   axi_addr_t;
typedef bit [`AXI_DATA_WIDTH-1:0]   axi_data_t;
typedef bit [`AXI_STRB_WIDTH-1:0]   axi_strb_t;
typedef bit [`AXI_BURST_WIDTH-1:0]  axi_burst_t;
typedef bit [`AXI_LEN_WIDTH-1:0]    axi_len_t;
typedef bit [`AXI_SIZE_WIDTH-1:0]   axi_size_t;
typedef bit [`AXI_ID_WIDTH-1:0]     axi_id_t;
typedef bit [`AXI_BURST_WIDTH-1:0]  axi_resp_t;
typedef enum bit {
    False,
    True
} bool;
typedef enum bit {
    READ,
    WRITE
} axi_direction_e;

typedef enum bit [1:0] {
    FIXED, INCR, WRAP
} axi_burst_e;

typedef enum logic [1:0] {
    OKAY, EXOKAY, SLVERR, DECERR
} axi_response_e;

typedef enum logic [3:0] {
    BUFFERABLE     = 4'b0001,
    CACHEABLE      = 4'b0010,
    READ_ALLOCATE  = 4'b0100,
    WRITE_ALLOCATE = 4'b1000
} axi_cache_e;

typedef enum logic [2:0] {
    PRIVILEGED  = 3'b001,
    NON_SECURE  = 3'b010,
    INSTRUCTION = 3'b100
} axi_prot_e;

typedef enum logic [1:0] {
    NORMAL, EXCLUSIVE, LOCKED
} axi_lock_e;

typedef enum logic [1:0] {
    FIRST, NOFIRST, RANDOM
} axi_wdata_first_e;

typedef struct {
    axi_len_t burst_len_info;
    axi_id_t    id_info;
    axi_size_t  size_info;
    axi_addr_t  addr_info;
} waddr_info_s;

typedef struct {
    axi_strb_t strb_info;
    axi_data_t data_info;
    bit        is_last_info;
} wdata_info_s;

typedef struct {
    axi_resp_t bresp_info;
    axi_id_t   id_info;
} wresp_info_s;

typedef struct {
    axi_len_t   burst_len_info;
    axi_id_t    id_info;
    axi_size_t  size_info;
    axi_addr_t  addr_info;
} raddr_info_s;

typedef struct {
    axi_id_t    id_info;
    axi_data_t data_info;
    bit        is_last_info;
} rdata_info_s;

`endif //AXI_TYPE__SV
