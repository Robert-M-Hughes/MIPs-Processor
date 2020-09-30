module shift(input logic[1:0] ALUOp,
	input logic signed[31:0]A,B,
	output logic signed[31:0] shiftout);

	//Module declarations

	//Output assignment
	always_comb
		begin
			
			case(ALUOp)
				2'b00	:	shiftout <= A << B[4:0];//SLL
				2'b01	:	shiftout <= A >> B[4:0];//SRL
				2'b11	:	shiftout <= A >>> B[4:0];//SR&sign extend
				default:	shiftout <= 32'd0;
			endcase

		end
endmodule

