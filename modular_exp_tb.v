`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:15:08 03/21/2012
// Design Name:   modular_exp
// Module Name:   C:/Documents and Settings/rohit/My Documents/Dropbox/Work/verilog_diffiehellman/modular_exp_tb.v
// Project Name:  verilog_diffiehellman
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: modular_exp
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module modular_exp_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [99:0] base;
   reg [99+1:0] exp;
   reg [99:0] prime;
	 
	// Outputs
	wire [99:0] result;
	wire dirty;

	// Instantiate the Unit Under Test (UUT)
	modular_exp uut (
		.clk(clk),
		.rst(rst),
		.base(base),
		.exp_in(exp),
		.prime(prime),
		.result(result),
		.dirty(dirty)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		base = 5;
		exp = 23;
		prime = 23;
		
		// Wait 100 ns for global reset to finish
		#100
		rst = 1;
		#20
		rst = 0;
		// Add stimulus here
	end
	
	always begin
	  #5 clk = ~clk; // Toggle clock every 5 ticks
	end
endmodule

