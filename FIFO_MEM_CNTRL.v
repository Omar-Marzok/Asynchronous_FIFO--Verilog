module FIFO_MEM_CNTRL #(parameter DATA_WIDTH = 8,MEM_DEPTH = 8) (
    input wire           				 W_CLK,
    input wire           				 W_EN,
	input wire  [$clog2(MEM_DEPTH)-1:0]    W_addr,
	input wire  [$clog2(MEM_DEPTH)-1:0]    R_addr,
    input wire  [DATA_WIDTH-1:0] 		 WR_DATA,
    output wire [DATA_WIDTH-1:0] 		 RD_DATA
);

reg [DATA_WIDTH-1:0] FIFO [0:MEM_DEPTH-1];

always@(posedge W_CLK )
begin
	if(W_EN)
		FIFO[W_addr] <=  WR_DATA;
end

assign RD_DATA = FIFO[R_addr];

endmodule 
