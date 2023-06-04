module cpu(
    input clk,
    input rst,
    //data(instruction) from iram
    input [31:0] IM,
    //data exchanged with dram
    output [31:0] DM_addr,
    input [31:0] DM_RData,
    output [31:0] DM_WData,
    //control of dram
    output CS,
    output DM_W,
    output DM_R,
    //output of pcre
    output [31:0] PC_out
    );
    
    //Dram
    /*
    assign CS = LW||SW;
    assign DM_R = LW;
    assign DM_W = SW;
    assign DM_addr = alu_c;
    assign DM_WData = rt;
    
    */
    
    //pcreg
    wire PC_CLK;
    wire ena;
    wire [31:0] PC_in;
    //wire [31:0] PC_out;
    
    //NPC
    wire [31:0] NPC;
    
    //regfile
    wire [31:0] rs;
    wire [31:0] rt;
    wire [31:0] rd;
    wire [4:0] rdc;
    wire [4:0] rsc;
    wire [4:0] rtc;
    wire RF_CLK;
    wire RF_W;
    
    //alu
    wire [3:0] aluc;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_c;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    
    //Dram
    /*wire [31:0] DM_addr;
    wire [31:0] DM_WData;
    wire [31:0] DM_RData;
    wire CS;
    wire DM_W;
    wire DM_R;*/
    
    //Iram
    //wire [31:0] IM;
    
    //EXT
    wire [31:0] Ext5;
    wire [31:0] Ext16;
    wire [31:0] S_Ext16;
    wire [31:0] S_Ext18;
    
    //MUX
    wire M1_1;
    wire M1_0;
    wire [31:0] M1_out;
    wire M2;
    wire [31:0] M2_out;
    wire M3_1;
    wire M3_0;
    wire [31:0] M3_out;
    wire M4_1;
    wire M4_0;
    wire [31:0] M4_out;
    wire M5_1;
    wire M5_0;
    wire [4:0] M5_out;
    
    //ADD
    wire [31:0] ADD_A;
    wire [31:0] ADD_B;
    wire [31:0] ADD_C;
    
    //Connect||
    wire [3:0] Connect_A;
    wire [27:0] Connect_B;
    wire [31:0] Connect_C;
    
    //ЦёБо
    wire ADD = (IM[31:26]==6'b0) && (IM[5:0]==6'b100000);
    wire ADDU = (IM[31:26]==6'b0) && (IM[5:0]==6'b100001);
    wire SUB = (IM[31:26]==6'b0) && (IM[5:0]==6'b100010);
    wire SUBU = (IM[31:26]==6'b0) && (IM[5:0]==6'b100011);
    wire AND = (IM[31:26]==6'b0) && (IM[5:0]==6'b100100);
    wire OR = (IM[31:26]==6'b0) && (IM[5:0]==6'b100101);
    wire XOR = (IM[31:26]==6'b0) && (IM[5:0]==6'b100110);
    wire NOR = (IM[31:26]==6'b0) && (IM[5:0]==6'b100111);
    wire SLT = (IM[31:26]==6'b0) && (IM[5:0]==6'b101010);
    wire SLTU = (IM[31:26]==6'b0) && (IM[5:0]==6'b101011);
    wire SLL = (IM[31:26]==6'b0) && (IM[5:0]==6'b000000);
    wire SRL = (IM[31:26]==6'b0) && (IM[5:0]==6'b000010);
    wire SRA = (IM[31:26]==6'b0) && (IM[5:0]==6'b000011);
    wire SLLV = (IM[31:26]==6'b0) && (IM[5:0]==6'b000100);
    wire SRLV = (IM[31:26]==6'b0) && (IM[5:0]==6'b000110);
    wire SRAV = (IM[31:26]==6'b0) && (IM[5:0]==6'b000111);
    wire JR = (IM[31:26]==6'b0) && (IM[5:0]==6'b001000);
    
    wire ADDI = (IM[31:26]==6'b001000);
    wire ADDIU = (IM[31:26]==6'b001001);
    wire ANDI = (IM[31:26]==6'b001100);
    wire ORI = (IM[31:26]==6'b001101);
    wire XORI = (IM[31:26]==6'b001110);
    wire LW = (IM[31:26]==6'b100011);
    wire SW = (IM[31:26]==6'b101011);
    wire BEQ = (IM[31:26]==6'b000100);
    wire BNE = (IM[31:26]==6'b000101);
    wire SLTI = (IM[31:26]==6'b001010);
    wire SLTIU = (IM[31:26]==6'b001011);
    wire LUI = (IM[31:26]==6'b001111);
    
    wire J = (IM[31:26]==6'b000010);
    wire JAL = (IM[31:26]==6'b000011);
    
    //pcreg
    assign PC_CLK = clk;
    assign ena = 1;
    assign PC_in = M1_out;
    
    //Regfiles
    assign rd = M2_out;
    assign rdc = M5_out;
    assign rsc = IM[25:21];
    assign rtc = IM[20:16];
    assign RF_W = ADD||ADDU||SUB||SUBU||AND||OR||XOR||NOR||SLT||SLTU||SLL||SRL||SRA||SLLV||SRLV||
                  SRAV||ADDI||ADDIU||ANDI||ORI||XORI||LW||SLTI||SLTIU||LUI||JAL;
    assign RF_CLK = clk;
    
    //alu
    assign aluc[3] = SLT||SLTU||SLL||SRL||SRA||SLLV||SRLV||SRAV||SLTI||SLTIU||LUI;
    assign aluc[2] = AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||ANDI||ORI||XORI;
    assign aluc[1] = ADD||SUB||XOR||NOR||SLT||SLTU||SLL||SLLV||ADDI||XORI||SLTI||SLTIU||JAL;
    assign aluc[0] = SUB||SUBU||OR||NOR||SLT||SRL||SRLV||ORI||BEQ||BNE||SLTI;
    assign alu_a = M3_out;
    assign alu_b = M4_out;
    
    //MUX
    assign M1_1 = (BEQ && (zero == 1))||(BNE && (zero == 0))||J||JAL;
    assign M1_0 = JR||J||JAL;
    assign M2 = LW;
    assign M3_1 = JAL;
    assign M3_0 = ADD||ADDU||SUB||SUBU||AND||OR||XOR||NOR||SLT||SLTU||SLLV||SRLV||SRAV||ADDI||
                ADDIU||ANDI||ORI||XORI||LW||SW||BEQ||BNE||SLTI||SLTIU;
    assign M4_1 = ADDI||ADDIU||LW||SW||SLTI||JAL;
    assign M4_0 = ANDI||ORI||XORI||SLTIU||LUI||JAL;
    assign M5_1 = JAL;
    assign M5_0 = ADDI||ADDIU||ANDI||ORI||XORI||LW||SLTI||SLTIU||LUI;
    
    //Dram
    assign CS = LW||SW;
    assign DM_R = LW;
    assign DM_W = SW;
    assign DM_addr = alu_c;
    assign DM_WData = rt;
    
    //Connect||
    assign Connect_A = PC_out[31:28];
    assign Connect_B = {IM[25:0],2'b00};
    assign Connect_C = {Connect_A,Connect_B};
    
    //ADD
    assign ADD_A = S_Ext18;
    assign ADD_B = NPC;
    assign ADD_C = ADD_A + ADD_B;
    
    assign NPC = PC_out + 4;
    
    Ext5 E5(IM[10:6],Ext5);
    Ext16 E16(IM[15:0],Ext16);
    S_Ext16 S_E16(IM[15:0],S_Ext16);
    S_Ext18 S_E18({IM[15:0],2'b00},S_Ext18);
    
    MUX MUX1(NPC,rs,ADD_C,Connect_C,M1_1,M1_0,M1_out);
    //MUX MUX2(alu_c,DM_RData,ADD_C,0,M2_1,M2_0,M2_out);
    assign M2_out = M2==0?alu_c:DM_RData;
    //assign M3_out = M3==0?Ext5:rs;
    MUX MUX3(Ext5,rs,4,0,M3_1,M3_0,M3_out);
    MUX MUX4(rt,Ext16,S_Ext16,PC_out,M4_1,M4_0,M4_out);
    //assign M5_out = M5==0?S_Ext18:4;
    MUX_5bit MUX5(IM[15:11],IM[20:16],31,0,M5_1,M5_0,M5_out);
    
    pcreg pcreg(PC_CLK,rst,ena,PC_in,PC_out);
    
    alu alu(alu_a,alu_b,aluc,alu_c,zero,carry,negative,overflow);
    
    regfile cpu_ref(RF_CLK,rst,1,RF_W,rsc,rtc,rdc,rd,rs,rt);
    
    //Dram Dram(clk,CS,DM_W,DM_R,DM_addr,DM_WData,DM_RData);
    
    
    
endmodule