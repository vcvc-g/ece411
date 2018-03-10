import lc3b_types::*;

module barrier_EX_MEM (
    /* INPUTS */
    input clk,
    input lc3b_control_word control_in,
    input lc3b_word alu_in,
    input lc3b_word ir_in,
    input lc3b_word pc_in,
    input lc3b_word pcn_in,
    input lc3b_word sr1_in,

    /* OUTPUTS */
    output lc3b_control_word control_out,
    output lc3b_word alu_out,
    output lc3b_word ir_out,
    output lc3b_word pc_out,
    output lc3b_word pcn_out,
    output lc3b_word sr1_out
);

lc3b_control_word control;
lc3b_word alu;
lc3b_word ir;
lc3b_word pc;
lc3b_word pcn;
lc3b_word sr1;

/* INITIAL */
initial begin
    control = 0;
    alu     = 0;
    ir      = 0;
    pc      = 0;
    pcn     = 0;
    sr1     = 0;
end

/* CLOCK */
always_ff @(posedge clk) begin
    control = control_in;
    alu     = alu_in;
    ir      = ir_in;
    pc      = pc_in;
    pcn     = pcn_in;
    sr1     = sr1_in;
end

/* ALWAYS */
assign control_out = control;
assign alu_out     = alu;
assign ir_out      = ir;
assign pc_out      = pc;
assign pcn_out     = pcn;
assign sr1_out     = sr1;

endmodule : barrier_EX_MEM
