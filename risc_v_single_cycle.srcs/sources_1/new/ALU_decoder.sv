module ALU_decoder(input logic  [2:0] funct3,
                   input logic  [1:0] ALUOp,
                   input logic        op_5, funct7_5,
                   output logic [3:0] ALUControl);
    logic RTypeSub;
    assign RTypeSub = funct7_5 & op_5; // R-type subtract
    
    always_comb
      case (ALUOp)
        2'b00: ALUControl = 4'b0000;  // Addition (lw/sw addr calculation)
        2'b01:    case (funct3[2:1])  // B-type
                    2'b00: ALUControl = 4'b0001;  // beq/bne
                    2'b10: ALUControl = 4'b0101;  // blt/bge
                    2'b11: ALUControl = 4'b1101;  // bltu/bgeu
                    default: ALUControl = 4'bxxxx;
                  endcase  
        default:  case(funct3)        // R-type or I-type
                    3'b000: if (RTypeSub) ALUControl = 4'b0001;  // sub
                            else          ALUControl = 4'b0000;  // add, addi
                    3'b010: ALUControl = 4'b0101;                // slt, slti
                    3'b110: ALUControl = 4'b0011;                // or, ori
                    3'b111: ALUControl = 4'b0010;                // and, andi
                    3'b100: ALUControl = 4'b0100;                // xor, xori
                    3'b001: ALUControl = 4'b0110;                // sll, slli
                    3'b101: ALUControl = funct7_5 ? 4'b1111      // sra, srai
                                                  : 4'b0111;     // srl, srli
                    3'b011: ALUControl = 4'b1101;                // sltu, sltiu
                    default: ALUControl = 4'bxxxx;
                  endcase
      endcase
    
endmodule
