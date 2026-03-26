module dmem(input logic         clk,
            input logic  [3:0]  write_enable,
            input logic  [31:0] addr,
            input logic  [31:0] write_data,
            output logic [31:0] read_data);
    
    logic [31:0] RAM [63:0];
    
    always_ff @(posedge clk)
      begin
        if (write_enable[0]) RAM[addr[31:2]][7:0] <= write_data[7:0];
        if (write_enable[1]) RAM[addr[31:2]][15:8] <= write_data[15:8];
        if (write_enable[2]) RAM[addr[31:2]][23:16] <= write_data[23:16];
        if (write_enable[3]) RAM[addr[31:2]][31:24] <= write_data[31:24];
      end
    
    assign read_data = RAM[addr[31:2]];
    
endmodule