module bool(input logic[3:0] ALUOp,
	input logic[31:0] A,B,
	output logic[31:0] boolout);

	//Module declarations

	//Output assignment
	always_comb
		begin
			case(ALUOp)
			4'b1010	:	boolout <= A;          //a
			4'b1000	:	boolout <= A & B;      //and
			4'b0001	:	boolout <= ~(A|B);     //nor
			4'b1110	:	boolout <= A|B;        //or
			4'b1001	:	boolout <= ~(A^B);     //xnor
			4'b0110	:	boolout <= A^B;        //xor
			default	:	boolout <= 32'd0;
			endcase
		end
		
endmodule

