`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:16:11 06/17/2021 
// Design Name: 
// Module Name:    worm_decoder 
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
module worm_decoder(
	input clkin,
	input reset,
	input branch,
	input [7:0] imm_extended,
   output [5:0] display_worm
    );
	 
	reg [2:0] cnt;
	
	initial begin
		cnt <= 0;
	end
	
	always @ (posedge clkin or posedge reset) begin
		if(reset) begin
			cnt <= 3'd0;
		end
		else if(cnt >= 3'd5) begin
			cnt <= 3'd0;
		end else begin
			if(branch) begin 
				cnt <= cnt + 1 + imm_extended[2:0];
			end else begin
				cnt <= cnt+1;
			end
		end
	end
	
	assign display_worm = (cnt == 3'd0) ? 6'b100000:
								 (cnt == 3'd1) ? 6'b010000:
								 (cnt == 3'd2) ? 6'b001000:
								 (cnt == 3'd3) ? 6'b000100:
								 (cnt == 3'd4) ? 6'b000010:
								 6'b000001;
								 
	

endmodule