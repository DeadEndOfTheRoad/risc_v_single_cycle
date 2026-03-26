`timescale 1ns/1ps

module controller_tb;

    // Inputs
    logic [6:0] operation;
    logic [2:0] funct3;
    logic       funct7_5, ZEROFlag;

    // Outputs
    logic [2:0] ALUControl;
    logic [1:0] ResultSrc, ImmSrc;
    logic       PCSrc, ALUSrc, MemWrite, RegWrite;

    // DUT
    controller dut(operation, funct3, funct7_5, ZEROFlag,
                   ALUControl, ResultSrc, ImmSrc,
                   PCSrc, ALUSrc, MemWrite, RegWrite);

    // Task for checking outputs
    task check(
        input string        instr_name,
        input logic [2:0]   exp_ALUControl,
        input logic [1:0]   exp_ResultSrc, exp_ImmSrc,
        input logic         exp_PCSrc, exp_ALUSrc, exp_MemWrite, exp_RegWrite
    );
        #10;
        if (ALUControl !== exp_ALUControl ||
            ResultSrc  !== exp_ResultSrc  ||
            ImmSrc     !== exp_ImmSrc     ||
            PCSrc      !== exp_PCSrc      ||
            ALUSrc     !== exp_ALUSrc     ||
            MemWrite   !== exp_MemWrite   ||
            RegWrite   !== exp_RegWrite)
        begin
            $display("FAIL [%s]", instr_name);
            $display("  ALUControl: got %b exp %b", ALUControl, exp_ALUControl);
            $display("  ResultSrc:  got %b exp %b", ResultSrc,  exp_ResultSrc);
            $display("  ImmSrc:     got %b exp %b", ImmSrc,     exp_ImmSrc);
            $display("  PCSrc:      got %b exp %b", PCSrc,      exp_PCSrc);
            $display("  ALUSrc:     got %b exp %b", ALUSrc,     exp_ALUSrc);
            $display("  MemWrite:   got %b exp %b", MemWrite,   exp_MemWrite);
            $display("  RegWrite:   got %b exp %b", RegWrite,   exp_RegWrite);
        end
        else
            $display("PASS [%s]", instr_name);
    endtask

    initial begin
        $display("=== Controller Testbench ===");
        funct7_5 = 0; ZEROFlag = 0; funct3 = 3'b000;

        // --- lw ---
        operation = 7'b0000011; funct3 = 3'b010;
        //                       ALUCtrl ResultSrc ImmSrc PCSrc ALUSrc MemWrite RegWrite
        check("lw",              3'b000,  2'b01,   2'b00, 0,    1,     0,       1);

        // --- sw ---
        operation = 7'b0100011; funct3 = 3'b010;
        check("sw",              3'b000,  2'b00,   2'b01, 0,    1,     1,       0);

        // --- R-type add (funct3=000, funct7_5=0) ---
        operation = 7'b0110011; funct3 = 3'b000; funct7_5 = 0;
        check("add",             3'b000,  2'b00,   2'bxx, 0,    0,     0,       1);

        // --- R-type sub (funct3=000, funct7_5=1) ---
        operation = 7'b0110011; funct3 = 3'b000; funct7_5 = 1;
        check("sub",             3'b001,  2'b00,   2'bxx, 0,    0,     0,       1);

        // --- R-type and ---
        operation = 7'b0110011; funct3 = 3'b111; funct7_5 = 0;
        check("and",             3'b010,  2'b00,   2'bxx, 0,    0,     0,       1);

        // --- R-type or ---
        operation = 7'b0110011; funct3 = 3'b110; funct7_5 = 0;
        check("or",              3'b011,  2'b00,   2'bxx, 0,    0,     0,       1);

        // --- R-type slt ---
        operation = 7'b0110011; funct3 = 3'b010; funct7_5 = 0;
        check("slt",             3'b101,  2'b00,   2'bxx, 0,    0,     0,       1);

        // --- I-type addi ---
        operation = 7'b0010011; funct3 = 3'b000; funct7_5 = 0;
        check("addi",            3'b000,  2'b00,   2'b00, 0,    1,     0,       1);

        // --- I-type andi ---
        operation = 7'b0010011; funct3 = 3'b111;
        check("andi",            3'b010,  2'b00,   2'b00, 0,    1,     0,       1);

        // --- I-type ori ---
        operation = 7'b0010011; funct3 = 3'b110;
        check("ori",             3'b011,  2'b00,   2'b00, 0,    1,     0,       1);

        // --- beq: ZEROFlag=1 (branch taken) ---
        operation = 7'b1100011; funct3 = 3'b000; ZEROFlag = 1;
        check("beq taken",       3'b001,  2'b00,   2'b10, 1,    0,     0,       0);

        // --- beq: ZEROFlag=0 (branch not taken) ---
        ZEROFlag = 0;
        check("beq not taken",   3'b001,  2'b00,   2'b10, 0,    0,     0,       0);

        // --- jal ---
        operation = 7'b1101111; funct3 = 3'b000; ZEROFlag = 0;
        check("jal",             3'b000,  2'b10,   2'b11, 1,    0,     0,       1);

        $display("=== Done ===");
        $finish;
    end

endmodule