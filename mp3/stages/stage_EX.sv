import lc3b_types::*;

module stage_EX (
    /* INPUTS */
    input clk,
    input stall,
    input lc3b_control_word control_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word sr1_in,
    input lc3b_word sr2_in,
	 input logic [1:0] forward_A,
	 input logic [1:0] forward_B,
	 input lc3b_word data_EX_MEM,
	 input lc3b_word data_WB,
    /* OUTPUTS */
    output lc3b_word alu_out,
    output lc3b_word pcn_out
);

lc3b_word pc_adder_mux_out;
lc3b_word general_alu_mux_out;

lc3b_word imm4;
lc3b_word imm5;
lc3b_word offset6_b; // byte aligned
lc3b_word offset6_w; // word aligned
lc3b_word offset9;
lc3b_word offset11;

lc3b_word forward_A_mux_out;
lc3b_word forward_B_mux_out;

assign imm4    = $unsigned( ir_in[ 3:0]);
assign imm5      = $signed( ir_in[ 4:0]);
assign offset6_b = $signed( ir_in[ 5:0]);
assign offset6_w = $signed({ir_in[ 5:0], 1'b0});
assign offset9   = $signed({ir_in[ 8:0], 1'b0});
assign offset11  = $signed({ir_in[10:0], 1'b0});

mux2 pc_adder_mux (
    /* INPUTS */
    .sel(control_in.pc_adder_mux_sel),
    .a(offset9),
    .b(offset11),

    /* OUTPUTS */
    .f(pc_adder_mux_out)
);

adder pc_adder (
    /* INPUTS */
    .a(pc_in),
    .b(pc_adder_mux_out),

    /* OUTPUTS */
    .f(pcn_out)
);

mux4 forward_A_mux (
	.sel(forward_A),
	.a(sr1_in),
	.b(data_EX_MEM),
	.c(data_WB),
	.d(16'b0),
	.f(forward_A_mux_out)
);

mux4 forward_B_mux (
	.sel(forward_B),
	.a(sr2_in),
	.b(data_EX_MEM),
	.c(data_WB),
	.d(16'b0),
	.f(forward_B_mux_out)
);

mux8 general_alu_mux (
    /* INPUTS */
    .sel(control_in.general_alu_mux_sel),
    .in000(forward_B_mux_out),
    .in001(imm4),
    .in010(imm5),
    .in011(offset6_b),
    .in100(offset6_w),
    .in101(16'bx),
    .in110(16'bx),
    .in111(16'bx),

    /* OUTPUTS */
    .out(general_alu_mux_out)
);

alu general_alu (
    /* INPUTS */
    .aluop(control_in.general_alu_op),
    .a(forward_A_mux_out),
    .b(general_alu_mux_out),

    /* OUTPUTS */
    .f(alu_out)
);

endmodule: stage_EX