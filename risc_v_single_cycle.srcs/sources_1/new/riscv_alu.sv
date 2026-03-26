module riscv_alu (input logic  [31:0] A, B,
                  input logic  [3:0]  ALUControl,
                  output logic [31:0] ALUResult,
                  output logic        negative_flag,
                                      zero_flag,
                                      carry_flag,
                                      overflow_flag);
    
    logic [32:0] sum;
    logic internalOverflowFlag;
    
    assign sum = ALUControl[0] ? ({1'b0, A} + {1'b0, ~B} + 33'b1) : ({1'b0, A} + {1'b0, B});
    
               
    always_comb
      case (ALUControl)
        4'b0000: ALUResult = sum[31:0]; // Addition
        4'b0001: ALUResult = sum[31:0]; // Subtraction
        4'b0010: ALUResult = A & B;     // AND
        4'b0011: ALUResult = A | B;     // OR
        4'b0100: ALUResult = A ^ B;     // XOR
        4'b0110: ALUResult = A << B;    // LOGICAL LEFT SHIFT 
        4'b0111: ALUResult = A >> B;    // LOGICAL RIGHT SHIFT
        4'b1111: ALUResult = A >>> B[4:0]; // ARITHMETIC RIGHT SHIFT
        4'b0101: ALUResult = {31'b0, sum[31] ^ internalOverflowFlag};  // Set Less Than 
        4'b1101: ALUResult = {31'b0, ~sum[32]};                 // Set Less Than Unsigned
        default: ALUResult = 32'bx;
      endcase
      
    assign internalOverflowFlag = (A[31] ^ sum[31]) & ~(ALUControl[0] ^ A[31] ^ B[31]);
    
    assign negative_flag = ALUResult[31];
    assign zero_flag = ~|ALUResult;
    assign carry_flag = ~|ALUControl[2:1] & sum[32];
    assign overflow_flag = ~|ALUControl[2:1] & internalOverflowFlag;
    
endmodule