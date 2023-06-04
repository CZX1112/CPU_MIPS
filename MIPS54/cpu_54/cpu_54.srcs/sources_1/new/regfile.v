module regfile(
    input clk,
    input rst,
    input en,
    input rf_write,
    input [4:0] rsc,
    input [4:0] rtc,
    input [4:0] rdc,
    input [31:0] rd,
    output [31:0] rs,
    output [31:0] rt 
    );
    reg [31:0] array_reg[31:0];
    reg [5:0] i; 
    assign rs = en ? array_reg[rsc] : 32'bz;
    assign rt = en ?array_reg[rtc] : 32'bz;
    always @(negedge clk or posedge rst) begin
    //always @(posedge clk or posedge rst) begin
      if (rst) begin       
        for(i=0;i<32;i=i+1)
          array_reg[i] <= 0;
        end
      else if (rf_write && en && (rdc != 0))
               array_reg[rdc] <= rd;
    end
    
    
    /*always@(posedge clk) begin begin
    //always@(negedge clk) begin begin
      if (rf_write && en && (rdc != 0))
        array_reg[rdc] <= rd;
      end
    end*/
endmodule

/*
`timescale 1ns / 1ps

module regfile(
    input clk,
    input rst,
    input en,
    input [4:0] rsc,
    input [4:0] rtc,
    input [4:0] rdc,
    input [31:0] rd,
    output [31:0] rs,
    output [31:0] rt 
    );
    reg [31:0] array_reg [31:0];
    reg [5:0] i; 
    
    assign rs = array_reg[rsc];
    assign rt = array_reg[rtc];

    always @(negedge clk or posedge rst) begin
        if (rst)
            for(i=0; i<32; i = i + 1)
                array_reg[i] <= 0;
        else if (en && rdc != 0)
            array_reg[rdc] <= rd;
    end
endmodule
*/