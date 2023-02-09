module ALUControl (
	input [1:0] ALUop_i,
	input [5:0] funct_i,
	output logic [2:0] aluControl_o
);

always_comb
	begin
	aluControl_o = 3'bxxx;
		case (ALUop_i)
			2'b00: aluControl_o = 3'b010;
			2'b01: aluControl_o = 3'b110;
			2'b10:
				begin
					if (funct_i == 6'b100000)
						aluControl_o = 3'b010;
					if (funct_i == 6'b100010)
						aluControl_o = 3'b110;
					if (funct_i == 6'b100100)
						aluControl_o = 3'b000;
					if (funct_i == 6'b100101)
						aluControl_o = 3'b001;
					if (funct_i == 6'b101010)
						aluControl_o = 3'b111;
				end
			2'b11: aluControl_o = 3'bxxx;
		endcase
	end 

endmodule

