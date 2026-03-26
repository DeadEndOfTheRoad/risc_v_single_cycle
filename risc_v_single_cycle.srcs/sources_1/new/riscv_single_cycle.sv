module riscv_single_cycle(input logic         clk, reset,
                          input logic  [31:0] instr, memoryReadData,
                          output logic [31:0] PC, memoryAddress,
                          output logic [31:0] memoryWriteData,
                          output logic [3:0]  memoryWriteEnable);
                          
    logic [3:0] ALUControl;
    logic [2:0] ReadMask, ImmSrc, ResultSrc;
    logic PCSrc, ALUSrc, RegWrite, ALUNorReduction, PCTargetSrc;
    
    assign ALUNorReduction = ~|memoryAddress;
    
    controller control_unit(instr[6:0], instr[14:12], instr[30],
                            ALUNorReduction, ALUControl, memoryWriteEnable, ImmSrc, ReadMask, 
                            ResultSrc, PCSrc, ALUSrc, RegWrite, PCTargetSrc);
    
    datapath dp_unit(clk, reset, instr, memoryReadData, PCSrc, ALUSrc, RegWrite,
                     PCTargetSrc, ALUControl, ResultSrc, ImmSrc, ReadMask, PC,
                     memoryAddress, memoryWriteData);
                     
endmodule
