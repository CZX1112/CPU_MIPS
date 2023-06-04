module MUX(
    input [31:0] iC0,
    input [31:0] iC1,
    input [31:0] iC2,
    input [31:0] iC3,
    input iS1,
    input iS0,
    output [31:0] oZ
    );
reg[31:0] tmpt;
always@(*)
begin
   if(iS1==0)
        begin
            if(iS0==0)
                tmpt = iC0;
            else 
                tmpt = iC1;
        end
   else
        begin
            if(iS0==0)
                tmpt = iC2;
            else 
                tmpt = iC3; 
        end  
end
assign oZ = tmpt;
endmodule