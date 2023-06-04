module pcreg(
    input clk,
    input rst,
    input ena,
    
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    always@(negedge clk or posedge rst)
    //always@(posedge clk or posedge rst)
        begin
            if(rst==1'b1)
                data_out=32'h00400000;
            else
                if(ena==1'b1)
                    data_out=data_in;
                else if(ena==1'b0)
                    data_out=data_out;
        end
endmodule
