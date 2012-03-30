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
	 output reg dirty0,
	 output reg dirty1
    );


	reg state;
	reg dirty;
	
	reg pre_rst;
	
	reg [199:0] buffer;
	reg [99+1:0] exp;
	reg [99+1:0] exp_buf;
	always @ (posedge clk /*or posedge rst*/) begin
		//$display("{exp} rst : %d ............", rst);
		if (rst) begin
			//$display("{exp} reseting ............");
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
		end
		else begin
			//$display("non reset ...............");
			
			if(dirty) begin
				//$display("{exp} dirty true");
				if ((exp_buf<<1) > exp) begin
					//$display("exp_buf= %d*2=%d > exp= %d", exp_buf, exp_buf<<1, exp);
					result = (result * buffer) % prime;
					
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
					//$display("new exp = %d,  exp_buf = %d, result : %d", exp, exp_buf, result);
				end
				
				if(exp_buf == exp) begin
					result = (result * buffer) % prime;
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
						//$display("buffer = %d  excceeded prime = %d", buffer, prime);						
						buffer = buffer % prime;
						//$display("new buffer after modding = %d", buffer);
					end
					/*else
						$display("new buffer = %d", buffer);
					*/

					exp_buf = exp_buf << 1;
					//$display("exp_buf = %d", exp_buf);
				end
			end
		end
	end
endmodule
