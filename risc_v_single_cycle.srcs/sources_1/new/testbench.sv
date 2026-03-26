`timescale 1ns / 1ps

module testbench;
    
    logic clk, reset;
    logic [3:0]  memoryWriteEnable;
    logic [31:0] memoryWriteData;
    logic [31:0] memoryAddress;
    
    top dut(clk, reset, memoryWriteData, memoryAddress, memoryWriteEnable);
    
    initial begin
        reset <= 1; #5; reset <= 0; #5;
    end
    
    always begin
        clk <= 0; #5; clk <= 1; #5;
    end
    
    always @(negedge clk) begin
        if(&memoryWriteEnable) begin
            if(memoryAddress === 100 & memoryWriteData === 32'hAAAABBCC) begin
                $display("Simulation succeeded");
                $stop;
            end else if (memoryAddress !== 96) begin
                $display("Simulation failed");      
                $stop;
            end
        end
    end
    
    
    
endmodule
