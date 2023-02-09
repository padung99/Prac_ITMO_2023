module mips_top_tb;

bit clk_tb, rst_tb;
logic [31:0] ALUResult;

initial 
	forever
	#5 clk_tb = !clk_tb; //5 ps

mips_top DUT(
	.clk_i_top(clk_tb),
	.rst_i_top(rst_tb),
	.ALUResult_o_top(ALUResult)	
);
	
initial
	begin
		rst_tb = 1'b1;
		#4;
		rst_tb = 1'b0;
		@(posedge clk_tb);
		//rst_tb <= 1'b0;
		
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);	
		
	end
	
endmodule
