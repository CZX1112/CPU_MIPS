module DIV(
    input [31:0] dividend,      //������
    input [31:0] divisor,       //����
    input start,                //��ʼ����
    input clock,                //ʱ��
    input reset,                //��λ
    output [31:0] q,            //��
    output [31:0] r,            //����
    output reg busy             //������æ��־λ
    );
    reg [5:0] count;            //������
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    wire [31:0] reg_r2;
    reg r_sign;
    wire [32:0] sub_add = r_sign? ({reg_r, reg_q[31]} + {1'b0, reg_b}):({reg_r, reg_q[31]} - {1'b0, reg_b});    //�Ӽ�����
    assign reg_r2 = r_sign ? reg_r + reg_b : reg_r;
    assign r = dividend[31] ? (~reg_r2 + 1) : reg_r2;
    assign q = (divisor[31]^dividend[31]) ? (~reg_q + 1) : reg_q;
    
    always @ (posedge clock or posedge reset)
    begin
        if (reset)
        begin
            count <= 0;                         //����
            busy <= 0;
        end
        
        else
        begin
            if (start)                          //��ʼ�������㣬��ʼ��
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
                reg_r <= sub_add[31:0];         //ѭ������
                r_sign <= sub_add[32];          //��������
                reg_q <= {reg_q[30:0],~sub_add[32]};
                count <= count + 1;             //��������һ
                if(count == 31)                 //������������
                    busy <= 0;
            end
        end
    end
endmodule
