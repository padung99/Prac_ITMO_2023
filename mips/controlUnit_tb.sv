module controlUnit_tb;

bit clk_tb, rst_i_tb;

initial
	forever
	#5 clk_tb = !clk_tb;
	
logic [5:0] op_i_tb;
logic [5:0] funct_i_tb;
bit fetch_en;
bit IorD;
bit MemWrite;
logic [3:0] IRWrite;
bit RegWrite;
bit ALUSrcA; 
logic [1:0] ALUSrcB;
logic [1:0] ALUOp;
logic [1:0] PCSrc;
bit Branch;
bit PCWrite;
bit RegDst; 
bit MemtoReg;

controlUnit DUT(
	.rst_i(rst_i_tb), //input
	.clk_i(clk_tb),
	.op_i(op_i_tb), //input 
	.funct_i(funct_i_tb), //input
	.fetch_en_o(fetch_),
	.IorD_o(IorD),
	.MemWrite_o(MemWrite),
	.IRWrite_o(IRWrite),
	.RegWrite_o(RegWrite),
	.ALUSrcA_o(ALUSrcA),
	.ALUSrcB_o(ALUSrcB),
	.ALUOp_o(ALUOp),
	.PCSrc_o(PCSrc),
	.Branch_o(Branch),
	.PCWrite_o(PCWrite),
	.RegDst_o(RegDst),
	.MemtoReg_o(MemtoReg) 
);

initial 
	begin
		#4;
		rst_i_tb = 1'b1;
		op_i_tb = 6'h2b;
		//funct_i_tb = 6'b100000;
		
		@(posedge clk_tb);
		rst_i_tb <= 1'b0;
		
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		@(posedge clk_tb);
		
		#4;
		//rst_i_tb = 1'b1;
		op_i_tb = 6'b000000;
		funct_i_tb = 6'b100010;
		
		@(posedge clk_tb);
		//rst_i_tb <= 1'b0;
		
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