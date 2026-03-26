`timescale 1ns/1ps

module imem_tb;

    logic [31:0] addr;
    logic [31:0] readData;

    imem dut(.addr(addr), .read_data(readData));

    initial begin
        for (int i = 0; i < 256; i += 4) begin
            addr = i; #10;
            $display("addr=0x%08x data=0x%08x", addr, readData);
        end
    end
    
endmodule