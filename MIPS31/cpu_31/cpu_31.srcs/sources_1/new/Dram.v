module Dram(
    input clk,
    input ena,
    input DM_W,
    input DM_R,
    input [31:0] addr,
    input [31:0] data_in,
    output [31:0] data_out
    );
    
    reg [31:0] RAM [31:0];
    assign data_out = (ena && DM_R) ? RAM[addr] : 32'hzzzzzzzz;
    
    always @ (posedge clk)
    begin
        if(ena && DM_W)
            RAM[addr] <= data_in;
    end

endmodule
