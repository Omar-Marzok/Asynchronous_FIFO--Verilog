module FIFO_top #(parameter DATA_WIDTH = 8,MEM_DEPTH = 8) (
    input wire           		W_CLK,
    input wire           		W_RST,
    input wire           		W_INC,
    input wire           		R_CLK,
    input wire           		R_RST,
    input wire           		R_INC,
    input wire [DATA_WIDTH-1:0] WR_DATA,
    output wire [DATA_WIDTH-1:0] RD_DATA,
    output wire            		FULL,
    output wire            		EMPTY
);

wire [$clog2(MEM_DEPTH):0]  W_ptr,R_ptr,RQ2,WQ2;
wire [$clog2(MEM_DEPTH)-1:0]  W_addr,R_addr;

DF_SYNC #(.MEM_DEPTH(MEM_DEPTH)) sync_W2R (
.clk(R_CLK),
.RST(R_RST),
.InData(W_ptr),
.OutData(RQ2)
);


DF_SYNC #(.MEM_DEPTH(MEM_DEPTH)) sync_R2W (
.clk(W_CLK),
.RST(W_RST),
.InData(R_ptr),
.OutData(WQ2)
);

FIFO_MEM_CNTRL #(.MEM_DEPTH(MEM_DEPTH),.DATA_WIDTH(DATA_WIDTH)) FIFO (
.W_CLK(W_CLK),
.W_EN(W_INC & !FULL),
.W_addr(W_addr),
.R_addr(R_addr),
.WR_DATA(WR_DATA),
.RD_DATA(RD_DATA)
);


FIFO_RD #(.MEM_DEPTH(MEM_DEPTH)) Read (
.R_CLK(R_CLK),
.R_RST(R_RST),
.R_INC(R_INC),
.RQ2(RQ2),
.R_addr(R_addr),
.R_ptr(R_ptr),
.R_EMPTY(EMPTY)
);


FIFO_WR #(.MEM_DEPTH(MEM_DEPTH)) Write (
.W_CLK(W_CLK),
.W_RST(W_RST),
.W_INC(W_INC),
.WQ2(WQ2),
.W_addr(W_addr),
.W_ptr(W_ptr),
.W_FULL(FULL)
);

endmodule // FIFO_top