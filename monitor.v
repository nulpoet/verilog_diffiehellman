`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:43 02/02/2012 
// Design Name: 
// Module Name:    monitor 
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
module monitor(
	 input clk,
    input rst,
    output reg synced/*,
	 output reg [31:0] sync_count,
	 output reg [63:0] iter_count*/
	);

	//parameter K = 2;
	//parameter N = 3;
	//parameter SYNC_COUNT_LIMIT = 10;
	
	//integer ii;

	//reg [31:0] sync_count;
	//reg [63:0] iter_count;
	reg [7:0] state;

	reg [2:0] seed_no;
	
	/*wire lfsr_done;
	wire [12:0] lfsr_val;
	lfsr uut_lfsr (
			.clk(clk), 
			.rst(rst),
			.seed_no(seed_no),
			.lfsr_done(lfsr_done),
			.lfsr(lfsr_val)
		);
	*/

	//reg [N*K-1:0] feed;
	//reg out_1;
	//reg out_2;
	reg [2:0] ctrl;
	reg [2:0] partner_no_1;
	reg [2:0] partner_no_2;

	/*wire out_1;
	wire out_2;
	wire [2-1:0] deltas_1;
	wire [2-1:0] deltas_2;
	*/
	wire dirty0_1;
	wire dirty1_1;
	
	wire dirty0_2;
	wire dirty1_2;
	
	reg [99:0] prime;
	reg [99:0] base;
	
	wire [99:0] pub_key_1;
	wire [99:0] pub_key_2;
	
	partner uut_partner_1 (
		.rst(rst), 
		.clk(clk), 
		.prime_in(prime),
		.base_in(base),
		.pub_key_in(pub_key_2),
		.ctrl(ctrl),
		.partner_no(partner_no_1),
		.pub_key_my(pub_key_1),
		.dirty0(dirty0_1),
		.dirty1(dirty1_1)
	);
	
	partner uut_partner_2 (
		.rst(rst), 
		.clk(clk), 
		.prime_in(prime),
		.base_in(base),
		.pub_key_in(pub_key_1),
		.ctrl(ctrl),
		.partner_no(partner_no_2),
		.pub_key_my(pub_key_2),
		.dirty0(dirty0_2),
		.dirty1(dirty1_2)
	);
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			synced = 0;
			//sync_count = 0;
			//iter_count = 0;
			
			prime = 23;
			base = 5;
			
			seed_no = 3'b000;
			partner_no_1 = 3'b001;
			partner_no_2 = 3'b010;
			
			state = 0;
			ctrl = 3'b000;
			$display("---- global reset at monitor----");
		end
		else begin
			if (~synced) begin
				//$display("tick");
				if (state == 0) begin // generate sectret key
					ctrl = 3'b001;
					state = 1;
					$display("monitor state 0");
				end
				else if (state == 1) begin 
					//$display("monitor state 1");
					// wait for generate sectret key to finish
					if ( ~dirty0_1 && ~dirty0_2 ) begin
						$display("monitor : generate sectret key finished");
						$display("monitor : pub_key_1 = %d", pub_key_1);
						$display("monitor : pub_key_2 = %d", pub_key_2);
						state = 2;
					end
				end
				
				else if (state == 2) begin // generate common key
					ctrl = 3'b010;
					state = 3;
					$display("monitor state 2");
				end				
				else if (state == 3) begin // wait for compute common key
					if ( ~dirty1_1 && ~dirty1_2 ) begin
						$display("monitor : computed common key.");
						synced = 1;
					end
				end
				
				else begin
					$display("monitor : IMpossible case.. something is broken.");//; should never reach here
				end
			end
		end
	end

endmodule
