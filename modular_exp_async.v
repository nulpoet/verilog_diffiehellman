`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:13 04/11/2012 
// Design Name: 
// Module Name:    modular_exp_async 
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

module modular_exp_async(
    input rst,
	 input clk,
	 input start,
    input [99:0] base,
    input [99+1:0] exp_in,
    input [99:0] prime,
    output reg [99:0] result,
	 output reg dirty0,
	 output reg dirty1,
	 output div_ready_out
    );


	reg state;
	reg dirty;
	
	reg [199:0] buffer;
	reg [99+1:0] exp;
	reg [99+1:0] exp_buf;
	
	
		// Inputs
	reg [15:0] dividend;
	reg [15:0] divider;
	reg div_start;
	
	// Outputs
	wire [15:0] quotient;
	wire [15:0] remainder;
	wire div_ready;

	assign div_ready_out = div_ready;

	// Instantiate the Unit Under Test (UUT)
	divider_async uut (
		.quotient(quotient), 
		.remainder(remainder), 
		.ready(div_ready), 
		.dividend(dividend), 
		.divider(divider), 
		.start(div_start), 
		.clk(clk),
		.rst(rst)
	);

	
	always @ (posedge start) begin
		
		if (start) begin
			$display("{exp} starting ............");
			
			if (state == 0)
				state = 1;
			else
				state = 0;
			$display("{exp} state = %d", state);
			
			if (state)
				dirty1 = 1;
			else
				dirty0 = 1;
			dirty = 1;
			
			
			exp = exp_in;
			buffer = 0;
			result = 1;
			$display("{exp} reseting with exp=%d, exp_in=%d, base=%d, prime=%d, result=%d, dirty0=%d, dirty1=%d", exp, exp_in, base, prime, result, dirty0, dirty1);
			if( exp == 0 ) begin
				exp_buf = 0;
				buffer[99:0] = 1;
			end
			else begin
				exp_buf = 1;
				buffer[99:0] = base;
			end
			// $display("buffer after reset : %d", buffer);
			
			
			
			while(dirty) begin
				if ((exp_buf<<1) > exp) begin
					//result = (result * buffer) % prime;
					dividend = (result * buffer);
					divider = prime;
					div_start = 1;
					while(div_ready == 0) begin					
					end
					div_start = 0;
					result = remainder;
					
					buffer = 0;
					exp = exp - exp_buf;
					
					if( exp == 0 ) begin
						exp_buf = 0;
						buffer[99:0] = 1;
					end
					else begin
						exp_buf = 1;
						buffer[99:0] = base;
					end
					$display("new exp = %d,  exp_buf = %d, result : %d", exp, exp_buf, result);
				end
				
				
				if(exp_buf == exp) begin
					//result = (result * buffer) % prime;
					dividend = (result * buffer);
					divider = prime;
					div_start = 1;
					while(div_ready == 0) begin					
					end
					div_start = 0;
					result = remainder;
					$display("final result : %d", result);
					
					dirty = 0;
					if (state)
						dirty1 = 0;
					else
						dirty0 = 0;
				end
				
				else begin
					buffer = buffer*buffer;
					if(buffer >= prime) begin
						$display("buffer = %d  excceeded prime = %d", buffer, prime);						
						
						//buffer = buffer % prime;
						dividend = buffer;
						divider = prime;
						div_start = 1;
						while(div_ready == 0) begin					
						end
						div_start = 0;
						buffer = remainder;
						
						$display("new buffer after modding = %d", buffer);
					end
					/*else
						$display("new buffer = %d", buffer);
					*/

					exp_buf = exp_buf << 1;
					$display("exp_buf = %d", exp_buf);
				end
			end // while ends
			
		end
	end
endmodule
