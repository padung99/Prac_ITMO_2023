module mult_3to1 (
	input [31:0] p00_i,
	input [31:0] p01_i,
	input [31:0] p10_i,
	input [31:0] p11_i,
	input logic [1:0] sel_i,
	output logic [31:0] res_o
);

always_comb
	begin
		//res_o =  '0;
		case (sel_i)
			2'b00: res_o = p00_i;
			2'b01: res_o = p01_i;
			2'b10: res_o = p10_i;
			2'b11: res_o = p11_i; //connect 1 more wire to save pre value counter
			default: res_o = '0;
		endcase
	end
endmodule
