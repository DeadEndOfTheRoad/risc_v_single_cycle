module controller(input logic [6:0] operation,
                  input logic [2:0] funct3,
                  input logic funct7_5, ALUNorReduction,
                  output logic [3:0] ALUControl, MemWrite,
                  output logic [2:0] ImmSrc, ReadMask, ResultSrc,
                  output logic PCSrc, ALUSrc, RegWrite, PCTargetSrc);
    
    logic [1:0] ALUOp;
    logic Jump, Branch;
    
    main_decoder main_dec(funct3, operation, MemWrite, ImmSrc, ResultSrc,
                          ALUOp, Jump, Branch, RegWrite, ALUSrc, PCTargetSrc);
                          
    ALU_decoder alu_dec(funct3, ALUOp, operation[5], funct7_5, ALUControl);
    
    assign PCSrc = ((ALUNorReduction ^ funct3[0] ^ funct3[2]) & Branch) | Jump;
    assign ReadMask = funct3;
    
endmodule