`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:31:53 02/07/2012 
// Design Name: 
// Module Name:    lfsr 
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
module lfsr(
        input clk,
        input rst,
		  input [2:0] seed_no,
        output reg lfsr_done,
		  output reg [12:0] lfsr
		  );
	
	//reg [12:0] lfsr;
	wire d0,lfsr_equal;
	
	reg ce = 1'b1;
	
	xnor(d0,lfsr[12],lfsr[3],lfsr[2],lfsr[0]);
	assign lfsr_equal = (lfsr == 13'h220);
	
	always @(posedge clk or posedge rst) begin
		 if(rst) begin
			  $display("seed_no : %d", seed_no);
			  if (seed_no == 1)
					lfsr <= -2886;
			  else if (seed_no == 2)
					lfsr <= 1702;
					//lfsr <= -2376;
			  else
					lfsr <= 0;
			  lfsr_done <= 0;
		 end
		 else begin
			  if(ce)
					lfsr <= lfsr_equal ? 13'h0 : {lfsr[11:0],d0};
			  lfsr_done <= lfsr_equal;
		 end
	end
endmodule