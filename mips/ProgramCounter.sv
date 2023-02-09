module ProgramCounter (
	input clk_i,
	input en_i,
	input [31:0] addr_i,
	output logic [31:0] addr_o
);

logic [31:0] addr_out;

always_ff @(posedge clk_i)
		if (en_i)
			addr_out <= addr_i;

assign addr_o = addr_out;
endmodule


