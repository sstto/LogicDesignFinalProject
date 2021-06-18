`timescale 1ns / 1ps

module clock_divider(
    input clkin,
    input reset,
    output reg clkout
    );
	reg [31:0] cnt;
	
	initial begin
		clkout <= 1'b0;
		cnt <= 0;
	end
	
	always @ (posedge clkin or posedge reset) begin
		if(reset) begin
			cnt <= 32'd0;
			clkout <= 1'b0;
		end
		else if(cnt >= 32'd25000000) begin
			cnt <= 32'b0;
			clkout <= ~clkout;
		end else begin
			cnt <= cnt+1;
		end
	end

endmodule