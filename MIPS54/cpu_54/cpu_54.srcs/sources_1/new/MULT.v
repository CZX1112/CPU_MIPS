module MULT(
input clk, //乘法器时钟信号
input reset, //复位信号，低电平有效
input [31:0] a, //输入数 a(被乘数)
input [31:0] b, //输入数 b（乘数）
output [63:0] z //乘积输出 z
); 

  reg [63:0] temp;
  wire [31:0] a0,b0;//a，b绝对值
  reg [31:0] a1=0,b1=0;//时钟时刻a，b
  reg as=0,bs=0,zs=0;
  
  reg [63:0] stored00=0; reg [63:0] stored01=0; reg [63:0] stored02=0; reg [63:0] stored03=0; reg [63:0] stored04=0; reg [63:0] stored05=0; reg [63:0] stored06=0; reg [63:0] stored07=0;
  reg [63:0] stored08=0; reg [63:0] stored09=0; reg [63:0] stored10=0; reg [63:0] stored11=0; reg [63:0] stored12=0; reg [63:0] stored13=0; reg [63:0] stored14=0; reg [63:0] stored15=0;
  reg [63:0] stored16=0; reg [63:0] stored17=0; reg [63:0] stored18=0; reg [63:0] stored19=0; reg [63:0] stored20=0; reg [63:0] stored21=0; reg [63:0] stored22=0; reg [63:0] stored23=0;
  reg [63:0] stored24=0; reg [63:0] stored25=0; reg [63:0] stored26=0; reg [63:0] stored27=0; reg [63:0] stored28=0; reg [63:0] stored29=0; reg [63:0] stored30=0; reg [63:0] stored31=0;
  
 reg [63:0] add00_01, add02_03, add04_05, add06_07, add08_09, add10_11, add12_13, add14_15,add16_17, add18_19, add20_21, add22_23, add24_25, add26_27, add28_29, add30_31;
 
 reg [63:0] add00_03, add04_07, add08_11, add12_15, add16_19, add20_23, add24_27, add28_31;

 reg [63:0] add00_07, add08_15, add16_23, add24_31;

 reg [63:0] add00_15, add16_31;
 
  assign a0 = as ? (~a1+1) : a1;
  assign b0 = bs ? (~b1+1) : b1;
  assign z = zs ? (~temp+1):temp;
  always @(*) 
  begin
   if(reset)
   begin
     temp<=0;  as=0;bs=0;zs=0; a1=0;b1=0;
     stored00<=0; stored01<=0; stored02<=0; stored03<=0; stored04<=0; stored05<=0; stored06<=0; stored07<=0;
     stored08<=0; stored09<=0; stored10<=0; stored11<=0; stored12<=0; stored13<=0; stored14<=0; stored15<=0;
     stored16<=0; stored17<=0; stored18<=0; stored19<=0; stored20<=0; stored21<=0; stored22<=0; stored23<=0;
     stored24<=0; stored25<=0; stored26<=0; stored27<=0; stored28<=0; stored29<=0; stored30<=0; stored31<=0;
     
     add00_01 <= 0; add02_03 <= 0; add04_05 <= 0; add06_07 <= 0; add08_09 <= 0; add10_11 <= 0; add12_13 <= 0; add14_15 <= 0;
     add16_17 <= 0; add18_19 <= 0; add20_21 <= 0; add22_23 <= 0; add24_25 <= 0; add26_27 <= 0; add28_29 <= 0; add30_31 <= 0;
      
     add00_03 <= 0; add04_07 <= 0; add08_11 <= 0; add12_15 <= 0; add16_19 <= 0; add20_23 <= 0; add24_27 <= 0; add28_31 <= 0;
     
     add00_07 <= 0; add08_15 <= 0; add16_23 <= 0; add24_31 <= 0;
     
     add00_15 <= 0; add16_31 <= 0;
   end
   else 
   begin
    as <= a[31];    bs <= b[31];
    a1 <= a;        b1 <= b;

    stored00 <= b0[0]? {32'b0, a0} :64'b0;         stored01 <= b0[1]? {31'b0, a0, 1'b0} :64'b0;
    stored02 <= b0[2]? {30'b0, a0, 2'b0} :64'b0;   stored03 <= b0[3]? {29'b0, a0, 3'b0} :64'b0;
    stored04 <= b0[4]? {28'b0, a0, 4'b0} :64'b0;   stored05 <= b0[5]? {27'b0, a0, 5'b0} :64'b0;
    stored06 <= b0[6]? {26'b0, a0, 6'b0} :64'b0;   stored07 <= b0[7]? {25'b0, a0, 7'b0} :64'b0;
    stored08 <= b0[8]? {24'b0, a0, 8'b0} :64'b0;   stored09 <= b0[9]? {23'b0, a0, 9'b0} :64'b0;
    stored10 <= b0[10]? {22'b0, a0, 10'b0} :64'b0; stored11 <= b0[11]? {21'b0, a0, 11'b0} :64'b0;
    stored12 <= b0[12]? {20'b0, a0, 12'b0} :64'b0; stored13 <= b0[13]? {19'b0, a0, 13'b0} :64'b0;
    stored14 <= b0[14]? {18'b0, a0, 14'b0} :64'b0; stored15 <= b0[15]? {17'b0, a0, 15'b0} :64'b0;
    stored16 <= b0[16]? {16'b0, a0, 16'b0} :64'b0; stored17 <= b0[17]? {15'b0, a0, 17'b0} :64'b0;
    stored18 <= b0[18]? {14'b0, a0, 18'b0} :64'b0; stored19 <= b0[19]? {13'b0, a0, 19'b0} :64'b0;
    stored20 <= b0[20]? {12'b0, a0, 20'b0} :64'b0; stored21 <= b0[21]? {11'b0, a0, 21'b0} :64'b0;
    stored22 <= b0[22]? {10'b0, a0, 22'b0} :64'b0; stored23 <= b0[23]? {9'b0, a0, 23'b0} :64'b0;
    stored24 <= b0[24]? {8'b0, a0, 24'b0} :64'b0;  stored25 <= b0[25]? {7'b0, a0, 25'b0} :64'b0;
    stored26 <= b0[26]? {6'b0, a0, 26'b0} :64'b0;  stored27 <= b0[27]? {5'b0, a0, 27'b0} :64'b0;
    stored28 <= b0[28]? {4'b0, a0, 28'b0} :64'b0;  stored29 <= b0[29]? {3'b0, a0, 29'b0} :64'b0;
    stored30 <= b0[30]? {2'b0, a0, 30'b0} :64'b0;  stored31 <= b0[31]? {1'b0, a0, 31'b0} :64'b0;

    add00_01 <= stored00+stored01; add02_03 <= stored02+stored03; add04_05 <= stored04+stored05; add06_07 <= stored06+stored07;
    add08_09 <= stored08+stored09; add10_11 <= stored10+stored11; add12_13 <= stored12+stored13; add14_15 <= stored14+stored15;
    add16_17 <= stored16+stored17; add18_19 <= stored18+stored19; add20_21 <= stored20+stored21; add22_23 <= stored22+stored23;
    add24_25 <= stored24+stored25; add26_27 <= stored26+stored27; add28_29 <= stored28+stored29; add30_31 <= stored30+stored31;

    add00_03 <= add00_01+add02_03; add04_07 <= add04_05+add06_07; add08_11 <= add08_09+add10_11; add12_15 <= add12_13+add14_15;
    add16_19 <= add16_17+add18_19; add20_23 <= add20_21+add22_23; add24_27 <= add24_25+add26_27; add28_31 <= add28_29+add30_31;

    add00_07 <= add00_03+add04_07; add08_15 <= add08_11+add12_15; add16_23 <= add16_19+add20_23; add24_31 <= add24_27+add28_31;

    add00_15 <= add00_07+add08_15; add16_31 <= add16_23+add24_31;

    temp <= add00_15+add16_31;
    
    zs<=as+bs;
   end
   end
   
endmodule
