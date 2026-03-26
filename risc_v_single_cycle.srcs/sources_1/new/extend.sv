module extend(input logic  [31:7] instr,
              input logic  [2:0]  immediate_source,
              output logic [31:0] immediate);
    
    always_comb 
      case (immediate_source) // Bit unswizzling
        3'b000: immediate = {{20{instr[31]}}, instr[31:20]};                                 // I-type
        3'b001: immediate = {{20{instr[31]}}, instr[31:25], instr[11:7]};                    // S-type
        3'b010: immediate = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};    // B-type
        3'b011: immediate = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};  // J-type
        3'b100: immediate = {instr[31:12], 12'b0};                                           // U-type
        default: immediate = 32'bx;
      endcase 
    
endmodule
