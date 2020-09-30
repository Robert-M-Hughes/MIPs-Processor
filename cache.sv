module cache(input logic clk, MemReadReady, MemReadDone, MemRead, MemWrite, MemWriteReady, 
			input logic [31:0] memAddr, memReadData, memWriteData, 
			output logic MemHit,
			output logic [31:0] cdata);  
			
	/*
	Directly Mapped cache with one-word 32 bit address entries entries is 32
	m=0 n=5
	logic for the cache is 56 because of three things, the tag the data and the valid bit

	*/
	logic [57:0] cache [31:0];
	logic [5:0] indexValue;
	logic [24:0] tagValue;
	logic [57:0] entry;
	logic valid;
	logic [4:0] readCount, missCount;
	logic [32:0] clkCount; 
	
	
	initial //initializes all of cache to be 0
	begin

		missCount <= 6'd0;
		readCount <= 6'd0; 
		clkCount <= 32'd0;

		cache[0] <= 0;
		cache[1] <= 0;
		cache[2] <= 0;
		cache[3] <= 0;
		cache[4] <= 0;
		cache[5] <= 0;
		cache[6] <= 0;
		cache[7] <= 0;
		cache[8] <= 0;
		cache[9] <= 0;
		cache[10] <= 0;
		cache[11] <= 0;
		cache[12] <= 0;
		cache[13] <= 0;
		cache[14] <= 0;
		cache[15] <= 0;
		cache[16] <= 0;
		cache[17] <= 0;
		cache[19] <= 0;
		cache[20] <= 0;
		cache[21] <= 0;
		cache[22] <= 0;
		cache[23] <= 0;
		cache[24] <= 0;
		cache[25] <= 0;
		cache[26] <= 0;
		cache[27] <= 0;
		cache[28] <= 0;
		cache[29] <= 0;
		cache[30] <= 0;
		cache[31] <= 0;


	end
	
	// This finds the tag and index 
	always_comb
	begin 
		indexValue <= memAddr[6:2];
		tagValue <= memAddr[31:7];//31-8 = 24
		
		entry <= cache[indexValue];
	
	
		if (entry[57] == 1'b1) 
		begin 
			valid <= 1'b1; 
			if(tagValue == entry[56:32]) // hit
			begin 
				cdata <= cache[indexValue]; // data grab
				MemHit <= 1'b1; 
				
			end 
			else // miss and stall
			begin 
				entry[56:32] <= tagValue;//get new tag
				//Read
				entry[31:0] <= memReadData; //data from mem
				if (MemReadDone != 1'b1) 
					MemHit <= 1'b0; 
				else 
					MemHit <= 1'b1;
			end			
		end 
		else //not valid
		begin 
			valid <= 1'b0; 
			entry[57] <= 1'b1; //set valid
			entry[56:32] <= tagValue;//new tag
			//Read
			entry[31:0] <= memReadData;  //data from mem
			if (MemReadDone != 1'b1) 
				MemHit <= 1'b0; 
			else 
				MemHit <= 1'b1; 
		
		end
	
		//Write
		if (MemWrite == 1'b1) 
		begin 
			valid <= 1'b1; 
			entry[57] <= 1'b1; 
			entry[56:32] <= tagValue;
			entry[31:0] <= memWriteData;//update write value
			MemHit <= 1'b0;
		end
		
		if (MemRead == 1'b0) 
			MemHit <= 1'b0; 
			
		//printing
		if ((MemHit == 1'b1 && MemRead == 1'b1 && MemReadReady == 1'b1) || (MemWriteReady == 1'b1 && MemWrite == 1'b1))
		begin
		/*$display("\nMemRead=%h, MemWrite=%h, MemHit=%h, indexValue=%h, entry=%h", MemRead, MemWrite, MemHit, indexValue,entry);
		for (int i = 0; i < 32; i++)
			$display("cache[%h]=%h",i, cache[i]);
		*/

		
		end
	end


	//check the cache for the data an put the entry in the cache if ready
	always_ff @(posedge clk)
	begin 
		if (MemRead == 1'b1 && MemReadReady == 1'b1)
			cache[indexValue] <= entry;	
		if (MemWrite == 1'b1 && MemWriteReady == 1'b1) 
			cache[indexValue] <= entry;
	end
	
	// To info to print so we can get stats on the data
	// reads from memory
	/*always_ff@(posedge MemRead) 
	begin 
		readCount <= readCount + 6'd1; 
		$display("Read count = %d", readCount);
	end 
	
	// misses in he cache
	always_ff@(posedge MemReadDone) 
	begin 
		missCount <= missCount + 6'd1;
		$display("Miss count = %d", missCount);
	end 
	
	// clock counts
	
	always_ff@(posedge clk) 
	begin 
		clkCount <= clkCount + 6'd1;
		$display("clk count = %d", clkCount);
	end 
*/

endmodule