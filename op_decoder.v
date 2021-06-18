`timescale 1ns / 1ps

module op_decoder(
    input [1:0] op,
    output [6:0] display_op
    );
	assign display_op =  (op == 2'b00) ? 7'b1110111:
								(op == 2'b01) ? 7'b0111000:
								(op == 2'b10) ? 7'b1101101:
								7'b0001110;
								

endmodule