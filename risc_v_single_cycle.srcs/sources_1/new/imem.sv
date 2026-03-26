module imem(input logic  [31:0] addr,
            output logic [31:0] read_data);
    
    logic [31:0] ROM [63:0] = '{default: '0};
    
    initial $readmemh("C:/Users/pavan/risc_v_single_cycle/risc_v_single_cycle.srcs/sources_1/new/imem.mem", ROM);
    
    assign read_data = ROM[addr[31:2]];
    
endmodule