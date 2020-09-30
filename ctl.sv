module ctl(input logic reset, z, irq, PC31, 
		input logic [5:0] opCode, 
		input logic [5:0] funct, 
		output logic [1:0] RegDst, PCSel, jump, 
		output logic ALUSrc,RegWrite, ASel, branch, 
		output logic MemWrite,MemRead,MemToReg, 
		output logic [4:0] ALUOp);

//reset will set all the singals to 0

	//For all other control signals 
	always_comb 
	begin 
		if (reset) // for reset 
		begin 
			ALUOp <= 5'b00000;
			ASel <= 1'b0;
			PCSel <= 2'b00;
			RegDst <= 2'b00;
			ALUSrc <= 1'b0;
			MemRead <= 1'b0; 
			MemToReg <= 1'b0; 
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			branch <= 1'b0;
			jump <= 2'b00;
			
			
		end 
		else if ((irq == 1) && (PC31 == 1'b0))
		begin 
			ALUOp <= 5'b11010; //jal 
			ASel <= 1'b1;
			PCSel <= 2'b00; 
			RegDst <= 2'b11;
			ALUSrc <= 1'b0; 
			MemRead <= 1'b0; 
			MemToReg <= 1'b0;  
			RegWrite <= 1'b1; 
			MemWrite <= 1'b0;
			branch <= 1'b0;
			jump <= 2'b00;

		end 
		//If R-type opcode 
		else if (opCode == 6'd0) 
		begin
			//add, sub, and, nor , or, xor
			case(funct[5:3])
				3'b100://R-type func[5:3]
				begin
					ASel <= 1'b0;
					PCSel <= 2'b00;
					RegDst <= 2'b00; 
					ALUSrc <= 1'b0; 
					MemRead <= 1'b0; 
					MemToReg <= 1'b0; 
					RegWrite <= 1'b1; 
					MemWrite <= 1'b0; 
					jump <= 2'b00;
					

					branch <= 1'b1;//no branch
					case(funct[2:0])
						3'b000: //add
							ALUOp <= 5'b00000;
						3'b010: //sub
							ALUOp <= 5'b00001;
						3'b100: //and
							ALUOp <= 5'b11000;
						3'b101: //or
							ALUOp <= 5'b11110;
						3'b110: //xor
							ALUOp <= 5'b10110;	
						3'b111: // nor
							ALUOp <= 5'b10001;	
						default: //For NOP initially set everything to zero.
						begin
							ALUOp <= 5'b11010;
							ASel <= 1'b1;
							PCSel <= 2'b11;
							RegDst <= 2'b11;
							ALUSrc <= 1'b0; 
							MemRead <= 1'b0; 
							MemToReg <= 1'b0; 
							RegWrite <= 1'b1; 
							MemWrite <= 1'b0;
							branch <= 1'b0;
							jump <= 2'b00;
						end
					endcase 
				end
				//sll, srl, sra 
				3'b000://R-type func[5:3]
				begin 
					ASel <= 1'b0;
					PCSel <= 2'b00;
					RegDst <= 2'b00;
					ALUSrc <= 1'b1; 
					MemRead <= 1'b0; 
					MemToReg <= 1'b0;  
					RegWrite <= 1'b1;  
					MemWrite <= 1'b0; 
					branch <= 1'b1;
					jump <= 2'b00;


					case(funct[2:0])
						3'b000: //sll 
							ALUOp <= 5'b01000;
						3'b010: //srl
							ALUOp <= 5'b01001;
						3'b011: //sra 
							ALUOp <= 5'b01011;
						default: //For NOP initially set everything to zero.
						begin
							ALUOp <= 5'b11010;
							ASel <= 1'b1;
							PCSel <= 2'b11;							
							RegDst <= 2'b11;
							ALUSrc <= 1'b0; 
							MemRead <= 1'b0; 
							MemToReg <= 1'b0; 
							RegWrite <= 1'b1; 
							MemWrite <= 1'b0;
							branch <= 1'b0;
							jump <= 2'b00;						
						end
					endcase
				end
				3'b101://R-type func[5:3]
				begin
					ASel <= 1'b0;
					PCSel <= 2'b00;
					RegDst <= 2'b00;
					ALUSrc <= 1'b0; 
					MemRead <= 1'b0; 
					MemToReg <= 1'b0;
					RegWrite <= 1'b1; 
					MemWrite <= 1'b0; 
					branch <= 1'b1;
					jump <= 2'b00;

					case(funct[2:0])
						3'b010: //for slt 
							ALUOp <= 5'b00111;
						default: //For NOP initially set everything to zero.
						begin
							ALUOp <= 5'b11010;
							ASel <= 1'b1;
							PCSel <= 2'b11;
							RegDst <= 2'b11;
							ALUSrc <= 1'b0; 
							MemRead <= 1'b0; 
							MemToReg <= 1'b0; 
							RegWrite <= 1'b1; 
							MemWrite <= 1'b0;
							branch <= 1'b0;
							jump <= 2'b00;

						end
					endcase
				end
		3'b001://jr
		begin 
			ALUOp <= 5'd0; 
			ASel <= 1'b0;
			PCSel <= 2'b00;
			RegDst <= 2'b10;
			ALUSrc <= 1'b0; 
			MemRead <= 1'b0; 
			MemToReg <= 1'b0; 
			RegWrite <= 1'b0; 
			MemWrite <= 1'b0;
			branch <= 1'b1;
			jump <= 2'b10; 

		end
				default: //For NOP initially set everything to zero.//R-type func[5:3]
				begin
					ALUOp <= 5'b11010;
					ASel <= 1'b1;
					PCSel <= 2'b11;
					RegDst <= 2'b11;
					ALUSrc <= 1'b0; 
					MemRead <= 1'b0; 
					MemToReg <= 1'b0; 
					RegWrite <= 1'b1; 
					MemWrite <= 1'b0;
					branch <= 1'b0;
					jump <= 2'b00;

				end
			endcase
		end
		
		//For jump ctl

		else if (opCode == 6'b000010)//(j)
		begin 
			ALUOp <= 5'b11010; 
			ASel <= 1'b0;
			PCSel <= 2'b00;
			RegDst <= 2'b10;
			ALUSrc <= 1'b0; 
			MemRead <= 1'b0; 
			MemToReg <= 1'b0; 
			RegWrite <= 1'b0; 
			MemWrite <= 1'b0; 
			branch <= 1'b1;
			jump <= 2'b01; 
		end

		else if (opCode == 6'b000011) // jal 
		begin 
			ALUOp <= 5'b11010; 
			ASel <= 1'b1;
			PCSel <= 2'b00;
			RegDst <= 2'b10;
			ALUSrc <= 1'b0; 
			MemRead <= 1'b0; 
			MemToReg <= 1'b0;
			RegWrite <= 1'b1; 
			MemWrite <= 1'b0; 
			branch <= 1'b1;
			jump <= 2'b01;
		end
		//For branch ctl
		else if (opCode == 6'b000100) // beq 
		begin 
			ALUOp <= 5'b00001; 
			ASel <= 1'b0;
			PCSel <= 2'b00;
			RegDst <= 2'b01;
			ALUSrc <= 1'b0; 
			MemRead <= 1'b0; 
			MemToReg <= 1'b0; 
			RegWrite <= 1'b0; 
			MemWrite <= 1'b0; 
			jump <= 2'b00;

			if (opCode == 6'b000100 && z == 1)
				branch <= 1'b0; //branch if zero
			else 
				branch <= 1'b1;// otherwise will do ia+4
		end
		else if(opCode == 6'b000101)  //bne
		begin 
			ALUOp <= 5'b00001; 
			ASel <= 1'b0;
			PCSel <= 2'b00;
			RegDst <= 2'b01;
			ALUSrc <= 1'b0; 
			MemRead <= 1'b0; 
			MemToReg <= 1'b0; 
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			jump <= 2'b00;
			if ( opCode == 6'b000101 && z == 0) 
				branch <= 1'b0; //branch if zero
			else 
				branch <= 1'b1;// otherwise will do ia+4
		end

		else
		case(opCode[5:3]) 
			3'b001: // For I-type opcode: addi, andi ori, xori 
			begin 
				ASel <= 1'b0;
				PCSel <= 2'b00;
				RegDst <= 2'b01;
				ALUSrc <= 1'b1; 
				MemRead <= 1'b0; 
				MemToReg <= 1'b0; 
				RegWrite <= 1'b1; 
				MemWrite <= 1'b0; 
				branch <= 1'b1;
				jump <= 2'b00;

				case(opCode[2:0])
					3'b000: //addi 
						ALUOp <= 5'b00000;
					3'b100: //andi 
						ALUOp <= 5'b11000;
					3'b101: //ori 
						ALUOp <= 5'b11110;
					3'b110: //xori 
						ALUOp <= 5'b10110;
					default: //For NOP initially set everything to zero.
					begin
						ALUOp <= 5'b11010;
						ASel <= 1'b1;
						PCSel <= 2'b11;
						RegDst <= 2'b11;
						ALUSrc <= 1'b0; 
						MemRead <= 1'b0; 
						MemToReg <= 1'b0; 
						RegWrite <= 1'b1; 
						MemWrite <= 1'b0;
						branch <= 1'b0;
						jump <= 2'b00;
					end
				endcase 
			end
			3'b100: //opcode [5:3]   
			begin 
				case(opCode[2:0])
					3'b011: // for lw 
					begin
						ALUOp <= 5'b00000; //add 
						ASel <= 1'b0;
						PCSel <= 2'b00;
						RegDst <= 2'b01;
						ALUSrc <= 1'b1;
						MemRead <= 1'b1; 
						MemToReg <= 1'b1; 
						RegWrite <= 1'b1; 
						MemWrite <= 1'b0; 
						branch <= 1'b1;
						jump <= 2'b00;
					end 
					default: //set everything to zero 
					begin
						ALUOp <= 5'b11010;
						ASel <= 1'b1;
						PCSel <= 2'b11;
						RegDst <= 2'b11;
						ALUSrc <= 1'b0; 
						MemRead <= 1'b0; 
						MemToReg <= 1'b0; 
						RegWrite <= 1'b1; 
						MemWrite <= 1'b0;
						branch <= 1'b0;
						jump <= 2'b00;

					end 
				endcase 
			end 
			3'b101: // opcode [5:3]  
			begin 
				case(opCode[2:0])
					3'b011: //sw
					begin
						ALUOp <= 5'b00000;//add	
						ASel <= 1'b0;
						PCSel <= 2'b00;
						RegDst <= 2'b00;
						ALUSrc <= 1'b1; 
						MemRead <= 1'b0; 
						MemToReg <= 1'b0;  
						RegWrite <= 1'b0; 
						MemWrite <= 1'b1;  
						branch <= 1'b1;
						jump <= 2'b00;

					end 
					default: //set everything to zero 
					begin
						ALUOp <= 5'b11010;
						ASel <= 1'b1;
						PCSel <= 2'b11;
						RegDst <= 2'b11;
						ALUSrc <= 1'b0; 
						MemRead <= 1'b0; 
						MemToReg <= 1'b0; 
						RegWrite <= 1'b1; 
						MemWrite <= 1'b0;
						branch <= 1'b0;
						jump <= 2'b00;

					end 
				endcase 
			end 
			default:
			begin
				ALUOp <= 5'b11010;
				ASel <= 1'b1;
				PCSel <= 2'b11;
				RegDst <= 2'b11;
				ALUSrc <= 1'b0; 
				MemRead <= 1'b0; 
				MemToReg <= 1'b0; 
				RegWrite <= 1'b1; 
				MemWrite <= 1'b0;
				branch <= 1'b0;
				jump <= 2'b00;

			end 
		endcase 		
	end	
endmodule
