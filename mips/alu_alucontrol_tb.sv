//Tesing 2 modules alu and ALUControl in a testbench file
module alu_alucontrol_tb;

bit clk_tb, zero_o_tb;

initial
	forever
	#5 clk_tb = !clk_tb;

logic [31:0] srcA_i_tb, srcB_i_tb, aluResult_o_tb;
logic [2:0] aluControl_tb;
logic [1:0] ALUop_i_tb;
logic [5:0] funct_i_tb;

alu inst_alu(
	//.clk_i(clk_tb),
	.srcA_i(srcA_i_tb), //input
	.srcB_i(srcB_i_tb),//input
	.aluControl_i(aluControl_tb),
	.zero_o(zero_o_tb),
	.aluResult_o(aluResult_o_tb)
);

ALUControl inst_ALUControl(
	.ALUop_i(ALUop_i_tb), //input
	.funct_i(funct_i_tb), //input
	.aluControl_o(aluControl_tb)
);

initial
	begin
		#4;
		@(posedge clk_tb);		
		srcA_i_tb <= 32'h00000009;
		srcB_i_tb <= 32'h00000002;
		
		@(posedge clk_tb);
		ALUop_i_tb <= 2'b00;
		
		@(posedge clk_tb);
		ALUop_i_tb <= 2'b01;
		
		@(posedge clk_tb);
		ALUop_i_tb <= 2'b10;
		funct_i_tb <= 6'b100000;
		
		@(posedge clk_tb);
		srcA_i_tb <= 32'h00000016;
		srcB_i_tb <= 32'h00000004;
		ALUop_i_tb <= 2'b10;
		funct_i_tb <= 6'b100010;
		
		@(posedge clk_tb);
		ALUop_i_tb <= 2'b10;
		funct_i_tb <= 6'b100100;
		
		@(posedge clk_tb);
		ALUop_i_tb <= 2'b10;
		funct_i_tb <= 6'b100101;
		
		@(posedge clk_tb);
		srcA_i_tb <= 32'h00000010;
		srcB_i_tb <= 32'h00000010;
		ALUop_i_tb <= 2'b10;
		funct_i_tb <= 6'b101010;
		
		@(posedge clk_tb);
		
	end
endmodule
