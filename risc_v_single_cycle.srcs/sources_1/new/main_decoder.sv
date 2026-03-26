module main_decoder(input logic  [2:0] funct3,
                    input logic  [6:0] operation,
                    output logic [3:0] MemWrite,
                    output logic [2:0] ImmSrc, ResultSrc,
                    output logic [1:0] ALUOp,
                    output logic Jump, Branch, RegWrite, ALUSrc, PCTargetSrc);
    
    logic [16:0] controls;
    
    assign {ResultSrc, ImmSrc, ALUOp, Jump, Branch, MemWrite, RegWrite, ALUSrc, PCTargetSrc} = controls;
    
    always_comb
      case (operation)
        // ResultSrc_ImmSrc_ALUOp_Jump_Branch_MemWrite_RegWrite_ALUSrc_PCTargetSrc
        7'b0000011: controls = 17'b001_000_00_0_0_0000_1_1_x; // lw
        7'b0100011: begin
            {controls[16:7], controls[2:0]} = 17'bxxx_001_00_0_0_0_1_x; // S-type
              case (funct3)
                3'b010: controls[6:3] = 4'b1111;  // sw
                3'b001: controls[6:3] = 4'b0011;  // sh
                3'b000: controls[6:3] = 4'b0001;  // sb
                default: controls[6:3] = 4'bxxxx;
              endcase 
            end
        7'b0110011: controls = 17'b000_xxx_10_0_0_0000_1_0_x; // R-type
        7'b1100011: controls = 17'bxxx_010_01_0_1_0000_0_0_1; // beq
        7'b0010011: controls = 17'b000_000_10_0_0_0000_1_1_x; // I-type ALU
        7'b1101111: controls = 17'b010_011_xx_1_0_0000_1_x_1; // jal
        7'b0110111: controls = 17'b011_100_xx_0_0_0000_1_x_x; // lui
        7'b1100111: controls = 17'b010_000_xx_1_0_0000_1_x_0; // jalr
        7'b0010111: controls = 17'b100_100_xx_0_0_0000_1_x_1; // auipc
        default:    controls = 17'bxxx_xxx_xx_x_x_xxxx_x_x_x;
      endcase
    
endmodule