module MUX8(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input [31:0] iC4,
    input [31:0] iC5,
    input [31:0] iC6,
    input [31:0] iC7,
    input iS2,
    input iS1,
    input iS0,
    output [31:0] oZ
    );
reg[31:0] tmpt;
always@(*)
begin
    if({iS2,iS1,iS0} == 3'b000)
        tmpt = iC0;
    else if({iS2,iS1,iS0} == 3'b001)
        tmpt = iC1;
    else if({iS2,iS1,iS0} == 3'b010)
        tmpt = iC2;
    else if({iS2,iS1,iS0} == 3'b011)
        tmpt = iC3;
    else if({iS2,iS1,iS0} == 3'b100)
        tmpt = iC4;
    else if({iS2,iS1,iS0} == 3'b101)
        tmpt = iC5;
    else if({iS2,iS1,iS0} == 3'b110)
        tmpt = iC6;
    else
        tmpt = iC7;

end
assign oZ = tmpt;
endmodule