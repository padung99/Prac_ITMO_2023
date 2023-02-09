module instr_reg (
	input [3:0] IRWrite_i,
	input [7:0] instr8bit_i,
	input bit fetch_en_i, 
	output logic [31:0] instr_o	
);

logic [3:0][7:0] instr_data;
bit IRWrite0_i, IRWrite1_i, IRWrite2_i, IRWrite3_i;

always_comb
	begin	
		if (fetch_en_i)
			instr_o = instr_data;
		else
			begin
				if(IRWrite_i[3])
					instr_data[0] =  instr8bit_i;
				if(IRWrite_i[2])
					instr_data[1] =  instr8bit_i;
				if(IRWrite_i[1])
					instr_data[2] =  instr8bit_i;
				if(IRWrite_i[0])
					instr_data[3] =  instr8bit_i;
				instr_o = instr_data;
			end
	end

endmodule


