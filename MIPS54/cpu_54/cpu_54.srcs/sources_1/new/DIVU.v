module DIVU(
    input [31:0] dividend,          //������
    input [31:0] divisor,           //����
    input start,                    //��ʼ����
    input clock,                    //ʱ��
    input reset,                    //��λ
    output [31:0] q,                //��
    output [31:0] r,                //����    
    output reg busy                 //������æ��־λ
    );
    reg [4:0] count;
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    reg r_sign;
    wire [32:0] sub_add = r_sign?({reg_r,q[31]} + {1'b0,reg_b}):({reg_r,q[31]} - {1'b0,reg_b});    //�ӡ�������
    assign r = r_sign? reg_r + reg_b : reg_r;
    assign q = reg_q;
    
    always @ (posedge clock or posedge reset)
    begin
        if (reset == 1) 
        begin                                           //����
            count <=5'b0;
            busy <= 0;
        end 
        
        else
        begin
            if (start)
            begin                                       //��ʼ�������㣬��ʼ��
                reg_r <= 32'b0;
                r_sign <= 0;
                reg_q <= dividend;
                reg_b <= divisor;
                count <= 5'b0;
                busy <= 1'b1;
            end
            else if (busy)
            begin                                       //ѭ������
                reg_r <= sub_add[31:0];                 //��������
                r_sign <= sub_add[32];                  //���Ϊ�����´����
                reg_q <= {reg_q[30:0],~sub_add[32]};
                count <= count +5'b1;                   //��������һ
                if (count == 31)
                    busy <= 0;                          //������������
            end
        end
    end
endmodule
