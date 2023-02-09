module reg_file_tb;

bit clk_tb, we3_en_i_tb;
logic [4:0] addr1_i_tb, addr2_i_tb, addr3_i_tb;
logic [31:0] wd3_i_tb, rd1_o_tb, rd2_o_tb;


initial
	forever
		#5 clk_tb = !clk_tb;

reg_file DUT (
	.clk_i(clk_tb),
	.addr1_i(addr1_i_tb),
	.addr2_i(addr2_i_tb),
	.addr3_i(addr3_i_tb),
	.we3_en_i(we3_en_i_tb),
	.wd3_i(wd3_i_tb),
	.rd1_o(rd1_o_tb),
	.rd2_o(rd2_o_tb)
);

initial 
	begin
	#4;
	addr1_i_tb = 5'b00001;
	addr2_i_tb = 5'b00010;
	addr3_i_tb = 5'b10100;	
	we3_en_i_tb = 1'b0;
	wd3_i_tb = 'x;
	
	@(posedge clk_tb);
	@(posedge clk_tb);
	we3_en_i_tb = 1'b0;
	wd3_i_tb = 32'h00001010;
	
	@(posedge clk_tb);
	@(posedge clk_tb);
	we3_en_i_tb = 1'b1;
	end
endmodule

