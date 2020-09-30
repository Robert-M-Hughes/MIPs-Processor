module alu(input logic[31:0] A,B,
	input logic[4:0] ALUOp,
	output logic[31:0] Y,
	output logic z, v, n);

	//Signal declarations
	logic[31:0] boolout, shiftout, arithout, compout;

	//Module declarations
	bool xbool(ALUOp[3:0],A,B,boolout);
	arith xarith(ALUOp[1:0],A,B,arithout,z,v,n);
	comp xcomp(ALUOp[3],ALUOp[1],z,v,n,compout);
	shift xshift(ALUOp[1:0],A,B,shiftout);

	//Output assignment

	always_comb
		begin
			if(ALUOp[4] == 1) begin
				Y <= boolout;

				end
			else if(ALUOp[3:0] == 4'b0000 || ALUOp[3:0] == 4'b0001) begin
				Y <= arithout;
			end
			else if(ALUOp[3:0] == 4'b0101 || ALUOp[3:0] == 4'b0111 || ALUOp[3:0] == 4'b1101)begin
				Y <= compout;
			end
			else begin
				Y <= shiftout;
			end
		end
/*
		 // Output assignment
            assign Y = A;
            assign z = 1'b0; 
            assign v = 1'b0;
            assign n = 1'b0;

*/

endmodule

