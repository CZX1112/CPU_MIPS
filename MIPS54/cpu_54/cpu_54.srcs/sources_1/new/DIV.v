module DIV(
    input [31:0] dividend,      //被除数
    input [31:0] divisor,       //除数
    input start,                //开始运算
    input clock,                //时钟
    input reset,                //复位
    output [31:0] q,            //商
    output [31:0] r,            //余数
    output reg busy             //除法器忙标志位
    );
    reg [5:0] count;            //计数器
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    wire [31:0] reg_r2;
    reg r_sign;
    wire [32:0] sub_add = r_sign? ({reg_r, reg_q[31]} + {1'b0, reg_b}):({reg_r, reg_q[31]} - {1'b0, reg_b});    //加减法器
    assign reg_r2 = r_sign ? reg_r + reg_b : reg_r;
    assign r = dividend[31] ? (~reg_r2 + 1) : reg_r2;
    assign q = (divisor[31]^dividend[31]) ? (~reg_q + 1) : reg_q;
    
    always @ (posedge clock or posedge reset)
    begin
        if (reset)
        begin
            count <= 0;                         //重置
            busy <= 0;
        end
        
        else
        begin
            if (start)                          //开始除法运算，初始化
            begin
                reg_r <= 32'b0;
                r_sign <= 0;
                if (dividend[31] == 1)
                    reg_q <= ~dividend+1;
                else
                    reg_q <= dividend;
                if(divisor[31] == 1)
                    reg_b <= ~divisor+1;
                else
                    reg_b <= divisor;
                count <= 0;
                busy <= 1;
            end
            else if (busy)
            begin
                reg_r <= sub_add[31:0];         //循环操作
                r_sign <= sub_add[32];          //部分余数
                reg_q <= {reg_q[30:0],~sub_add[32]};
                count <= count + 1;             //计数器加一
                if(count == 31)                 //结束除法运算
                    busy <= 0;
            end
        end
    end
endmodule
