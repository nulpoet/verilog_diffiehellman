`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:13:49 03/31/2012 
// Design Name: 
// Module Name:    divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module divider(quotient,remainder,ready,dividend,divider,start,clk,rst);
   
   input [15:0]  dividend,divider;
   input         start, clk, rst;
   output        quotient,remainder;
   output        ready;

//  """"""""|
//     1011 |  <----  dividend_copy
// -0011    |  <----  divider_copy
//  """"""""|    0  Difference is negative: copy dividend and put 0 in quotient.
//     1011 |  <----  dividend_copy
//  -0011   |  <----  divider_copy
//  """"""""|   00  Difference is negative: copy dividend and put 0 in quotient.
//     1011 |  <----  dividend_copy
//   -0011  |  <----  divider_copy
//  """"""""|  001  Difference is positive: use difference and put 1 in quotient.
//            quotient (numbers above)   


   reg [15:0]    quotient;
   reg [31:0]    dividend_copy, divider_copy, diff;
   reg [15:0]   remainder;
	
   reg [4:0]     bitc; 
   reg          ready;
	
   //initial bitc = 0;

   always @( posedge clk ) begin
	  if (rst)
		  ready = 1;
     if( start ) begin
        bitc = 16;
		  ready = 0;
        quotient = 0;
        dividend_copy = {16'd0,dividend};
        divider_copy = {1'b0,divider,15'd0};

     end else begin
		  if (ready == 0) begin
			  diff = dividend_copy - divider_copy;

			  quotient = quotient << 1;

			  if( !diff[31] ) begin
				  dividend_copy = diff;
				  quotient[0] = 1'd1;
			  end

			  divider_copy = divider_copy >> 1;
			  bitc = bitc - 1;
			  if (bitc == 0)
				 ready = 1;
		  end
     end
	  remainder[15:0] = dividend_copy[15:0];
	 end
	 
	 

endmodule