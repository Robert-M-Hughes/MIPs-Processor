# Script to run testbench

# Check for valid parameter
set readTestTypes {READ RMULTI}
set writeTestTypes {WB WBMULTI WT WTMULTI}
if {[lsearch $readTestTypes $1] >= 0 || [lsearch $writeTestTypes $1] >= 0} {
	# Valid input
	# Compile Beta
	vlog -reportprogress 300 -work work bool.sv
	vlog -reportprogress 300 -work work arith.sv
	vlog -reportprogress 300 -work work comp.sv
	vlog -reportprogress 300 -work work shift.sv
	vlog -reportprogress 300 -work work alu.sv
	vlog -reportprogress 300 -work work pc.sv
	vlog -reportprogress 300 -work work branchJump.sv
	vlog -reportprogress 300 -work work -suppress 7061 regfile.sv
	vlog -reportprogress 300 -work work -suppress 7061 cache.sv
	vlog -reportprogress 300 -work work ctl.sv
	vlog -reportprogress 300 -work work beta.sv
			
	### ADD YOUR DESIGN FILES HERE FOR COMPILATION ###
	# vlog -reportprogress 300 -work work <yourfilename>.sv

	# Compile Testbench
	vlog -sv -reportprogress 300 -work work tests/imem5.sv
	vlog -sv -reportprogress 300 -work work tests/dmem5.sv

	# Check if read or read/write
	if {[lsearch $readTestTypes $1] >= 0} {
		# Simulate
		vlog -sv -reportprogress 300 -work work tests/testBeta5_read.sv
		vsim -t 1ps -L work -voptargs="+acc" -gtestFileName="tests/lab5test.txt" -gnumTests=81 -gtestType=$1 testBeta5_read

	} else {
		# Simulate
		vlog -sv -reportprogress 300 -work work tests/testBeta5_write.sv
		vsim -t 1ps -L work -voptargs="+acc" -gtestFileName="tests/lab5test.txt" -gnumTests=81 -gtestType=$1 testBeta5_write
	
	}
	
	do tests/opRadix.txt
	do tests/funcRadix.txt
	do tests/regRadix.txt

	# Add waves
	add wave -label Clk clk
	add wave -label Reset reset
	add wave -label IRQ irq
	add wave -radix hex -label IA ia
	add wave -radix hex -label ID id
	add wave -radix OP_LABELS -label OpCode {id[31:26]}
	add wave -radix FUNC_LABELS -label Funct {id[5:0]}
	add wave -radix REG_LABELS -label Rs {id[25:21]}
	add wave -radix REG_LABELS -label Rt {id[20:16]}
	add wave -radix REG_LABELS -label Rd {id[15:11]}
	add wave -radix hex -label MemAddr memAddr
	add wave -radix hex -label MemReadData memReadData
	add wave -radix hex -label MemWriteData memWriteData
	add wave -label MemWrite MemWrite
	add wave -label MemRead MemRead
	
	#### Add your debug signals here ####
	add wave -label MemReadReady MemReadReady
	add wave -label MemReadDone MemReadDone
	add wave -label MemHit MemHit
	add wave -label MemWriteReady MemWriteReady
	add wave -label MemWriteDone MemWriteDone
	#add wave -radix hex -label pcia pcia 	
	add wave -radix hex dutBeta/xcache/*
	add wave -radix hex dutBeta/xpc/*
	add wave -radix hex dutBeta/xbranch/*
	add wave -radix hex dutBeta/xctl/*
	add wave -radix hex dutBeta/xregfile/*

	# Plot signal values
	view structure
	view signals
	run -a
	
} else {
	puts -nonewline {Error in calling test.  Make sure you use a valid test type (case matters):  }
	puts $testTypes
}