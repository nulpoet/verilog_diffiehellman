`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:16:29 03/31/2012
// Design Name:   divider
// Module Name:   C:/Documents and Settings/rohit/My Documents/Dropbox/Work/verilog_diffiehellman/divider_tb.v
// Project Name:  verilog_diffiehellman
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: divider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module divider_tb;

	// Inputs
	reg [15:0] dividend;
	reg [15:0] divider;
	reg start;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] quotient;
	wire [15:0] remainder;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	divider uut (
		.quotient(quotient), 
		.remainder(remainder), 
		.ready(ready), 
		.dividend(dividend), 
		.divider(divider), 
		.start(start), 
		.clk(clk),
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		dividend = 50;
		divider = 23;
		//start = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 1;
		#100
		rst = 0;
		// Add stimulus here
		#100;
      start = 1;
		#100
		start = 0;
		
	end

	always begin
	  #5 clk = ~clk; // Toggle clock every 5 ticks
	end


endmodule

