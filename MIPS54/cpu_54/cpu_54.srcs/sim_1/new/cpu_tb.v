`timescale 1ns / 1ps
module cpu_tb(

    );
        reg clk_in;
        reg reset;
        reg start;
        wire[7:0] o_seg;
        wire[7:0] o_sel;
        
        
        sccomp_dataflow sc(clk_in, reset, o_seg, o_sel);
        
        wire [31:0] pc_tb = sc.pc;
        wire [31:0] instr_tb = sc.inst;
        
        /*wire [31:0] M1_out = sc.sccpu.M1_out;
        wire [31:0] NPC = sc.sccpu.NPC;
        wire [31:0] rd = sc.sccpu.rd;
        wire [31:0] rs = sc.sccpu.rs;
        wire [31:0] rt = sc.sccpu.rt;
        wire [31:0] alu_a = sc.sccpu.alu_a;
        wire [31:0] alu_b = sc.sccpu.alu_b;
        wire [31:0] alu_c = sc.sccpu.alu_c;
        wire [31:0] Ext5 = sc.sccpu.Ext5;
        wire [31:0] Ext16 = sc.sccpu.Ext16;
        wire [31:0] S_Ext16 = sc.sccpu.S_Ext16;
        wire [31:0] S_Ext18 = sc.sccpu.S_Ext18;
        wire [4:0] rsc = sc.sccpu.rsc;
        wire [4:0] rtc = sc.sccpu.rtc;
        wire M4_1 = sc.sccpu.M4_1;
        wire M4_0 = sc.sccpu.M4_0;
        
        wire [31:0] DM_addr = sc.DM_addr;
        wire [31:0] dm_addr = sc.dm_addr;
        
        wire CS = sc.CS;
        wire DM_R = sc.DM_R;*/
        //wire [31:0] CLZ_out = sc.sccpu.CLZ_out;
        //wire [31:0] M8_out = sc.sccpu.M8_out;
        /*wire [31:0] rd = sc.sccpu.rd;
        wire [31:0] rs = sc.sccpu.rs;
        wire [31:0] rsc = sc.sccpu.rsc;
        wire [31:0] rtc = sc.sccpu.rtc;
        wire [31:0] rdc = sc.sccpu.rdc;
        wire [31:0] RF_W = sc.sccpu.RF_W;
        
        wire [31:0] CP0_rdata = sc.sccpu.CP0_rdata;
        wire MTHI = sc.sccpu.MTHI;
        wire MFHI = sc.sccpu.MFHI;
        wire [31:0] LO_data_out = sc.sccpu.LO_data_out;
        //wire M_LO = sc.sccpu.M_LO;
        wire LO_W = sc.sccpu.LO_W;
        wire [31:0] LO_data_in = sc.sccpu.LO_data_in;
        
        wire [63:0] MULT_z = sc.sccpu.MULT_z;
        wire [31:0] M9_out = sc.sccpu.M9_out;
        wire [31:0] M8_out = sc.sccpu.M8_out;
        wire [31:0] M2_out = sc.sccpu.M2_out;
        wire [31:0] M7_out = sc.sccpu.M7_out;
        wire [31:0] multu_z = sc.sccpu.multu_z;
        
        wire M8_2 = sc.sccpu.M8_2;
        wire M8_1 = sc.sccpu.M8_1;
        wire M8_0 = sc.sccpu.M8_0;
        
        wire [31:0] DExt8 = sc.sccpu.DExt8;
        wire [31:0] DS_Ext8 = sc.sccpu.DS_Ext8;
        wire [31:0] DExt16 = sc.sccpu.DExt16;
        wire [31:0] DS_Ext16 = sc.sccpu.DS_Ext16;
        
        wire [31:0] DM_RData = sc.sccpu.DM_RData;
        wire [31:0] DM_WData = sc.sccpu.DM_WData;
        wire [31:0] DM_addr = sc.sccpu.DM_addr;
        wire [31:0] rt = sc.sccpu.rt;
        wire DM_R = sc.sccpu.DM_R;
        wire DM_W = sc.sccpu.DM_W;
        wire CS = sc.sccpu.CS;
        
        wire [31:0] DS_Ext8in = sc.sccpu.DS_Ext8in;
        
        wire LB = sc.sccpu.LB;
        wire LBU = sc.sccpu.LBU;
        wire LHU = sc.sccpu.LHU;
        wire SB = sc.sccpu.SB;
        wire SH = sc.sccpu.SH;
        wire LH = sc.sccpu.LH;
        
        wire [31:0] M1_out = sc.sccpu.M1_out;
        wire M1_2 = sc.sccpu.M1_2;
        wire M1_1 = sc.sccpu.M1_1;
        wire M1_0 = sc.sccpu.M1_0;
        wire negative = sc.sccpu.negative;
        wire BGEZ = sc.sccpu.BGEZ;
        
        wire [31:0] M3_out = sc.sccpu.M3_out;
        wire [31:0] M4_out = sc.sccpu.M4_out;
        
        wire [31:0] CP0_exc_addr = sc.sccpu.CP0_exc_addr;*/

        
        /*integer file_output;
        integer counter = 0;
        
        initial
        begin
            file_output = $fopen("D:/MyResult.txt");
        end*/
        
        initial
        begin
            clk_in = 1;
            start  = 0;
            forever begin
                #100 clk_in = ~clk_in;
            end
        end
        
        initial begin
            reset     = 0;
            #50 reset  = 1;
            #100 reset = 0;
            start = 1;
        end
        
        /*always @(negedge clk_in) begin
            if (start)begin
                counter  = counter + 1;

                $fdisplay(file_output, "pc: %h", pc);
                $fdisplay(file_output, "instr: %h", inst);
                
                $fdisplay(file_output, "regfile0: %h", sc.sccpu.cpu_ref.array_reg[0]);
                $fdisplay(file_output, "regfile1: %h", sc.sccpu.cpu_ref.array_reg[1]);
                $fdisplay(file_output, "regfile2: %h", sc.sccpu.cpu_ref.array_reg[2]);
                $fdisplay(file_output, "regfile3: %h", sc.sccpu.cpu_ref.array_reg[3]);
                $fdisplay(file_output, "regfile4: %h", sc.sccpu.cpu_ref.array_reg[4]);
                $fdisplay(file_output, "regfile5: %h", sc.sccpu.cpu_ref.array_reg[5]);
                $fdisplay(file_output, "regfile6: %h", sc.sccpu.cpu_ref.array_reg[6]);
                $fdisplay(file_output, "regfile7: %h", sc.sccpu.cpu_ref.array_reg[7]);
                $fdisplay(file_output, "regfile8: %h", sc.sccpu.cpu_ref.array_reg[8]);
                $fdisplay(file_output, "regfile9: %h", sc.sccpu.cpu_ref.array_reg[9]);
                $fdisplay(file_output, "regfile10: %h", sc.sccpu.cpu_ref.array_reg[10]);
                $fdisplay(file_output, "regfile11: %h", sc.sccpu.cpu_ref.array_reg[11]);
                $fdisplay(file_output, "regfile12: %h", sc.sccpu.cpu_ref.array_reg[12]);
                $fdisplay(file_output, "regfile13: %h", sc.sccpu.cpu_ref.array_reg[13]);
                $fdisplay(file_output, "regfile14: %h", sc.sccpu.cpu_ref.array_reg[14]);
                $fdisplay(file_output, "regfile15: %h", sc.sccpu.cpu_ref.array_reg[15]);
                $fdisplay(file_output, "regfile16: %h", sc.sccpu.cpu_ref.array_reg[16]);
                $fdisplay(file_output, "regfile17: %h", sc.sccpu.cpu_ref.array_reg[17]);
                $fdisplay(file_output, "regfile18: %h", sc.sccpu.cpu_ref.array_reg[18]);
                $fdisplay(file_output, "regfile19: %h", sc.sccpu.cpu_ref.array_reg[19]);
                $fdisplay(file_output, "regfile20: %h", sc.sccpu.cpu_ref.array_reg[20]);
                $fdisplay(file_output, "regfile21: %h", sc.sccpu.cpu_ref.array_reg[21]);
                $fdisplay(file_output, "regfile22: %h", sc.sccpu.cpu_ref.array_reg[22]);
                $fdisplay(file_output, "regfile23: %h", sc.sccpu.cpu_ref.array_reg[23]);
                $fdisplay(file_output, "regfile24: %h", sc.sccpu.cpu_ref.array_reg[24]);
                $fdisplay(file_output, "regfile25: %h", sc.sccpu.cpu_ref.array_reg[25]);
                $fdisplay(file_output, "regfile26: %h", sc.sccpu.cpu_ref.array_reg[26]);
                $fdisplay(file_output, "regfile27: %h", sc.sccpu.cpu_ref.array_reg[27]);
                $fdisplay(file_output, "regfile28: %h", sc.sccpu.cpu_ref.array_reg[28]);
                $fdisplay(file_output, "regfile29: %h", sc.sccpu.cpu_ref.array_reg[29]);
                $fdisplay(file_output, "regfile30: %h", sc.sccpu.cpu_ref.array_reg[30]);
                $fdisplay(file_output, "regfile31: %h", sc.sccpu.cpu_ref.array_reg[31]);
                
            end
          end*/
endmodule
