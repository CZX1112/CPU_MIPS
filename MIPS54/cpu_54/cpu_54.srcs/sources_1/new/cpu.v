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
    
    
    reg [31:0] temp;
    
    always @(posedge clk)
    begin
        temp <= rs;
    end
    
    //alu
    wire [3:0] aluc;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_c;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;

    //DIV
    wire DIV_start;
    wire [31:0] DIV_dividend;
    wire [31:0] DIV_divisor;
    wire [31:0] DIV_q;
    wire [31:0] DIV_r;
    wire DIV_busy;
    //DIVU
    wire DIVU_start;
    wire [31:0] DIVU_dividend;
    wire [31:0] DIVU_divisor;
    wire [31:0] DIVU_q;
    wire [31:0] DIVU_r;
    wire DIVU_busy;
    //MULT
    wire [31:0] MULT_a;
    wire [31:0] MULT_b;
    wire [63:0] MULT_z;

    //multu
    wire [31:0] multu_a;
    wire [31:0] multu_b;
    wire [63:0] multu_z;

    //HI
    wire [31:0] HI_data_in;
    wire [31:0] HI_data_out;
    wire HI_W;

    //LO
    wire [31:0] LO_data_in;
    wire [31:0] LO_data_out;
    wire LO_W;
    
    //CP0
    wire [31:0] CP0_pc;
    wire [4:0] CP0_Rd;
    wire [31:0] CP0_wdata;
    wire CP0_exception;
    wire [4:0] CP0_cause;
    wire [31:0] CP0_rdata;
    wire [31:0] CP0_status;
    wire [31:0] CP0_epc;
    wire [31:0] CP0_exc_addr;
    
    //Iram
    //wire [31:0] IM;
    
    //EXT
    wire [31:0] Ext5;
    wire [31:0] Ext16;
    wire [31:0] S_Ext16;
    wire [31:0] S_Ext18;
    
    wire [7:0] DExt8in;
    wire [7:0] DS_Ext8in;
    wire [15:0] DExt16in;
    wire [15:0] DS_Ext16in;
    
    wire [31:0] DExt8;
    wire [31:0] DS_Ext8;
    wire [31:0] DExt16;
    wire [31:0] DS_Ext16;
    
    //MUX
    wire M1_2;
    wire M1_1;
    wire M1_0;
    wire [31:0] M1_out;
    wire M2;
    wire [31:0] M2_out;
    wire M3_1;
    wire M3_0;
    wire [31:0] M3_out;
    wire M4_2;
    wire M4_1;
    wire M4_0;
    wire [31:0] M4_out;
    wire M5_1;
    wire M5_0;
    wire [4:0] M5_out;
    wire M6_1;
    wire M6_0;
    wire [31:0] M6_out;
    wire M7_1;
    wire M7_0;
    wire [31:0] M7_out;
    wire M8_2;
    wire M8_1;
    wire M8_0;
    wire [31:0] M8_out;
    wire M9_1;
    wire M9_0;
    wire [31:0] M9_out;

    
    //ADD
    wire [31:0] ADD_A;
    wire [31:0] ADD_B;
    wire [31:0] ADD_C;
    
    //Connect||
    wire [3:0] Connect_A;
    wire [27:0] Connect_B;
    wire [31:0] Connect_C;
    
    //CLZ
    wire [31:0] CLZ_in;
    wire [31:0] CLZ_out;
    
    //31ÌõÖ¸Áî
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
    
    //cpu54Ê£ÓàÖ¸Áî
    wire CLZ = (IM[31:26]==6'b011100) && (IM[5:0]==6'b100000);
    wire DIVU = (IM[31:26]==6'b0) && (IM[5:0]==6'b011011);
    wire ERET = (IM[31:26]==6'b010000) && (IM[25:21]==6'b10000) && (IM[5:0]==6'b011000);
    wire JALR = (IM[31:26]==6'b0) && (IM[20:16]==5'b0) && (IM[5:0]==6'b001001);
    wire LB = (IM[31:26]==6'b100000);
    wire LBU = (IM[31:26]==6'b100100);
    wire LHU = (IM[31:26]==6'b100101);
    wire SB = (IM[31:26]==6'b101000);
    wire SH = (IM[31:26]==6'b101001);
    wire LH = (IM[31:26]==6'b100001);
    wire MFC0 = (IM[31:26]==6'b010000) && (IM[25:21]==5'b0) && (IM[5:0]==6'b0);
    wire MFHI = (IM[31:26]==6'b0) && (IM[5:0]==6'b010000);
    wire MFLO = (IM[31:26]==6'b0) && (IM[5:0]==6'b010010);
    wire MTC0 = (IM[31:26]==6'b010000) && (IM[25:21]==5'b00100) && (IM[5:0]==6'b0);
    wire MTHI = (IM[31:26]==6'b0) && (IM[5:0]==6'b010001);
    wire MTLO = (IM[31:26]==6'b0) && (IM[5:0]==6'b010011);
    wire MUL = (IM[31:26]==6'b011100) && (IM[5:0]==6'b000010);
    wire MULTU = (IM[31:26]==6'b0) && (IM[5:0]==6'b011001);
    wire SYSCALL = (IM[31:26]==6'b0) && (IM[5:0]==6'b001100);
    wire TEQ = (IM[31:26]==6'b0) && (IM[5:0]==6'b110100);
    wire BGEZ = (IM[31:26]==6'b000001) && (IM[20:16]==5'b00001);
    wire BREAK = (IM[31:26]==6'b0) && (IM[5:0]==6'b001101);
    wire DIV = (IM[31:26]==6'b0) && (IM[5:0]==6'b011010);
    
    
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
                  SRAV||ADDI||ADDIU||ANDI||ORI||XORI||LW||SLTI||SLTIU||LUI||JAL||JALR||LBU||LHU||
                  LB||LH||MFHI||MFLO||MFC0||CLZ||MUL;
    assign RF_CLK = clk;
    
    //alu
    assign aluc[3] = SLT||SLTU||SLL||SRL||SRA||SLLV||SRLV||SRAV||SLTI||SLTIU||LUI||BGEZ;
    assign aluc[2] = AND||OR||XOR||NOR||SLL||SRL||SRA||SLLV||SRLV||SRAV||ANDI||ORI||XORI;
    assign aluc[1] = ADD||SUB||XOR||NOR||SLT||SLTU||SLL||SLLV||ADDI||XORI||SLTI||SLTIU||JAL||BGEZ||JALR;
    assign aluc[0] = SUB||SUBU||OR||NOR||SLT||SRL||SRLV||ORI||BEQ||BNE||SLTI||BGEZ||TEQ;
    assign alu_a = M3_out;
    assign alu_b = M4_out;
    
    //MUX
    assign M1_2 = BREAK||SYSCALL||ERET||(TEQ && (zero == 0));
    assign M1_1 = (BEQ && (zero == 1))||(BNE && (zero == 0))||J||JAL||(BGEZ && (negative == 1'b0));
    assign M1_0 = JR||J||JAL||JALR||ERET;
    assign M2 = LW||LBU||LHU||LB||LH||MFHI||MFLO||MFC0||CLZ||MUL;
    assign M3_1 = JAL||JALR;
    assign M3_0 = ADD||ADDU||SUB||SUBU||AND||OR||XOR||NOR||SLT||SLTU||SLLV||SRLV||SRAV||ADDI||
                ADDIU||ANDI||ORI||XORI||LW||SW||BEQ||BNE||SLTI||SLTIU||DIV||DIVU||MUL||MULTU||
                BGEZ||LBU||LHU||LB||LH||SB||SH||MTHI||MTLO||CLZ||TEQ;
    assign M4_2 = BGEZ;
    assign M4_1 = ADDI||ADDIU||LW||SW||SLTI||JAL||JALR||LBU||LHU||LB||LH||SB||SH;
    assign M4_0 = ANDI||ORI||XORI||SLTIU||LUI||JAL||JALR;
    assign M5_1 = JAL;
    assign M5_0 = ADDI||ADDIU||ANDI||ORI||XORI||LW||SLTI||SLTIU||LUI||LBU||LHU||LB||LH||MFC0;
    assign M6_1 = MTHI||MTLO||MULTU;
    assign M6_0 = DIVU||MTHI||MTLO;
    assign M7_1 = MTHI||MTLO||MULTU;
    assign M7_0 = DIVU||MTHI||MTLO;
    assign M8_2 = LW||MFHI||MFLO||MFC0||CLZ||MUL;
    assign M8_1 = LHU||LH||MFC0||CLZ;
    assign M8_0 = LB||LH||MFHI||MFLO||CLZ||MUL;
    assign M9_1 = MUL;
    assign M9_0 = MFLO;
    
    //Dram
    assign CS = LW||SW||LBU||LHU||LB||LH||SB||SH;
    assign DM_R = LW||LBU||LHU||LB||LH;
    assign DM_W = SW||SB||SH;
    assign DM_addr = alu_c;
    assign DM_WData = (SH && DM_addr[1]==1'b0) ? {DM_RData[31:16], rt[15:0]} : (SH && DM_addr[1]==1'b1) ? {rt[15:0], DM_RData[15:0]}:(SB && DM_addr[1:0]==2'b00) ? {DM_RData[31:8], rt[7:0]} : (SB && DM_addr[1:0]==2'b01) ? {DM_RData[31:15], rt[7:0], DM_RData[7:0]}:(SB && DM_addr[1:0]==2'b10) ?{DM_RData[31:24], rt[7:0], DM_RData[15:0]}:(SB && DM_addr[1:0]==2'b11) ?{rt[7:0], DM_RData[23:0]}:rt;
    
    //Connect||
    assign Connect_A = PC_out[31:28];
    assign Connect_B = {IM[25:0],2'b00};
    assign Connect_C = {Connect_A,Connect_B};
    
    //ADD
    assign ADD_A = S_Ext18;
    assign ADD_B = NPC;
    assign ADD_C = ADD_A + ADD_B;
    
    //CLZ
    assign CLZ_in = rs;
    
    //DIV
    assign DIV_start = DIV&&~DIV_busy;
    assign DIV_dividend = rs;
    assign DIV_divisor = rt;
    //DIVU
    assign DIVU_start = DIVU&&~DIVU_busy;
    assign DIVU_dividend = rs;
    assign DIVU_divisor = rt;
    //MULT
    assign MULT_a = rs;
    assign MULT_b = rt;
    //multu
    assign multu_a = rs;
    assign multu_b = rt;
    
    //HI
    assign HI_data_in = M6_out;
    assign HI_W = DIV||DIVU||MULTU||MTHI;
    //LO
    assign LO_data_in = M7_out;
    assign LO_W = DIV||DIVU||MULTU||MTLO;
    
    //CP0
    assign CP0_pc = NPC;
    assign CP0_Rd = IM[15:11];
    assign CP0_wdata = rt;
    assign CP0_exception = BREAK||SYSCALL||(TEQ && (zero == 0));
    assign CP0_cause = BREAK ? 5'b01001:SYSCALL ? 5'b01000:TEQ ? 5'b01101:0;
    
    
    //assign NPC = PC_out + 4;
    assign NPC = (DIV_busy||DIVU_busy) ? PC_out : (PC_out + 4);
    
    
    //EXT
    assign DS_Ext8in = (LB && DM_addr[1:0]==2'b00) ? DM_RData[7:0]:(LB && DM_addr[1:0]==2'b01) ? DM_RData[15:8]:(LB && DM_addr[1:0]==2'b10) ? DM_RData[23:16]:(LB && DM_addr[1:0]==2'b11) ? DM_RData[31:24]:8'b0;
    assign DExt8in = (LBU && DM_addr[1:0]==2'b00) ? DM_RData[7:0]:(LBU && DM_addr[1:0]==2'b01) ? DM_RData[15:8]:(LBU && DM_addr[1:0]==2'b10) ? DM_RData[23:16]:(LBU && DM_addr[1:0]==2'b11) ? DM_RData[31:24]:8'b0;
    assign DS_Ext16in = (LH && DM_addr[1]==1'b0) ? DM_RData[15:0]:(LH && DM_addr[1]==1'b1) ? DM_RData[31:16]:16'b0;
    assign DExt16in = (LHU && DM_addr[1]==1'b0) ? DM_RData[15:0]:(LHU && DM_addr[1]==1'b1) ? DM_RData[31:16]:16'b0;
    
    Ext5 E5(IM[10:6],Ext5);
    Ext16 E16(IM[15:0],Ext16);
    S_Ext16 S_E16(IM[15:0],S_Ext16);
    S_Ext18 S_E18({IM[15:0],2'b00},S_Ext18);
    
    Ext8 DE8(DExt8in,DExt8);
    S_Ext8 S_DE8(DS_Ext8in,DS_Ext8);
    Ext16 DE16(DExt16in,DExt16);
    S_Ext16 S_DE16(DS_Ext16in,DS_Ext16);
    
    
    
    CLZ clz(CLZ_in,CLZ_out);


    MUX8 MUX1(NPC,temp,ADD_C,Connect_C,CP0_exc_addr,CP0_epc,CP0_rdata,0,M1_2,M1_1,M1_0,M1_out);
    assign M2_out = M2==0 ? alu_c:M8_out;
    MUX MUX3(Ext5,rs,4,0,M3_1,M3_0,M3_out);
    MUX8 MUX4(rt,Ext16,S_Ext16,PC_out,0,0,0,0,M4_2,M4_1,M4_0,M4_out);
    MUX_5bit MUX5(IM[15:11],IM[20:16],5'b11111,0,M5_1,M5_0,M5_out);
    MUX MUX6(DIV_r,DIVU_r,multu_z[63:32],rs,M6_1,M6_0,M6_out);
    MUX MUX7(DIV_q,DIVU_q,multu_z[31:0],rs,M7_1,M7_0,M7_out);
    MUX MUX9(HI_data_out,LO_data_out,MULT_z[31:0],0,M9_1,M9_0,M9_out);
    MUX8 MUX8(DExt8,DS_Ext8,DExt16,DS_Ext16,DM_RData,M9_out,CP0_rdata,CLZ_out,M8_2,M8_1,M8_0,M8_out);

    
    MULT MULT(clk,rst,MULT_a,MULT_b,MULT_z);
    multu multu(clk,rst,multu_a,multu_b,multu_z);
    DIV div(DIV_dividend,DIV_divisor,DIV_start,clk,rst,DIV_q,DIV_r,DIV_busy);
    DIVU divu(DIVU_dividend,DIVU_divisor,DIVU_start,clk,rst,DIVU_q,DIVU_r,DIVU_busy);
    

    pcreg pcreg_HI(clk,rst,HI_W,HI_data_in,HI_data_out);
    pcreg pcreg_LO(clk,rst,LO_W,LO_data_in,LO_data_out);
    
    pcreg pcreg(PC_CLK,rst,ena,PC_in,PC_out);
    
    alu alu(alu_a,alu_b,aluc,alu_c,zero,carry,negative,overflow);
    
    regfile cpu_ref(RF_CLK,rst,1'b1,RF_W,rsc,rtc,rdc,rd,rs,rt);
    
    CP0 CP0(clk,rst,MFC0,MTC0,CP0_pc,CP0_Rd,CP0_wdata,CP0_exception,ERET,CP0_cause,CP0_rdata,CP0_status,CP0_epc,CP0_exc_addr);
    

endmodule