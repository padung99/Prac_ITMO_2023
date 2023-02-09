module multiplyBy4(
	input [31:0] Number_i,
	output logic [31:0] Result_o
); 

assign Result_o =  Number_i << 2;

endmodule
