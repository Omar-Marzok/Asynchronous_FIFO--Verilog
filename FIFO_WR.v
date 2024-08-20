module FIFO_WR #(parameter MEM_DEPTH = 8) (
    input wire           				 W_CLK,
    input wire           				 W_RST,
    input wire           				 W_INC,
    input wire  [$clog2(MEM_DEPTH):0] 	 WQ2,
    output reg  [$clog2(MEM_DEPTH):0]   W_addr,
    output wire [$clog2(MEM_DEPTH):0]   W_ptr,
    output wire            				 W_FULL
);


always@(posedge W_CLK or negedge W_RST)
begin
	if(!W_RST)
	begin
		W_addr <= 0;
	end
	else if (W_INC && !W_FULL)
	begin
		W_addr <= W_addr + 1;
	end
end

// convert binary to gray
assign W_ptr = W_addr ^ (W_addr>>1);

// full flag
assign W_FULL = (WQ2[3]!=W_ptr[3])&&(WQ2[2]!=W_ptr[2])&&(WQ2[1:0]==W_ptr[1:0]) ? 1:0;

endmodule 

