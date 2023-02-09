module controlUnit (
	input rst_i,
	input clk_i,
	input [5:0] op_i,
	input [5:0] funct_i,
	output fetch_en_o,
	output IorD_o,
	output MemWrite_o,
	output [3:0] IRWrite_o ,
	output RegWrite_o ,
	output ALUSrcA_o ,
	output [1:0] ALUSrcB_o ,
	output [1:0] ALUOp_o ,
	output [1:0] PCSrc_o ,
	output Branch_o ,
	output PCWrite_o ,
	output RegDst_o ,
	output MemtoReg_o 
);

bit fetch_en = 'x;
bit IorD = 'x;
bit MemWrite = 'x;
logic [3:0] IRWrite = 'x;
bit RegWrite = 'x;
bit ALUSrcA = 'x; 
logic [1:0] ALUSrcB = 'x;
logic [1:0] ALUOp = 'x;
logic [1:0] PCSrc = 'x;
bit Branch = 'x;
bit PCWrite = 'x;
bit RegDst = 'x; 
bit MemtoReg = 'x;

enum logic [3:0] {
	RESET,
	STATE1,
	STATE2, 
	STATE3,
	REG_FETCH,
	MEM_ADRR_COMPUTATION,
	MEM_ACCESS_LW,
	WRITE_BACK,
	MEM_ACCESS_SW,
	EXECUTION,
	R_TYPE_COMPLETION,
	BRANCH_COMPLETION,
	JUMP_COMPLETION
} state, next_state;


//State will be changed at the positive edge of clk signal 
always_ff @(posedge clk_i)
	if(rst_i)
		state <= RESET;
	else
		state <= next_state;

assign fetch_en_o = fetch_en;
assign IorD_o = IorD;
assign MemWrite_o =  MemWrite;
assign IRWrite_o = IRWrite;
assign RegWrite_o = RegWrite;
assign ALUSrcA_o = ALUSrcA;
assign ALUSrcB_o = ALUSrcB;
assign ALUOp_o = ALUOp;
assign PCSrc_o = PCSrc;
assign Branch_o = Branch;
assign PCWrite_o = PCWrite;
assign RegDst_o = RegDst;
assign MemtoReg_o = MemtoReg;

always_comb
	begin
		next_state = state;
		ALUSrcA = 'x;
		IorD = 'x;
		IRWrite = 'x;
		ALUSrcB = 'x;
		ALUOp = 'x;
		PCWrite  = 1'b1;
		PCSrc  = 'x;
		fetch_en  = 'x;
		Branch = 'x;
		RegDst = 'x;
		RegWrite = 'x;
		MemtoReg = 'x;
		MemWrite= 'x;
		
		case (state)
			RESET:
				begin
					ALUSrcA = 1'b0;
					IorD = 1'b0;
					IRWrite = 4'b0001;
					ALUSrcB = 2'b01;
					ALUOp = 2'b00;
					PCWrite  = 1'b1;
					PCSrc  = 2'b00;
					fetch_en  = 1'b0;
					
					next_state = STATE1;
				end
			
			STATE1:
				begin
					ALUSrcA  = 1'b0;
					IorD  = 1'b0;
					IRWrite  = 4'b0010;
					ALUSrcB  = 2'b01;
					ALUOp  = 2'b00;
					PCWrite  = 1'b1;
					PCSrc  = 2'b00;
					fetch_en  = 1'b0;
					
					next_state = STATE2;
				end

			STATE2:
				begin
					ALUSrcA  = 1'b0;
					IorD  = 1'b0;
					IRWrite  = 4'b0100;
					ALUSrcB  = 2'b01;
					ALUOp  = 2'b00;
					PCWrite  = 1'b1;
					PCSrc  = 2'b00;
					fetch_en  = 1'b0;	
					
					next_state = STATE3;
				end
				
			STATE3:
				begin
					ALUSrcA  = 1'b0;
					IorD  = 1'b0;
					IRWrite  = 4'b1000;
					ALUSrcB  = 2'b01;
					ALUOp  = 2'b00;
					PCWrite  = 1'b1;
					PCSrc  = 2'b00;
					fetch_en  = 1'b0;
					
					next_state = REG_FETCH;
				end
			
			REG_FETCH:
				begin
					ALUSrcA  = 1'b0;
					ALUSrcB  = 2'b11;
					ALUOp  = 2'b00;
					PCWrite  = 1'b0;
					fetch_en  = 1'b1;
					PCSrc  = 2'b11;
					
					if(op_i == 6'h0)
						next_state = EXECUTION;
					else if (op_i == 6'h4)
						next_state = BRANCH_COMPLETION;
					else if (op_i == 6'h2)
						next_state = JUMP_COMPLETION;
					else if (op_i == 6'h2b || op_i == 6'h23)  //lw(load word): 0x23, sw (store word): 0x2b
						next_state = MEM_ADRR_COMPUTATION;
				end
			
			EXECUTION:
				begin
					ALUSrcA  = 1'b1;
					ALUSrcB  = 2'b00;
					ALUOp  = 2'b10;
					PCSrc  = 2'b11;
					
					next_state = R_TYPE_COMPLETION;
				end
			
			R_TYPE_COMPLETION:
				begin
					RegDst  = 1'b1;
					RegWrite  = 1'b1;
					MemtoReg  = 1'b0;
					PCSrc  = 2'b11;
					
					next_state = RESET;
				end
			
			BRANCH_COMPLETION:
				begin
					ALUSrcA  = 1'b1;
					ALUSrcB  = 2'b00;
					ALUOp  = 2'b01;	
					Branch  = 1'b1;
					PCSrc  = 2'b01;
					
					next_state = RESET;
				end
			
			JUMP_COMPLETION:
				begin
					PCWrite  = 1'b1;
					PCSrc  = 2'b10;
					
					next_state = RESET;
				end
			
			MEM_ADRR_COMPUTATION:
				begin
					ALUSrcA  = 1'b1;
					ALUSrcB  = 2'b10;
					ALUOp  = 2'b00;
					PCSrc  = 2'b11;
					
					if(op_i == 6'h2b)
						next_state = MEM_ACCESS_SW;
					else if(op_i == 6'h23)
						next_state = MEM_ACCESS_LW;
				end
			
			MEM_ACCESS_SW:
				begin
					IorD  = 1'b1;
					MemWrite  = 1'b1;
					PCSrc  = 2'b11;
					
					next_state = RESET;
				end
			
			MEM_ACCESS_LW:
				begin
					IorD  = 1'b1;
					PCSrc  = 2'b11;
					
					next_state = WRITE_BACK;
				end
			
			WRITE_BACK:
				begin
					RegDst  = 1'b0;
					RegWrite  = 1'b1;
					MemtoReg = 1'b1;
					PCSrc  = 2'b11;
					
					next_state = RESET;
				end
			
			default: next_state = RESET;
		endcase
	end
	
	
endmodule
