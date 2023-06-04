module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
    );
    //DM??
    wire CS,DM_W,DM_R;
    wire [31:0] DM_addr;
    wire [31:0] DM_WData,DM_RData;
    
    wire [31:0] instr_addr;
    wire [31:0] dm_addr;
    assign instr_addr = pc - 32'h0040_0000;
    
    assign dm_addr = (DM_addr - 32'h1001_0000) / 4;
    
    //??IP?
    imem IM(instr_addr[12:2],inst);
    
    Dram Dram(clk_in,CS,DM_W,DM_R,dm_addr,DM_WData,DM_RData);
    
    cpu sccpu(clk_in,reset,inst,DM_addr,DM_RData,DM_WData,CS,DM_W,DM_R,pc);
    
endmodule