module sign_extend (
	input [15:0] data_16bit_i,
	output [31:0] data_32bit_o
);


assign data_32bit_o = 32'(unsigned'(data_16bit_i));

endmodule
