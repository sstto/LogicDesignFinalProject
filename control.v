`timescale 1ns / 1ps

module control(
    input [1:0] op,
    output reg_dst,
	 output reg_write,
	 output alu_src,
	 output branch,
	 output mem_read,
	 output mem_write,
	 output mem_to_reg,
	 output alu_op
    );
	 
	wire [7:0] control_signal;
	
	assign {reg_dst, reg_write, alu_src, branch, mem_read, mem_write, mem_to_reg, alu_op} = control_signal;
	
	assign control_signal = op == 2'b00 ? 8'b11000001:
									op == 2'b01 ? 8'b01101010:
									op == 2'b10 ? 8'b00100100:
									8'b00010000;

endmodule