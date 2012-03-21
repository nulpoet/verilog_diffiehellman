`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:31:55 02/06/2012
// Design Name:   partner
// Module Name:   C:/Documents and Settings/nc/partner_tb.v
// Project Name:  nc
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: partner
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module partner_tb;

	// Inputs
	reg rst;
	reg clk;
	reg [6-1:0] feed;
	reg out_other;
	reg [2:0] ctrl;
	reg [2:0] partner_no;

	// Outputs
	wire out;
	wire [2-1:0] deltas;
	wire dirty;

	//integer weights[5:0];

	// Instantiate the Unit Under Test (UUT)
	partner uut (
		.rst(rst), 
		.clk(clk), 
		.feed(feed),
		.out_other(out_other),
		.ctrl(ctrl),
		.partner_no(partner_no),
		
		.out(out),
		
		.deltas(deltas),
		.dirty(dirty)/*,
		.weights(weights)*/
	);

	initial begin
		// Initialize Inputs
		
		$display("negative mod : %d", (-42) % -4 );
		
		rst = 0;
		clk = 0;
		feed = 6'b110100;
		out_other = 1;
		partner_no = 3'b001;
		
		// Wait 100 ns for global reset to finish
		#5;
      rst = 1;
		
		#100
		rst = 0;
		
		ctrl = 3'b001;
		#60
		
		ctrl = 3'b010;		
		#60
		
		ctrl = 3'b100;
		#10
		ctrl = 3'b000;
	end
	
	always begin
	  #5 clk = ~clk; // Toggle clock every 5 ticks
	end
   
endmodule