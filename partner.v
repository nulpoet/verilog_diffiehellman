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
	output reg dirty
	/*input [6-1:0] feed,
   input out_other,
	input [2:0] ctrl,
	input [2:0] partner_no,
	output out,
	output [2-1:0] deltas,
	output reg dirty */
    );


/*
parameter K = 2;
parameter N = 3;
parameter L = 2;
parameter miunus_L = -2;
parameter L_plus_1 = 3;
parameter miunus_L_plus_1 = -3;
parameter W_WIDTH = 13;

integer ii, jj, kk;

reg w [0:(K*N-1)][0:12];
reg [K-1:0] d;
reg myout;

reg [2:0] prev_ctrl;

reg [K*N-1:0] state; // Ideally should of length ceiling(K*N-1)
reg [K*N-1:0] state_K; // Ideally should of length ceiling(K*N-1)
reg [K*N-1:0] state_N; // Ideally should of length ceiling(K*N-1)
reg signed [12:0] temp_wi;

wire lfsr_done;
wire [12:0] lfsr_val;
lfsr uut_lfsr  (
		.clk(clk), 
		.rst(rst),
		.seed_no(partner_no),
		.lfsr_done(lfsr_done),
		.lfsr(lfsr_val)
	);

reg signed [12:0] acc_feed;
reg signed [12:0] acc_value;
*/

parameter LEN = 100;

integer ii, jj, kk;

reg [LEN-1:0] prime;
reg [LEN-1:0] base;
reg [2*LEN-1:0] secret;
reg [99:0] my_pub_key,

reg [99:0] exp_buf,

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

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		prev_ctrl = 3'b000;
		
		prime = prime_in;
		base = base_in;
		sectret = 0;
		$display("---- global reset at partner_no : %d  with   prime : %d | base : %d ----", partner_no, prime, base);
	end
	
	else begin
		
		if (ctrl[0] & ~prev_ctrl[0]) begin
			//state = 0;
			dirty = 1;
			
			secret = 0;
			secret[13:0] = lfsr_val[13:0];
			my_pub_key = base;
			exp_buf = 1;
			$display("---- generate sectret key ----");
		end
		else if (ctrl[1] & ~prev_ctrl[1]) begin
			if(ctrl != 3'b111) begin
				state_N = 0;
				state_K = 0;
				dirty = 1;
				acc_feed = 0;
				acc_value = 0;
				$display("---- compute reset----");
			end
		end
		else if (ctrl[2] & ~prev_ctrl[2]) begin
			if(ctrl != 3'b111) begin
				state_N = 0;
				state_K = 0;
				dirty = 1;
				$display("---- learn reset----");
			end
		end
		
		//$display("ctrl : %b | prev_ctrl : %b   at partner_no : %d ", ctrl, prev_ctrl, partner_no);
		prev_ctrl = ctrl;
		
	
		if (ctrl == 3'b001) begin
			if (dirty) begin
				temp_wi = lfsr_val[12:0] % (L_plus_1);
				if (~lfsr_val[3]) begin
					temp_wi = temp_wi * -1;
				end

				for(ii=0; ii<W_WIDTH; ii=ii+1) begin
					w[state][ii] = temp_wi[ii];
				end

				$display("state : %d", state);
				$display("temp_wi : %d", temp_wi);
				//$display("temp_wi bits : %b", temp_wi);
				$display("lfsr_val : %d", lfsr_val);
				$display("-------------");

				state = (state + 1);
				if (state == K*N)
					dirty = 0;
			end
		end
		
		else if (ctrl == 3'b010) begin // compute
			if (dirty) begin
				for(ii=0; ii<W_WIDTH; ii=ii+1) begin
					acc_feed[ii] = w[state_K*N + state_N][ii];
				end
				
				if(feed[state_K*N + state_N])
					acc_value = acc_value + acc_feed;
				else
					acc_value = acc_value - acc_feed;
				
				//$display("acc_feed : %b, acc_value : %b, add/sub : %b, state_K*N + state_N : %d", acc_feed, acc_value, feed[state_K*N + state_N], (state_K*N+state_N));
				
				state_N = state_N + 1;
				
				if (state_N == N) begin
					$display("[%d] for d[%d] acc_value = %d", partner_no, state_K, acc_value);
					// bit 0 maps to  1 &
					// bit 1 maps to -1
					// xoring 0 keeps parity same.. similar to multiplication of 1 with (1 or 0)
					if (acc_value[12] == 0)
						d[state_K] = 1'b0;
					else
						d[state_K] = 1'b1;
					$display("[%d] d[%d] = %b", partner_no, state_K, d[state_K]);
					state_N = 0;
					acc_value = 0;
					
					state_K = state_K + 1;
					if (state_K == K) begin
						myout = d[0];
						for(ii=1; ii<K; ii=ii+1) begin
							if (myout)
							myout = myout ^ d[ii];
						end
						//$display("[%d] d = %b", partner_no, d[0]);
						dirty = 0;
					end
				end
			end
		end
		
		else if (ctrl == 3'b100) begin // learn
			if (myout == out_other) begin
				$display("[%d] w : ", partner_no);
				for(ii=0; ii<K; ii=ii+1) begin
					$display("[%d] d[%d] = %d, myoutput : %d", partner_no, ii, d[ii], myout);
					if (d[ii] == myout) begin
						for(jj=0; jj<N; jj=jj+1) begin
							for (kk=0; kk<W_WIDTH; kk=kk+1) begin
								temp_wi[kk] = w[ii*N+jj][kk];
							end
							//$display("[%d]  w[%d][%d] from %d", partner_no, ii, jj, temp_wi);
							$display("%d", temp_wi);
							if (feed[ii*N+jj])
								temp_wi = temp_wi + 1;
							else
								temp_wi = temp_wi - 1;
							
							//$display("... %b", temp_wi);
							if (temp_wi[12] == 1) begin
								//$display("-- miunus_L_plus_1 : %d", miunus_L_plus_1);
								if (temp_wi == miunus_L_plus_1)
									temp_wi = miunus_L;
							end
							else begin
								//$display("++ L_plus_1 : %d", L_plus_1);
								if (temp_wi == L_plus_1)
									temp_wi = L;
							end
							
							//$display("...to %d given feed[%d] : %d", temp_wi, ii*N+jj, feed[ii*N+jj]);
							$display("%d [%d]", temp_wi, feed[ii*N+jj]);
							for (kk=0; kk<W_WIDTH; kk=kk+1) begin
								w[ii*N+jj][kk] = temp_wi[kk];
							end
						end
					end
				end
			end
			else
				$display("no learning");
		end
		
		else if (ctrl == 3'b111) begin
			$display("---- Synced at partner_no %d----", partner_no);
			for (ii=0; ii<K; ii=ii+1) begin
				for (jj=0; jj<N; jj=jj+1) begin
					for (kk=0; kk<W_WIDTH; kk=kk+1) begin
						temp_wi[kk] = w[ii*N+jj][kk];
					end
					$display("%d", temp_wi);
				end
			end
		end
		
		else
			; // impossible case
	end
end

assign out = myout;
//assign weights = w;
assign deltas = d;

endmodule
