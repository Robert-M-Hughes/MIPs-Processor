module comp(input logic ALUOp3,
	input logic ALUOp1,
	input logic z,v,n,
	output logic[31:0] compout);

	//Module declarations

	//Output assignment
	always_comb
		begin
			
			case({ALUOp3,ALUOp1})
				2'b00	:	if (z == 1) begin //cmpeq
						compout <= 1;
					end
					else begin
						compout <= 32'd0;
					end
				2'b01	:	if((n == 1 && z == 0 && v ==0) || (v == 1 && n == 0))begin//cmplt
						compout <= 1;
					end	
					else begin
							compout <= 32'd0;
						end
				2'b10	:	if (((n == 1 || z == 1) && v ==0) || (v == 1 && n == 0)) begin//cmple
						compout <= 1;					
				end
					else begin
							compout <= 32'd0;
						end

				default	:	compout <= 32'd0;
			endcase
			

		end
endmodule

