module FIFO_RD #(parameter MEM_DEPTH = 8) (
    input wire           				 R_CLK,
    input wire           				 R_RST,
    input wire           				 R_INC,
    input wire  [$clog2(MEM_DEPTH):0] 	 RQ2,
    output reg  [$clog2(MEM_DEPTH):0]    R_addr,
    output wire [$clog2(MEM_DEPTH):0]    R_ptr,
    output wire            				 R_EMPTY
);

always@(posedge R_CLK or negedge R_RST)
begin
	if(!R_RST)
	begin
		R_addr <= 0;
	end
	else if (R_INC && !R_EMPTY)
	begin
		R_addr <= R_addr + 1;
	end
end

// convert binary to gray
assign R_ptr = R_addr ^ (R_addr>>1);

// empty flag
assign R_EMPTY = (RQ2==R_ptr) ? 1:0;

endmodule 


