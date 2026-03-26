module register_file(input logic         clk, reset, write_enable_3,
                     input logic  [4:0]  addr_1, addr_2, addr_3,
                     input logic  [31:0] write_data_3,
                     output logic [31:0] read_data_1, read_data_2);
    
    logic [31:0] registers [31:0]; 
    always_ff @(posedge clk, posedge reset)
      begin
        if (reset)
            for (int i = 0; i < 32; i++)
                registers[i] <= 32'b0;
        else if (write_enable_3 && addr_3 != 5'b0)
            registers[addr_3] <= write_data_3;
      end
    
    assign read_data_1 = registers[addr_1];
    assign read_data_2 = registers[addr_2];

endmodule