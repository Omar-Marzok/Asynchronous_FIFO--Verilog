module DF_SYNC #(parameter MEM_DEPTH = 8) (
    input wire      					clk,
    input wire     						RST,
	input wire [$clog2(MEM_DEPTH):0] InData,
    output reg [$clog2(MEM_DEPTH):0] OutData
);

reg [$clog2(MEM_DEPTH):0] sync_flop1;

always @(posedge clk or negedge RST) 
 begin
    if (!RST) 
    begin
		sync_flop1  <= 0;
		OutData 	<= 0;
    end 
    else
    begin  
		sync_flop1 <= InData;
		OutData    <= sync_flop1;
    end
 end 


endmodule 
