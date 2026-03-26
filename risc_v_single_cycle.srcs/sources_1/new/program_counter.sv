module program_counter(input logic         clk, reset,
                       input logic  [31:0] nextPC,
                       output logic [31:0] PC);
    
    always_ff @(posedge clk, posedge reset)
      if (reset) PC <= 32'b0;
      else PC <= nextPC;
    
endmodule