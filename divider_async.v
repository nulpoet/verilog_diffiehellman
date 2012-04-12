`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:38 04/11/2012 
// Design Name: 
// Module Name:    divider_async 
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
module divider_async(quotient,remainder,ready,dividend,divider,start,clk,rst);
   
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
   reg [15:0]    remainder;
	
   reg [4:0]     bitc; 
   reg           ready;
	
   reg pre_clk, pre_rst, pre_start;

   //always @(posedge clk or negedge clk or posedge rst or posedge start or negedge start) begin			
	/*always @(posedge rst) begin
		$display("Divider initial reset");
		ready = 1;
		pre_clk = 0;
		pre_start = 0;
	end
	*/
	
	// always @(posedge clk or negedge clk) begin
	always @(posedge clk or posedge rst) begin
		
		if (rst) begin
			$display("Divider initial reset");
			ready = 1;
			pre_clk = 0;
			pre_start = 0;
		end
		else begin 		
		//if (!rst) begin
			if(start == !pre_start) begin
				if(start) begin
					bitc = 16;
					ready = 0;
					quotient = 0;
					dividend_copy = {16'd0,dividend};
					divider_copy = {1'b0,divider,15'd0};
					$display("Divider started");
				end
				else begin
					$display("Divider stopped");
				end
				pre_start = start;
			end
			
			
		   //if(clk == !pre_clk) begin // not needed
				if(clk) begin          // not needed
				
					//$display(".....clk ticks..... with  start = %d", start);					
					//if (start==1 && bitc!=0) begin
					if (bitc!=0) begin
						//$display("Divider iterating at %d", bitc);
						diff = dividend_copy - divider_copy;

						quotient = quotient << 1;

						if( !diff[31] ) begin
							dividend_copy = diff;
							quotient[0] = 1'd1;
						end

						divider_copy = divider_copy >> 1;
						bitc = bitc - 1;
						if (bitc == 0) begin
							ready = 1;
							$display("Divider done");
						end
					end
					remainder[15:0] = dividend_copy[15:0];
				end
				/*
				else begin
					//$display("...clock negates");
				end
				pre_clk = clk;
				*/
			//end
			//pre_clk = clk;
		end
		
	end

endmodule