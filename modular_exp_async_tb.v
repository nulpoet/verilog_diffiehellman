`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:41:43 04/11/2012
// Design Name:   modular_exp_async
// Module Name:   C:/Documents and Settings/rohit/My Documents/Dropbox/Work/MTP/verilog_diffiehellman/modular_exp_async_tb.v
// Project Name:  verilog_diffiehellman
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: modular_exp_async
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module modular_exp_async_tb;

	// Inputs
	reg rst;
	reg clk;
	reg start;
	reg [99:0] base;
	reg [100:0] exp_in;
	reg [99:0] prime;

	// Outputs
	wire [99:0] result;
	wire dirty0;
	wire dirty1;
	wire div_ready_out;

	// Instantiate the Unit Under Test (UUT)
	modular_exp_async uut (
		.rst(rst), 
		.clk(clk), 
		.start(start), 
		.base(base), 
		.exp_in(exp_in), 
		.prime(prime), 
		.result(result), 
		.dirty0(dirty0), 
		.dirty1(dirty1),
		.div_ready_out(div_ready_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		base = 5;
		exp_in = 23;
		prime = 23;
		
		//state = 0;
		
		// Wait 100 ns for global reset to finish
		#100
		rst = 1;
		#50
		rst = 0;
		
		#100
		start = 1;
		#10
		start = 0;
		
		/*
		#300
		start = 1;
		#10
		start = 0;
		*/
	end
	
	always begin
	  #5 clk = ~clk; // Toggle clock every 5 ticks
	end
      
endmodule

