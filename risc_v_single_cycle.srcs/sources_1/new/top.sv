module top(input logic         clk, reset,
           output logic [31:0] memoryWriteData,
           output logic [31:0] memoryAddress,
           output logic [3:0]  memoryWriteEnable);

    logic [31:0] instr, memoryReadData;
    logic [31:0] PC;
    
    riscv_single_cycle processor(clk, reset, instr, memoryReadData,
                                 PC, memoryAddress, memoryWriteData, 
                                 memoryWriteEnable);
                                 
    imem instr_memory(PC, instr);
    
    dmem data_memory(clk, memoryWriteEnable, memoryAddress, memoryWriteData, memoryReadData);
    
endmodule
