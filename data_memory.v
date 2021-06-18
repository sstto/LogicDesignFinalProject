`timescale 1ns / 1ps

module data_memory(
    input clk,
    input reset,
    input [7:0] address,
    input [7:0] write_data,
    input mem_write,
    output [7:0] read_data
    );
	reg[7:0] mems[31:0];
	
	assign read_data = mems[address[4:0]];
	
	integer i;
	initial begin
		for (i=0; i< 16; i = i+1) begin
			mems[i] <= i;
		end
		for (i=0; i< 16; i = i+1) begin
			mems[i+16] <= -i;
		end
	end
	
	always @ (posedge reset or posedge clk) begin
		if(reset) begin
			for (i=0; i< 16; i = i+1) begin
				mems[i] <= i;
			end
			for (i=0; i< 16; i = i+1) begin
				mems[i+16] <= -i;
			end
		end else begin
			if (mem_write)begin
				mems[address[4:0]] <= write_data;
			end
		end
	end

endmodule