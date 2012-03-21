`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:34:37 02/07/2012
// Design Name:   lfsr
// Module Name:   C:/Documents and Settings/nc/lfsr_tb.v
// Project Name:  nc
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lfsr
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lfsr_tb;

	// Inputs
	reg clk;
	reg rst;
	reg ce;

	// Outputs
	wire lfsr_done;
	wire [12:0] lfsr;

	// Instantiate the Unit Under Test (UUT)
	lfsr uut (
		.clk(clk), 
		.rst(rst), 
		.lfsr_done(lfsr_done), 
		.lfsr(lfsr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100
		rst = 1;
		#100
		rst = 0;
		// Add stimulus here

	end
	
	always begin
	  #5 clk = ~clk; // Toggle clock every 5 ticks
	end
      
endmodule

