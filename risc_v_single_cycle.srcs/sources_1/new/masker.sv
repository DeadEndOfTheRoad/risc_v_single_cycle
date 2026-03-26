module masker(input logic  [31:0] memoryReadData,
              input logic  [2:0]  ReadMask,
              output logic [31:0] maskedMemoryReadData);
    
    logic sign_bit;
    
    always_comb begin
      case (ReadMask[1:0])
        2'b01: sign_bit = memoryReadData[15] & ~ReadMask[2]; // half
        2'b00: sign_bit = memoryReadData[7] & ~ReadMask[2];  // byte
        default: sign_bit = 1'bx;
      endcase
      
      case (ReadMask[1:0])
        2'b10: maskedMemoryReadData = memoryReadData;                         // word
        2'b01: maskedMemoryReadData = {{16{sign_bit}}, memoryReadData[15:0]}; // half
        2'b00: maskedMemoryReadData = {{24{sign_bit}}, memoryReadData[7:0]};  // byte
        default: maskedMemoryReadData = 32'bx;
      endcase
    end
    
endmodule
