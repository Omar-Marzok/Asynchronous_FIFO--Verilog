`timescale  1ns/1ps
module FIFO_top_tb #(parameter DATA_WIDTH_tb = 8,MEM_DEPTH_tb=8) ();
    reg           			W_CLK_tb;
    reg           			W_RST_tb;
    reg           			W_INC_tb;
    reg           			R_CLK_tb;
    reg           			R_RST_tb;
    reg           			R_INC_tb;
    reg  [DATA_WIDTH_tb-1:0] WR_DATA_tb;
    wire [DATA_WIDTH_tb-1:0] RD_DATA_tb;
    wire           			FULL_tb;
    wire           			EMPTY_tb;

parameter WCLK_PERIOD = 10 , RCLK_PERIOD = 25;
reg [DATA_WIDTH_tb-1:0] rand_num;
	
// Write initial blok	
initial 
begin
	initialize();
	W_reset();
	
	check();
	// write until full and see the fifo
	repeat(10) 
	begin
	rand_num = $random & ((1 << DATA_WIDTH_tb) - 1);
	FIFO_Write(rand_num);
	check();
	end
	
	wait(EMPTY_tb);
	@(negedge R_CLK_tb);
	#(5*WCLK_PERIOD)
	
	repeat(12) 
	begin
	rand_num = $random & ((1 << DATA_WIDTH_tb) - 1);
	FIFO_Write(rand_num);
	check();
	end
	
	#200 $stop;  // end stimulus here
end

// Read initial blok
initial 
begin
	initialize();
	
	wait(FULL_tb); // FIFO is FULL
	@(negedge R_CLK_tb);
	#(RCLK_PERIOD)
	repeat(10) 
	begin
	FIFO_Read();
	check();
	end
	
	#RCLK_PERIOD
	repeat(12) 
	begin
	FIFO_Read();
	check();
	end
	
    #200 $stop;  // end stimulus here
end

//////////////////// TASKS /////////////////////////

//----------------> initialization
task initialize ;
  begin
	W_CLK_tb	=0;
   	W_INC_tb	=0;
	R_CLK_tb	=0;
	R_INC_tb	=0;
	WR_DATA_tb	=0;
  end
endtask

//----------------> read reset
task R_reset ;
  begin
    R_RST_tb = 1'b1;
    #RCLK_PERIOD
    R_RST_tb = 1'b0;
    #RCLK_PERIOD
    R_RST_tb = 1'b1;
    #RCLK_PERIOD;
  end
endtask

//----------------> write reset
task W_reset ;
  begin
    W_RST_tb = 1'b1;
	R_RST_tb = 1'b1;
    #WCLK_PERIOD
    W_RST_tb = 1'b0;
	R_RST_tb = 1'b0;
    #WCLK_PERIOD
    W_RST_tb = 1'b1;
	R_RST_tb = 1'b1;
    #WCLK_PERIOD;
  end
endtask

//----------------> Write data in FIFO
task FIFO_Write ;
  input [DATA_WIDTH_tb-1:0] data;
  begin
   	W_INC_tb	=1;
	WR_DATA_tb	=data;
	#WCLK_PERIOD;
	W_INC_tb	=0;
  end
endtask

//----------------> Read from FIFO
task FIFO_Read ;
  begin
	R_INC_tb	=1;
	#RCLK_PERIOD
	R_INC_tb	=0;
  end
endtask

//----------------> check FULL and EMPTY cases
task check ;
  begin
    if (FULL_tb == 1)
	 $display("the FIFO is FULL as W_addr= %b and R_addr= %b at time = %t",DUT.Write.W_addr,DUT.Read.R_addr,$time);
	if (EMPTY_tb == 1)
	 $display("the FIFO is EMPTY as W_addr= %b and R_addr= %b at time = %t",DUT.Write.W_addr,DUT.Read.R_addr,$time);
  end
endtask

always #(WCLK_PERIOD/2) W_CLK_tb =~W_CLK_tb;
always #(RCLK_PERIOD/2) R_CLK_tb =~R_CLK_tb;

FIFO_top #(.MEM_DEPTH(MEM_DEPTH_tb),.DATA_WIDTH(DATA_WIDTH_tb)) DUT (
        .W_CLK(W_CLK_tb),
        .W_RST(W_RST_tb),
        .W_INC(W_INC_tb),
        .R_CLK(R_CLK_tb),
        .R_RST(R_RST_tb),
        .R_INC(R_INC_tb),
        .WR_DATA(WR_DATA_tb),
        .RD_DATA(RD_DATA_tb),
        .FULL(FULL_tb),
        .EMPTY(EMPTY_tb)
    );
	
	
endmodule