`timescale 1ns / 1ps

module registers(
    input [1:0] read_register_one,
    input [1:0] read_register_two,
    input [1:0] write_register,
    input [7:0] write_data,
	 input reg_write,
    output [7:0] read_data_one,
    output [7:0] read_data_two,
    input clk,
    input reset
    );
	
	 reg [7:0] regs[3:0];
	 
	 integer i;
	 
	 initial begin
		for(i = 0; i < 4; i = i + 1) begin
			regs[i] <= 0;
		end
	 end
	 
	 assign read_data_one = regs[read_register_one];
	 assign read_data_two = regs[read_register_two];
	 
	 always@(posedge clk or posedge reset) begin
		if(reset)	begin
			for(i = 0; i < 4; i = i + 1) begin
				regs[i] <= 0;
			end
		end else	begin
			if(reg_write)	begin
				regs[write_register] <= write_data;
			end
		end
	end
			
endmodule