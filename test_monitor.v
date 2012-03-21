`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:46:51 02/02/2012
// Design Name:   monitor
// Module Name:   C:/Documents and Settings/nc/monitor_test.v
// Project Name:  nc
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: monitor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module monitor_test;

	// Inputs
	reg rst;
	reg clk;
	
	wire synced;
	wire [31:0] sync_count;
	wire [63:0] iter_count;

	// Instantiate the Unit Under Test (UUT)
	monitor uut_monitor (
		.clk(clk),
		.rst(rst),
		.synced(synced),
		.sync_count(sync_count),
		.iter_count(iter_count)
	);


	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		
		#5;
      rst = 1;
		
		#20
		rst = 0;
		
		// Add stimulus here
	end

  	always begin
		#5 clk = ~clk; // Toggle clock every 5 ticks
	end

endmodule

