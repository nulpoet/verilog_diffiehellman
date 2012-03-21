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
    output reg synced,
	 output reg [31:0] sync_count,
	 output reg [63:0] iter_count
	);

	parameter K = 2;
	parameter N = 3;
	parameter SYNC_COUNT_LIMIT = 10;
	
	integer ii;

	//reg [31:0] sync_count;
	//reg [63:0] iter_count;
	reg [7:0] state;

	reg [2:0] seed_no;

	wire lfsr_done;
	wire [12:0] lfsr_val;
	lfsr uut_lfsr (
			.clk(clk), 
			.rst(rst),
			.seed_no(seed_no),
			.lfsr_done(lfsr_done),
			.lfsr(lfsr_val)
		);


	reg [N*K-1:0] feed;
	//reg out_1;
	//reg out_2;
	reg [2:0] ctrl;
	reg [2:0] partner_no_1;
	reg [2:0] partner_no_2;

	wire out_1;
	wire out_2;
	wire [2-1:0] deltas_1;
	wire [2-1:0] deltas_2;
	wire dirty_1;
	wire dirty_2;
	
	partner uut_partner_1 (
		.rst(rst), 
		.clk(clk), 
		.feed(feed),
		.out_other(out_2),
		.ctrl(ctrl),
		.partner_no(partner_no_1),
		
		.out(out_1),
		
		.deltas(deltas_1),
		.dirty(dirty_1)
	);
	
	partner uut_partner_2 (
		.rst(rst), 
		.clk(clk), 
		.feed(feed),
		.out_other(out_1),
		.ctrl(ctrl),
		.partner_no(partner_no_2),
		
		.out(out_2),
		
		.deltas(deltas_2),
		.dirty(dirty_2)
	);

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			synced = 0;
			sync_count = 0;
			iter_count = 0;
			
			seed_no = 3'b000;
			partner_no_1 = 3'b001;
			partner_no_2 = 3'b010;
			
			state = 0;
			ctrl = 3'b000;
			$display("---- global reset at monitor----");
		end
		else begin
			if (state == 0) begin // initialize weights
				ctrl = 3'b001;
				state = 1;
			end
			else if (state == 1) begin 
				// wait for initialize weights to finish
				if ( ~dirty_1 && ~dirty_2 ) begin
					$display("monitor : weights finished");
					state = 2;
				end
			end
			else if (state == 2) begin // start compute
				for(ii=0; ii<K*N; ii=ii+1) begin
					feed[ii] = lfsr_val[ii];
				end
				ctrl = 3'b010;
				$display("monitor : feeding %b", feed);
				state = 3;
			end
			else if (state == 3) begin // wait for compute
				if ( ~dirty_1 && ~dirty_2 ) begin
					iter_count = iter_count + 1;
					$display("monitor : computed with out_1 : %d & out_2 : %d", out_1, out_2);
					if (out_1 == out_2) begin
						ctrl = 3'b100; // learn in this cycle
						sync_count = sync_count + 1; // increment counter
						$display("monitor : sync_count is %d", sync_count);
						if(sync_count == SYNC_COUNT_LIMIT)
							state = 4; // go to state 4 if synced
						else
							state = 2; // else go to compute
					end
					else begin
						sync_count = 0;
						ctrl = 3'b000; // drop 1 cycle before going to compute
						state = 2; // go to compute
					end
				end
			end
			else if (state == 4) begin // learn
				$display("########### Synced in %d", iter_count);
				ctrl = 3'b111; // synced.. loop forever in state 4
				synced = 1;
			end
			//else begin
				//; should never reach here
			//end
		end
	end

endmodule
