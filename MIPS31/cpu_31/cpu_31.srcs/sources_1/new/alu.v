module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
    reg [31:0] oTmpt;
    always@(*)
        case(aluc)
            4'b0000:r=a+b;
            4'b0010:r=$signed(a)+$signed(b);
            4'b0001:r=a-b;
            4'b0011:r=a-b;
            4'b0100:r=a&b;
            4'b0101:r=a|b;
            4'b0110:r=a^b;
            4'b0111:r=~(a|b);
            4'b1000:r={b[15:0],16'b0};
            4'b1001:r={b[15:0],16'b0};
            4'b1011:r=($signed(a)<$signed(b))?1:0;
            4'b1010:r=(a<b)?1:0;
            4'b1100:r=$signed(b)>>>a;
            4'b1110:r=b<<a;
            4'b1111:r=b<<a;
            4'b1101:r=b>>a;
            default:r=32'h00000000;
        endcase
        
    //zero
    always@(*)  
        if(aluc==4'b1011||aluc==4'b1010)
            if(a==b)
                zero=1'b1;
            else
                zero=1'b0;
        else if(r==0)
            zero=1'b1;
        else
            zero=1'b0;
            
    //negative
    always@(*)
        if(aluc==4'b0010||aluc==4'b0011)
            if($signed(r)<0)
                negative=1'b1;
            else
                negative=1'b0;
        else if(aluc==4'b1011)
            if(r==1'b1)
                negative=1'b1;
            else
                negative=1'b0;
        else
            if(r[31]==1'b1)
                negative=1'b1;
            else
                negative=1'b0;
                
    //carry
    always@(*)
        if(aluc==4'b0000)
            if(a[31]==1'b1&&b[31]==1'b1)
                carry=1'b1;
            else if(a[31]==1'b1&&b[31]==1'b0&&r[31]==1'b0)
                carry=1'b1;
            else if(a[31]==1'b0&&b[31]==1'b1&&r[31]==1'b0)
                carry=1'b1;
            else
                carry=1'b0;
        else if(aluc==4'b0001)
            if(a<b)
                carry=1'b1;
            else
                carry=1'b0;
        else if(aluc==4'b1010)
            if(a<b)
                carry=1'b1;
            else
                carry=1'b0;
        else if(aluc==4'b1100)
            begin
            oTmpt=$signed(b)>>>(a-1);
            carry=oTmpt[0];
            end
        else if(aluc==4'b1101)
            begin
            oTmpt=b>>>(a-1);
            carry=oTmpt[0];
            end
        else if(aluc==4'b1110||aluc==4'b1111)
            begin
            oTmpt=b<<(a-1);
            carry=oTmpt[31];
            end
        
    //overflow
    always@(*)
        if(aluc==4'b0010)
            if(a[31]==b[31]&&~r[31]==a[31])
                overflow=1'b1;
            else
                overflow=1'b0;
        else if(aluc==4'b0011)
            if(a[31]==0&&b[31]==1&&r[31]==1)
                overflow=1'b1;
            else if(a[31]==1&&b[31]==0&&r[31]==0)
                overflow=1'b1;
            else
                overflow=1'b0;
            
endmodule