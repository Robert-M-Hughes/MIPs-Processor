module arith(input logic [1:0] ALUOp,
			input logic [31:0] A, B,
			output logic [31:0] arithout,
			output logic z, v, n);

//Temporary Variable		
reg [31:0] temp;
//Changes B to 2's complement
always_comb
begin 
	if (ALUOp[0] == 0) //add
		temp <= B;
	else 
		temp <= ~B + 1; 
end 

//Makes addition of 2's complement numbers
always_comb 
begin 
	arithout <= A+temp; 
end		

//Determine v, z, and n
always_comb 
begin
	 // Checks to see if output is zero
	if (arithout == 32'd0)
		z <= 1'b1;
	else 
		z <= 1'b0;
	//Checks to see if output is negative 
	if (arithout[31] == 1)
		n <= 1'b1;	
	else 
		n <= 1'b0;	
	//Checks for overflow
	if ((A[31] == 1'b0) && (temp[31] == 1'b0) && (arithout[31] == 1'b1))  //2 pos = neg
		v <= 1'b1;
	else if ((A[31] == 1'b1) && (temp[31] == 1'b1) && (arithout[31] == 1'b0))//2 neg = pos
		v <= 1'b1;
	else
		v <= 1'b0;
end

endmodule 