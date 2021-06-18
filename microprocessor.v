`timescale 1ns / 1ps

module microprocessor(
    input [7:0] instruction,
    input clkin,
    input reset,
    output reg [7:0] pc,
	 output [6:0] display_ten,
	 output [6:0] display_one,
	 output [5:0] display_worm,
	 output [6:0] display_op,
	 output [6:0] display_rs,
	 output [6:0] display_rt,
	 output [6:0] display_rd
    );
	
	// variables
	 wire clk;
	 	 
	 wire [1:0] op, rs, rt, rd;
	 wire [7:0] imm_extended;
	 
	 wire reg_dst, reg_write, alu_src, branch, mem_read, mem_write, mem_to_reg, alu_op;
	 wire [7:0] control_signal;
	 
	 wire [7:0] reg_data_one, reg_data_two;
	 
	 wire [7:0] alu_operand = alu_src? imm_extended: reg_data_two;
	 wire [7:0] alu_out;
	 
	 wire [7:0] read_data;
	 
	 wire [1:0] write_reg = reg_dst? rd: rt;
	 wire [7:0] write_mem = mem_to_reg? read_data: alu_out;
	 
	 reg [7:0] display;
	 wire [3:0] rd_or_imm;
	 
	 assign {op, rs, rt, rd} = instruction;

	 //main(control part)
	 control ct(
			 .op(op),
			 .reg_dst(reg_dst),
			 .reg_write(reg_write),
			 .alu_src(alu_src),
			 .branch(branch),
			 .mem_read(mem_read),
			 .mem_write(mem_write),
			 .mem_to_reg(mem_to_reg),
			 .alu_op(alu_op)
	 );
	 
	 //main(data part)
	 registers rg(
			.read_register_one(rs),
			.read_register_two(rt),
			.write_register(write_reg),
			.write_data(write_mem),
			.reg_write(reg_write),
			.read_data_one(reg_data_one),
			.read_data_two(reg_data_two),
			.clk(clk),
			.reset(reset)
	 );
	 
	 data_memory dm(
			.clk(clk),
			.reset(reset),
			.address(alu_out),
			.write_data(reg_data_two),
			.mem_write(mem_write),
			.read_data(read_data)
    );
	 
	 // sub
	 alu alu(
			.a(reg_data_one),
			.b(alu_operand),
			.c(alu_out)
    );
	 
	 sign_extender se(
			.in(instruction[1:0]),
			.out(imm_extended)
	 );
	 
	 clock_divider cd(
			.clkin(clkin),
			.reset(reset),
			.clkout(clk)
	 );
	 
	 //pc
	initial begin
		pc <= 0;
	end
	 
	always @ (posedge clk or posedge reset) begin
		if(reset) begin
				pc <= 0;
		end else begin
			if(branch) begin
				pc <= pc + 1 + imm_extended;
			end else begin
					pc <= pc + 1;
			end
		end
	end
	
	
	// display
	bcd_decoder bcd_ten(
			.bcd(display[7:4]),
			.out(display_ten)
    );
	 
	 bcd_decoder bcd_one(
			.bcd(display[3:0]),
			.out(display_one)
    );
	 
	always @ (posedge clk or posedge reset) begin
		if(reset) begin
			display <= 0;
		end else begin
			display <= write_mem;
		end
	end
	
	// additional implement
	//worm
	worm_decoder wd(
		.clkin(clk),
		.reset(reset),
		.branch(branch),
		.imm_extended(imm_extended),
		.display_worm(display_worm)
	);
	
	//op
	op_decoder op0(
		.op(op),
		.display_op(display_op)
	);
	
	//rs, rt, rd
	bcd_decoder rs0(
		.bcd(rs),
		.out(display_rs)
	);
	bcd_decoder rt0(
		.bcd(rt),
		.out(display_rt)
	);
	assign rd_or_imm = branch ? imm_extended[3:0] : rd;
	bcd_decoder rd0(
		.bcd(rd_or_imm),
		.out(display_rd)
	);
	
endmodule
	