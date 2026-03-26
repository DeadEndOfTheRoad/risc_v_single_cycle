module datapath(input logic         clk, reset,
                input logic  [31:0] instr,
                input logic  [31:0] memoryReadData,
                input logic         PCSrc, ALUSrc, RegWrite, PCTargetSrc,
                input logic  [3:0]  ALUControl,
                input logic  [2:0]  ResultSrc, ImmSrc, ReadMask,
                output logic [31:0] PC,
                output logic [31:0] ALUResult, memoryWriteData
                );
    
    logic [31:0] result, SrcA, SrcB, regReadData2,
                 immediateExtended, maskedMemoryReadData;
    logic [31:0] PCPlus4, PCPlusImm, nextPC, PCTargetAddend;
    logic _unused_negative, _unused_zero, _unused_carry, _unused_overflow;
    
    assign PCPlus4 = PC + 32'b100;
    assign PCPlusImm = PCTargetAddend + immediateExtended;
    
    always_comb begin
      case (ResultSrc)
        3'b000: result = ALUResult;
        3'b001: result = maskedMemoryReadData;
        3'b010: result = PCPlus4;
        3'b011: result = immediateExtended;
        3'b100: result = PCPlusImm;
        default: result = 32'bx;
      endcase
      
      case (ALUSrc)
        1'b0: SrcB = regReadData2;
        1'b1: SrcB = immediateExtended;
        default: SrcB = 32'bx;
      endcase
      
      case (PCSrc)
        1'b0: nextPC = PCPlus4;
        1'b1: nextPC = PCPlusImm;
        default: nextPC = 32'bx;
      endcase
      
      case (PCTargetSrc)
        1'b0: PCTargetAddend = SrcA;
        1'b1: PCTargetAddend = PC;
      endcase
    end
    
    masker byte_masker(memoryReadData, ReadMask, maskedMemoryReadData);
    
    register_file rf(clk, reset, RegWrite,
                     instr[19:15], instr[24:20], instr[11:7],
                     result, SrcA, regReadData2);
    
     // Only zero flag connected
    riscv_alu alu(SrcA, SrcB, ALUControl, ALUResult,
            _unused_negative, _unused_zero, _unused_carry, _unused_overflow);
    
    extend ext(instr[31:7], ImmSrc, immediateExtended);
    
    program_counter pcreg(clk, reset, nextPC, PC);
    
    assign memoryWriteData = regReadData2;
    
endmodule