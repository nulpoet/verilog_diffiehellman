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

	//reg [2:0] state;

	// Inputs
	reg clk;
	reg rst;
	reg [99:0] base;
   reg [99+1:0] exp;
   reg [99:0] prime;
	 
	// Outputs
	wire [99:0] result;
	wire dirty0;
	wire dirty1;

	// Instantiate the Unit Under Test (UUT)
	modular_exp uut (
		.clk(clk),
		.rst(rst),
		.base(base),
		.exp_in(exp),
		.prime(prime),
		.result(result),
		.dirty0(dirty0),
		.dirty1(dirty1)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		base = 5;
		exp = 23;
		prime = 23;
		
		//state = 0;
		
		// Wait 100 ns for global reset to finish
		#100
		rst = 1;
		#10
		rst = 0;
		
		#100
		rst = 1;
		#10
		rst = 0;
		//state = 1;
		// Add stimulus here
	end
	
	always begin
	  #5 clk = ~clk; // Toggle clock every 5 ticks
	end
	
	/*
	always begin
		if(state == 1) begin
			#20
			rst = 1;
			#10
			rst = 0;
			if(~dirty) begin
				$display("done with 2nd computaion");
			end
		end
	end
	*/
endmodule

