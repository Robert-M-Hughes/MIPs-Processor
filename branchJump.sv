module branchJump(input logic clk, bSel, MemHit, MemRead, MemWrite, MemWriteReady, MemWriteDone, 
	input logic MemReadReady, MemReadDone, 
	input logic [1:0] jSel,
	input logic [5:0] opCode,
	input logic [31:0] id, ia,
	input logic [31:0] data2, radata,
	output logic [31:0] j_Mux);  


	logic [31:0] bValue, bMux, tempPC, readPC, writePC; // value out of the branch mux
//implementation below
always_comb  // For Read with Hit and Miss 
begin 
	if( (MemHit == 1'b1 && MemRead == 1'b1 && MemReadReady == 1'b0 && MemReadDone == 1'b0) || (MemHit == 1'b0 && MemRead == 1'b0 && MemReadReady == 1'b0 && MemReadDone == 1'b0) || (MemHit == 1'b1 && MemRead == 1'b1 && MemReadReady == 1'b0 && MemReadDone == 1'b1) || (MemHit == 1'b1 && MemRead == 1'b0 && MemReadReady == 1'b0 && MemReadDone == 1'b0) )
		readPC <= ia + 32'd4;
	else 
		readPC <= ia; 


// One clock cycle after setting MemWriteDone to 1, select next instruction. 

	if (MemWrite == 1'b1 && MemWriteReady == 1'b0 && MemWriteDone == 1'b1) 
		writePC <= ia + 32'd4;
	else 
		writePC <= ia; 
end

always_comb
begin 
	if (MemWrite == 1'b1)
		tempPC <= writePC;
	else 
		tempPC <= readPC; 
end 

always_comb
// The branch offset adder adds PC + 4 to the immediate filed.
// Remember that the 16-bit immediate field needs to be word-aligned 
// and then sign-extended.  
begin 
	//calculates the value pc uses for the branch 
	//checks to see if id was sign extended. 
	if(opCode == 6'b000100 || opCode == 6'b000101)
		bValue <= (data2 << 2'd2) + (tempPC);
	else 
		bValue <= 32'd0;
end

//To implement the branch mux
always_comb
begin 
	if(!bSel)
		bMux <= bValue;//branch if 0
	else 
		bMux <= tempPC; 
end

//To implement the jump mux
always_comb
begin 
	if(jSel == 2'b01)
		j_Mux <= {tempPC[31:28], id[25:0], 2'd0};// if zero use calculated value
	else if (jSel == 2'b00)
		j_Mux <= bMux;// if 1 use value from branch mux
	else 
		j_Mux <= radata; 
end
endmodule
