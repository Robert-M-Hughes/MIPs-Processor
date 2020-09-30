module beta(input logic clk, reset, irq, MemReadReady, MemWriteDone, 
			input logic [31:0] id, memReadData, 
			output logic [31:0] ia, memAddr, memWriteData, 
			output logic MemRead, MemWrite, MemReadDone, MemHit, MemWriteReady);

	
	//signal declarations
	logic z,v,n;
	logic RegWrite, ALUSrc, ASel, MemToReg, branch, PC31;
	logic [1:0] PCSel, RegDst, jump;
	logic [31:0] wdata, radata, data2, data1, j_Mux, A2, cdata, pcia; 
	logic [4:0] ALUOp;
	
	//module declarations
    alu xalu(.A(data1), .B(A2), .ALUOp(ALUOp), .Y(memAddr), .z(z), .v(v), .n(n));
	
    
    pc xpc(.clk(clk), .reset(reset), .irq(irq), .PC31(PC31), .j_Mux(j_Mux),.ia(ia), .PCSel(PCSel));
	
    
    regfile xregfile(.clk(clk), .RegWrite(RegWrite), .RegDst(RegDst), .ra(id[25:21]), 
		.rb(id[20:16]), .rc(id[15:11]),.wdata(wdata), .radata(radata), .rbdata(memWriteData));
	
    
    ctl xctl(.reset(reset), .z(z), .irq(irq), .PC31(PC31), .opCode(id[31:26]),.funct(id[5:0]), .RegDst(RegDst), 
		.PCSel(PCSel),.ALUSrc(ALUSrc), .RegWrite(RegWrite), .ASel(ASel), .jump(jump), .branch(branch),
		.MemWrite(MemWrite), .MemRead(MemRead), .MemToReg(MemToReg), .ALUOp(ALUOp));
		

	branchJump xbranch(.clk(clk), .ia(ia), .bSel(branch), .opCode(id[31:26]),.jSel(jump),
		.MemReadDone(MemReadDone), .MemReadReady(MemReadReady), .id(id), .MemWrite(MemWrite), 
		.data2(data2), .j_Mux(j_Mux), .radata(radata), .MemHit(MemHit), .MemRead(MemRead), 
		.MemWriteDone(MemWriteDone), .MemWriteReady(MemWriteReady));


	cache xcache(.clk(clk), .memAddr(memAddr), .memReadData(memReadData), .MemReadDone(MemReadDone), 
		.MemReadReady(MemReadReady), .MemHit(MemHit), .cdata(cdata), .MemRead(MemRead), 
		.MemWrite(MemWrite), . memWriteData(memWriteData), .MemWriteReady(MemWriteReady));


	assign PC31 = ia[31];

	//CACHE	
	//For Reading 
	always_ff @(posedge clk)
	begin 
		if (MemReadReady == 1'b1) 
			MemReadDone <= 1'b1; 
		else 
			MemReadDone <= 1'b0;
	end
	
	//For writing 
	always_ff @(posedge clk)
	//MemWriteDone indicates when write has completed
	// One clock cycle after setting MemWriteDone to 1, select next instruction. 
	begin 
		if (MemWrite == 1'b1) 
		begin 
			if (MemWriteDone == 1'b1) 
				MemWriteReady <= 1'b0; 
			else 
				MemWriteReady <= 1'b1; 
		end 
		else 
			MemWriteReady <= 1'b0;			
	end
	
	
	

	//calculates the output and this is updated to work with the cache
	always_comb
	begin 

		if (MemToReg) 
			wdata <= cdata;
		else 
			wdata <= memAddr; 
	end 
	
	//calculates value going into ALUSrc mux if value sign extended or zero paded
		always_comb
	begin 
		
		if(id[31:26] == 6'b100011 || id[31:26] == 6'b101011 || id[31:26] == 6'b001000 || id[31:26] == 6'b000100 || id[31:26] == 6'b000101)
			data2 <= {{16{id[15]}},id[15:0]}; 
		// zero pad for immediates 
        //zero pad for shifting
		else if(id[31:26] == 6'd0 && (id[5:0] == 6'd0 || id[5:0] == 6'b000010 || id[5:0] == 6'b000011)) 
			data2 <= { 27'd0,id[10:6]};
		//sign extend for lw/sw  addi
		else
			data2 <= {16'd0,id[15:0]};	
	end
	
	always_comb
	begin
		//ALUSrc mux logic 
		if (ALUSrc)
			A2 <= data2;
		else 
			A2 <= memWriteData;
			
	end 
	
	always_comb 
	begin 
		//ASel mux logic 
		if (ASel == 1'b0)
			data1 <= radata; //data if 1 
		else 
		begin
			data1 <= ia + 32'd4;	//deleted ia + 32'd4
			//PC31 <= data1[31];
		end
	end 
endmodule 
