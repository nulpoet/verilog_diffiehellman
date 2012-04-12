`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:58 02/02/2012 
// Design Name: 
// Module Name:    partner 
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
module partner(
	input rst,
	input clk,
   input [99:0] prime_in,
	input [99:0] base_in,
	input [99:0] pub_key_in,
	input [2:0] ctrl,
	input [2:0] partner_no,
	output reg [99:0] pub_key_my,
	output reg dirty0,
	output reg dirty1
   );
	
	parameter LEN = 100;
	integer ii, jj, kk;

	reg state;

	reg [LEN-1:0] prime;
	reg [LEN-1:0] base;
	reg [2*LEN-1:0] secret;
	reg [99:0] common_key;
	
	reg [2:0] prev_ctrl;

	wire lfsr_done;
	wire [12:0] lfsr_val;
	lfsr uut_lfsr  (
			.clk(clk),
			.rst(rst),
			.seed_no(partner_no),
			.lfsr_done(lfsr_done),
			.lfsr(lfsr_val)
		);

	// Inputs
	//reg clk;
	reg start_exp;
	reg [99:0] base_exp;
	reg [99+1:0] exp;
	//reg [99:0] prime;
	 
	// Outputs
	wire [99:0] result_exp;
	wire dirty0_exp;
	wire dirty1_exp;

	modular_exp_async uut_mod_exp (
			.rst(rst),
			.clk(clk),
			.start(start_exp),
			.base(base_exp),
			.exp_in(exp),
			.prime(prime),
			.result(result_exp),
			.dirty0(dirty0_exp),
			.dirty1(dirty1_exp)
		);

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			prev_ctrl = 3'b000;
			
			prime = prime_in;
			base = base_in;
			secret = 0;
						
			start_exp = 0;
			$display("---- global reset at partner_no : %d  with   prime : %d | base : %d ----", partner_no, prime, base);
		end
		
		else begin
			//$display("{%d} : clk tick", partner_no);
			if (ctrl[0] & ~prev_ctrl[0]) begin
				state = 0;
				dirty0 = 1;			
				$display("---- generate sectret key reset----");
			end
			else if (ctrl[1] & ~prev_ctrl[1]) begin
				state = 0;
				dirty1 = 1;			
				$display("---- generate common key reset----");
			end
			
			//$display("ctrl : %b | prev_ctrl : %b   at partner_no : %d ", ctrl, prev_ctrl, partner_no);
			prev_ctrl = ctrl;
			
			if (ctrl == 3'b001) begin // generate secret key
				if(dirty0) begin
					//$display("{%d} computing secret & public key  with state = %d", partner_no, state);
					if(state == 0) begin
						secret = 0;
						secret[12:0] = lfsr_val[12:0];
						exp = secret;
						base_exp = base;
						
						start_exp = 1;
						$display("{%d} secret key : %d", partner_no, secret);
						$display("{%d} Started exp", partner_no);
						state = 1;					
					end 
					else if(state == 1) begin
						start_exp = 0;
						//$display("{%d} Stopped exp", partner_no);
						if (dirty0_exp == 0) begin
							pub_key_my = result_exp;
							$display("************* {%d} pub_key_my = %d", partner_no, pub_key_my);
							dirty0 = 0;
							state = 0;
						end					
					end 
					else begin
						$display("Impossiblr case... something is broken !");
					end
				end
			end
			
			else if (ctrl == 3'b010) begin // generate common key
				if (dirty1) begin
					if(state == 0) begin
						exp = secret;
						base_exp = pub_key_in;
						
						start_exp = 1;				
						$display("{%d} state 0 Started exp for common key", partner_no);
						state = 1;
					end 					
					else if(state == 1) begin
						start_exp = 0;
						//$display("{%d} state 2 Stopped exp", partner_no);
						if (dirty1_exp == 0) begin
							common_key = result_exp;
							$display("*************** {%d} common_key : %d", partner_no, common_key);
							dirty1 = 0;
							state = 0;
						end					
					end 
					else begin
						$display("Impossiblr case... something is broken !");
					end
				end
			end 
			
			else if (ctrl == 3'b000) begin
				$display("NO-OP");
			end 
			
			else begin
				$display("Impossible case.. Something is broken !");
			end
		end
	end

endmodule
