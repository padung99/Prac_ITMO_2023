module mips_top (
	input clk_i_top,
	input rst_i_top,
	output [31:0] ALUResult_o_top	
);


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

//logic Adr;
logic [31:0] instr, A, WriteData, srcA, srcB, ALUResult, ALUOut, PCNext, Data, WD3, Imm, Immx4, PC, Adr, PCNext2;
logic [3:0] MemData;
bit Zero;
logic [7:0] instr8bit_top;
logic [2:0] aluControl_top;
bit PCEn;
logic [4:0] A3;

assign PCEn = PCWrite | (Zero & Branch);
//assign Immx4 = Imm * 4;
assign ALUResult_o_top = ALUResult;

controlUnit inst_controlUnit(
	.rst_i(rst_i_top),
	.clk_i(clk_i_top),
	.op_i(instr[31:26]),  
	.funct_i(instr[5:0]), 
	.fetch_en_o(fetch_en),
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

instr_reg inst_instr_reg(
	.IRWrite_i (IRWrite),
	.instr8bit_i (instr8bit_top),
	.fetch_en_i (fetch_en), 
	.instr_o (instr)
);

instr_memory inst_instr_memory(
	.clk_i(clk_i_top),
	.we_i(MemWrite),
	.addr_i(Adr),
	.wd_i(WriteData),
	.instr8bit_o(instr8bit_top)
);

reg_file inst_reg_file(
	.clk_i(clk_i_top),
	.addr1_i(instr[25:21]),
	.addr2_i(instr[20:16]),
	.addr3_i(A3),
	.we3_en_i(RegWrite),
	.wd3_i(WD3), //////////
	.rd1_o(A),
	.rd2_o(WriteData)
);

alu inst_alu(
	//.clk_i(clk_i_top),
	.srcA_i(srcA),
	.srcB_i(srcB),
	.aluControl_i(aluControl_top),
	.zero_o(Zero),
	.aluResult_o(ALUResult)
);

ALUControl inst_ALUControl(
	.ALUop_i(ALUOp), 
	.funct_i(instr[5:0]), 
	.aluControl_o(aluControl_top)
);

ProgramCounter inst_ProgramCounter(
	.clk_i(clk_i_top),
	.en_i(PCEn),
	.addr_i(PCNext),
	.addr_o(PC)
);

mult_2to1 inst_mult_2to1_4(
	.p0_i(PC),
	.p1_i(ALUOut),
	.sel_i(IorD),
	.res_o(Adr)
);

mult_2to1 inst_mult_2to1_3(
	.p0_i(instr[20:16]),
	.p1_i(instr[15:11]),
	.sel_i(RegDst),
	.res_o(A3)
);

mult_2to1 inst_mult_2to1_2(
	.p0_i(ALUOut),
	.p1_i(instr),
	.sel_i(MemtoReg),
	.res_o(WD3)
);

mult_2to1 inst_mult_2to1_1(
	.p0_i(PC),
	.p1_i(A),
	.sel_i(ALUSrcA),
	.res_o(srcA)
);

mult_3to1 inst_mult_3to1_1(
	.p00_i(ALUResult),
	.p01_i(ALUOut),
	.p10_i(Immx4),
	.p11_i(PC),
	.sel_i(PCSrc),
	.res_o(PCNext)
);


mult_4to1 inst_mult_4to1(
	.p00_i(WriteData),
	.p01_i(32'h00000001),
	.p10_i(Imm),
	.p11_i(Immx4),
	.sel_i(ALUSrcB),
	.res_o(srcB)
);

sign_extend inst_sign_extend(
	.data_16bit_i(instr[15:0]),
	.data_32bit_o(Imm)
);


multiplyBy4 inst_multiplyBy4(
	.Number_i(Imm),
	.Result_o(Immx4)
); 

always_ff @(posedge clk_i_top)
	ALUOut <= ALUResult;
	
endmodule
