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
			result = 1;
			$display("buffer after reset : %d", buffer);
		end
		else begin
			if(dirty) begin
				if ((exp_buf<<1) > exp) begin
					$display("exp_buf= %d*2=%d > exp= %d", exp_buf, exp_buf<<1, exp);
					result = (result * buffer) % prime;
					
					buffer = 0;
					buffer[99:0] = base;
					exp = exp - exp_buf;
					exp_buf = 1;
					$display("new exp = %d,  exp_buf = %d, result : %d", exp, exp_buf, result);
				end
				
				if(exp_buf == exp) begin
					result = (result * buffer) % prime;
					dirty = 0;
					$display("final result : %d", result);
				end
				
				buffer = buffer*buffer;
				if(buffer >= prime) begin
					$display("buffer = %d  excceeded prime = %d", buffer, prime);
					//buffer = buffer - prime;
					buffer = buffer % prime;
					$display("new buffer after modding = %d", buffer);
				end
				else
					$display("new buffer = %d", buffer);

				exp_buf = exp_buf << 1;
				$display("exp_buf = %d", exp_buf);				
			end
		end
	end
endmodule
