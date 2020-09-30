module regfile(input logic clk, RegWrite,
			input logic [1:0] RegDst,
			input logic [4:0] ra, rb, rc,
			input logic [31:0] wdata,
			output logic [31:0] radata, rbdata);
	logic [31:0] Registers [31:0];
	logic [4:0] rd; 

	initial //initializes all of memory to be 0
	begin
		Registers[0] <= 32'd0;
        Registers[1] <= 32'd0;
		Registers[2] <= 32'd0;
		Registers[3] <= 32'd0;
		Registers[4] <= 32'd0;
		Registers[5] <= 32'd0;
		Registers[6] <= 32'd0;
		Registers[7] <= 32'd0;
		Registers[8] <= 32'd0;
		Registers[9] <= 32'd0;
		Registers[10] <= 32'd0;
		Registers[11] <= 32'd0;
		Registers[12] <= 32'd0;
		Registers[13] <= 32'd0;
		Registers[14] <= 32'd0;
		Registers[15] <= 32'd0;
		Registers[16] <= 32'd0;
		Registers[17] <= 32'd0;
		Registers[18] <= 32'd0;
		Registers[19] <= 32'd0;
		Registers[20] <= 32'd0;
		Registers[21] <= 32'd0;
		Registers[22] <= 32'd0;
		Registers[23] <= 32'd0;
		Registers[24] <= 32'd0;
		Registers[25] <= 32'd0;
        Registers[26] <= 32'd0;
		Registers[27] <= 32'd0;
		Registers[28] <= 32'd0;
		Registers[29] <= 32'd0;
		Registers[30] <= 32'd0;
		Registers[31] <= 32'b0;
	end
	//To check if the destination register is zero, so not written to
	always_comb
	begin 
		if (RegDst == 2'b10) 
			rd <= 5'b11111; // $ra = Register 31
		else if(RegDst == 2'b01) // if this then $ra (2)
			rd <= rb; // if RegDst = 1 then dest in rt
		else if(RegDst == 2'b11) // if $xp (3)
			rd <= 5'b00001; // $xp = Register 1 
		else 
			rd <= rc; // otherwise it is in rd 
	end	
	//Write 
	always_ff @(posedge clk)
	begin
		if (RegWrite && rd != 5'd0)
			Registers[rd] <= wdata; // writes to the destination if it is not $zero 
	end
	
	//Read 
	always_comb
	begin
		radata <= Registers[ra]; // reading rs
		rbdata <= Registers[rb]; // reading rt
	end
endmodule
/*
B.  You need to expand the RegDst multiplexer to write to Register $XP in case of an 
exception or an interrupt. Instead of creating new registers for these, we will 
declare Register 1 as $XP and use it to hold the address of the instruction. We will 
not worry about the Cause register.

Also, to support jal and jr, we need to save off PC+4 to the $RA register (register 31),
which also requires expanding the RegDst multiplexer.

*/