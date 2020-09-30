module pc(input logic clk, reset, irq, PC31,
	input logic [1:0] PCSel, 
	input logic [31:0] j_Mux,
	output logic [31:0] ia = 32'd0); 
	
//implementation below
always_ff @(posedge clk or posedge reset)
//Need active-high, asynchronous RESET that resets the system by setting 
// PC=0x0; when not resetting, we will set PC=PC+4. PC itself is a 
// rising-edge triggered register

/* The high-order bit of the PC is dedicated as the “Supervisor” bit. 
Instruction fetch ignores this bit, treating it as if it were zero. 
The jr instruction is allowed to clear the Supervisor bit or leave it 
unchanged, but cannot set it, and no other instructions may have any 
effect on it. Only reset, exceptions, and interrupts cause the Supervisor
bit to become set.*/ 
begin 
	if (reset) 
		ia <= 32'h80000000;
	else
	begin 
		if (irq && (PC31 == 1'b0))
			ia <= 32'h80000008; //32'h80000008 = XAdr interrupt 
		else if (PCSel == 2'b11) 
			ia <= 32'h80000004;//32'h80000004 = ILL_OP exception 
		else 
			ia <= j_Mux;
	end 
	
end
endmodule
