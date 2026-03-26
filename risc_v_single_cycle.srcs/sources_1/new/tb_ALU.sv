`timescale 1ns/1ps

module tb_ALU;
    logic [31:0] A, B;
    logic [2:0]  ALUControl;
    logic [31:0] ALUResult;
    logic        N, Z, C, V;

    // Instantiate DUT
    riscv_alu dut (A, B, ALUControl, ALUResult, N, Z, C, V);

    // Task to apply inputs and check outputs
    task automatic check(
        input logic [31:0] a, b,
        input logic [2:0]  ctrl,
        input logic [31:0] expected_result,
        input logic        exp_neg, exp_zero, exp_carry, exp_overflow,
        input string       test_name
    );
        A = a; B = b; ALUControl = ctrl;
        #10;
        if (ALUResult !== expected_result ||
            N !== exp_neg     ||
            Z     !== exp_zero    ||
            C    !== exp_carry   ||
            V !== exp_overflow) begin
            $display("FAIL: %s", test_name);
            $display("  A=0x%08x B=0x%08x CTRL=%03b", a, b, ctrl);
            $display("  Expected: Result=0x%08x N=%b Z=%b C=%b V=%b",
                      expected_result, exp_neg, exp_zero, exp_carry, exp_overflow);
            $display("  Got:      Result=0x%08x N=%b Z=%b C=%b V=%b",
                      ALUResult, N, Z, C, V);
        end else begin
            $display("PASS: %s", test_name);
        end
    endtask

    initial begin
        // ============================================================
        // ADDITION (ALUControl = 000)
        // ============================================================
        check(32'd5,          32'd3,          3'b000, 32'd8,          0,0,0,0, "ADD basic");
        check(32'd0,          32'd0,          3'b000, 32'd0,          0,1,0,0, "ADD zero+zero");
        check(32'hFFFFFFFF,   32'd1,          3'b000, 32'd0,          0,1,1,0, "ADD overflow into zero (carry)");
        check(32'h7FFFFFFF,   32'd1,          3'b000, 32'h80000000,   1,0,0,1, "ADD signed overflow pos→neg");
        check(32'h80000000,   32'h80000000,   3'b000, 32'd0,          0,1,1,1, "ADD signed overflow neg+neg");
        check(32'hFFFFFFFE,   32'd1,          3'b000, 32'hFFFFFFFF,   1,0,0,0, "ADD negative result");

        // ============================================================
        // SUBTRACTION (ALUControl = 001)
        // ============================================================
        check(32'd5,          32'd3,          3'b001, 32'd2,          0,0,1,0, "SUB basic");
        check(32'd3,          32'd3,          3'b001, 32'd0,          0,1,1,0, "SUB equal→zero");
        check(32'd3,          32'd5,          3'b001, 32'hFFFFFFFE,   1,0,0,0, "SUB negative result");
        check(32'h80000000,   32'd1,          3'b001, 32'h7FFFFFFF,   0,0,1,1, "SUB signed overflow neg→pos");
        check(32'h7FFFFFFF,   32'hFFFFFFFF,   3'b001, 32'h80000000,   1,0,0,1, "SUB signed overflow pos→neg");
        check(32'd0,          32'd0,          3'b001, 32'd0,          0,1,1,0, "SUB zero-zero");

        // ============================================================
        // AND (ALUControl = 010)
        // ============================================================
        check(32'hFFFFFFFF,   32'h0F0F0F0F,   3'b010, 32'h0F0F0F0F,   0,0,0,0, "AND basic");
        check(32'hFFFFFFFF,   32'h00000000,   3'b010, 32'h00000000,   0,1,0,0, "AND zero");
        check(32'hFFFFFFFF,   32'hFFFFFFFF,   3'b010, 32'hFFFFFFFF,   1,0,0,0, "AND all ones");
        check(32'hAAAAAAAA,   32'h55555555,   3'b010, 32'h00000000,   0,1,0,0, "AND alternating");

        // ============================================================
        // OR (ALUControl = 011)
        // ============================================================
        check(32'hF0F0F0F0,   32'h0F0F0F0F,   3'b011, 32'hFFFFFFFF,   1,0,0,0, "OR basic");
        check(32'h00000000,   32'h00000000,   3'b011, 32'h00000000,   0,1,0,0, "OR zero");
        check(32'hAAAAAAAA,   32'h55555555,   3'b011, 32'hFFFFFFFF,   1,0,0,0, "OR alternating");

        // ============================================================
        // SLT (ALUControl = 101)
        // ============================================================
        check(32'd2,          32'd5,          3'b101, 32'd1,          0,0,0,0, "SLT A<B positive");
        check(32'd5,          32'd2,          3'b101, 32'd0,          0,1,0,0, "SLT A>B positive");
        check(32'd5,          32'd5,          3'b101, 32'd0,          0,1,0,0, "SLT A==B");
        check(32'hFFFFFFFF,   32'd0,          3'b101, 32'd1,          0,0,0,0, "SLT negative<positive");
        check(32'd0,          32'hFFFFFFFF,   3'b101, 32'd0,          0,1,0,0, "SLT positive>negative");
        check(32'h80000000,   32'h7FFFFFFF,   3'b101, 32'd1,          0,0,0,0, "SLT most neg < most pos");

        // ============================================================
        // EDGE CASES
        // ============================================================
        check(32'hFFFFFFFF,   32'hFFFFFFFF,   3'b000, 32'hFFFFFFFE,   1,0,1,0, "ADD max+max");
        check(32'h00000001,   32'h00000001,   3'b001, 32'h00000000,   0,1,1,0, "SUB 1-1");
        check(32'h80000000,   32'h80000000,   3'b001, 32'h00000000,   0,1,1,0, "SUB min-min");

        $display("Testbench complete");
        $finish;
    end
endmodule