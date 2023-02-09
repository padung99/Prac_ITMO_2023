module alu (
	//input clk_i,
	input [31:0] srcA_i,
	input [31:0] srcB_i,
	input [2:0] aluControl_i,
	output logic  zero_o,
	output logic [31:0] aluResult_o
);

always_comb
	begin
		case (aluControl_i)
			3'b010: begin
					zero_o = (srcA_i == srcB_i)?1:0;
					aluResult_o = srcA_i + srcB_i; //ADD
				end
				
			3'b110: begin
					zero_o = (srcA_i == srcB_i)?1:0;
					aluResult_o = srcA_i - srcB_i; //SUB
				end
				
			3'b000: begin
					zero_o = (srcA_i == srcB_i)?1:0;
					aluResult_o = srcA_i & srcB_i; //AND
				end
				
			3'b001: begin
					zero_o = (srcA_i == srcB_i)?1:0;
					aluResult_o = srcA_i | srcB_i; //OR
				end
				
			3'b111: begin
					zero_o = (srcA_i == srcB_i)?1:0;
					aluResult_o = srcA_i < srcB_i?1:0; //SLT
				end
			default: begin
					zero_o = (srcA_i == srcB_i)?1:0;
					aluResult_o = srcA_i < srcB_i?1:0; //SLT
				end
		endcase
	end
//assign zero_o = (srcA_i == srcB_i)?1:0;
endmodule

