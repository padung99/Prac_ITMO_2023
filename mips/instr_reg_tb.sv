module instr_reg_tb;

bit clk, fetch_en_i_tb;
logic [3:0] IRWrite_i_tb;
logic [7:0] instr8bit_i_tb;
logic [31:0] instr_o_tb;

initial 
	forever
		#5 clk = !clk;
	
instr_reg DUT (
	.IRWrite_i (IRWrite_i_tb),
	.instr8bit_i (instr8bit_i_tb),
	.fetch_en_i (fetch_en_i_tb), 
	.instr_o (instr_o_tb)
);

initial 
	begin
		#5;
		IRWrite_i_tb = 4'b0001;
		instr8bit_i_tb = 8'b01010110;
		fetch_en_i_tb = 1'b0;

		#5;
		IRWrite_i_tb = 4'b0010;
		instr8bit_i_tb = 8'b01010110;
		fetch_en_i_tb = 1'b0;

		#5;
		IRWrite_i_tb = 4'b0100;
		instr8bit_i_tb = 8'b01010110;
		fetch_en_i_tb = 1'b0;

		#5;
		IRWrite_i_tb = 4'b1000;
		instr8bit_i_tb = 8'b01010110;
		fetch_en_i_tb = 1'b0;

		#5;
		IRWrite_i_tb = 4'b0001;
		instr8bit_i_tb = 8'b01010110;
		fetch_en_i_tb = 1'b1;

		#5;
		IRWrite_i_tb = 4'b0001;
		instr8bit_i_tb = 8'b01010110;
		fetch_en_i_tb = 1'b0;	
	end

endmodule
