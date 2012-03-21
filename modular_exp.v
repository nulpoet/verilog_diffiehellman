`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:25:43 03/21/2012 
// Design Name: 
// Module Name:    modular_exp 
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
module modular_exp(
    input clk,
    input rst,
    input [99:0] base,
    input [99+1:0] exp_in,
    input [99:0] prime,
    output reg [99:0] result,
	 output reg dirty
    );

	reg [199:0] buffer;
	reg [99+1:0] exp;
	reg [99+1:0] exp_buf;
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			dirty = 1;
			exp = exp_in;
			buffer = 0;
			buffer[99:0] = base;
			exp_buf = 1;
			result = 0;
			$display("buffer after reset : %b", buffer);
		end
		else begin
			if(dirty) begin
				if ((exp_buf<<1) > exp) begin
					result = result + buffer;
					
					buffer = 0;
					buffer[99:0] = base;
					exp = exp - exp_buf;
					exp_buf = 1;
				end
				else begin
					exp_buf = exp_buf << 1;
				end
				
				buffer = buffer*buffer;
				if(buffer >= prime) begin
					buffer = buffer - prime;
				end
				
				if(exp_buf == exp) begin
					result = result + buffer;
					dirty = 0;
				end			
			end
		end
	end
endmodule
