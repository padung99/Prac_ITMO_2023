module reg_file (
	input clk_i,
	input [4:0] addr1_i,
	input [4:0] addr2_i,
	input [4:0] addr3_i,
	input we3_en_i,
	input [31:0] wd3_i,
	output logic [31:0] rd1_o,
	output logic [31:0] rd2_o	
);												//    [31:0]		

logic [31:0] mem_reg_file [31:0]  = '{32'h00000000,		//31
												  32'h00000001,		//30
												  32'h00000002,		//29
												  32'h00000003,		//28
												  32'h00000004,		//27
												  32'h00000005,		//26
												  32'h00000006,		//25
												  32'h00000007,   	//24
												  32'h00000008,		//23
												  32'h00000009,		//22
												  32'h0000000A,		//21
												  32'h0000000B,   	//20
												  32'h0000000C,		//19
												  32'h0000000D,		//18
												  32'h0000000E,		//17
												  32'h0000000F,   	//16
											     32'h00000010,		//15
												  32'h00000011,		//14
												  32'h00000012,		//13
												  32'h00000013,   	//12
												  32'h00000014,		//11
												  32'h00000015,		//10
												  32'h00000016,		//9
												  32'h00000017,   	//8
											     32'h00000018,		//7
												  32'h00000019,		//6
												  32'h0000001A,		//5
												  32'h0000001B,		//4
												  32'h0000001C,		//3
												  32'h0000001D,		//2
												  32'h0000001E,		//1
												  32'h0000001F};		//0

always_ff @(posedge clk_i)
		if (we3_en_i)
			begin
				mem_reg_file[addr3_i] <= wd3_i;
				rd1_o <= mem_reg_file[addr1_i];
				rd2_o <= mem_reg_file[addr2_i];
			end
		else	
			begin
				rd1_o <= mem_reg_file[addr1_i];
				rd2_o <= mem_reg_file[addr2_i];
			end
			
endmodule




