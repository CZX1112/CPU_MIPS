`timescale 1ns / 1ps
module cpu_tb(

    );
        reg clk_in;
        reg reset;
        reg start;
        wire[31:0] inst;
        wire[31:0] pc;
        
        
        sccomp_dataflow sc(clk_in, reset, inst, pc);
        
        wire [31:0] M1_out = sc.sccpu.M1_out;
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
        wire DM_R = sc.DM_R;
        
        
        integer file_output;
        integer counter = 0;
        
        initial
        begin
            file_output = $fopen("D:/computer_composition/MIPS31/result.txt");
        end
        
        initial
        begin
            clk_in = 1;
            start  = 0;
            forever begin
                #50 clk_in = ~clk_in;
            end
        end
        
        initial begin
            reset     = 0;
            #6 reset  = 1;
            #50 reset = 0;
            start = 1;
        end
        
        always @(posedge clk_in) begin
            if (start)begin
                counter  = counter + 1;

                
                $fdisplay(file_output, "regfiles0 = %h", sc.sccpu.cpu_ref.array_reg[0]);
                $fdisplay(file_output, "regfiles1 = %h", sc.sccpu.cpu_ref.array_reg[1]);
                $fdisplay(file_output, "regfiles2 = %h", sc.sccpu.cpu_ref.array_reg[2]);
                $fdisplay(file_output, "regfiles3 = %h", sc.sccpu.cpu_ref.array_reg[3]);
                $fdisplay(file_output, "regfiles4 = %h", sc.sccpu.cpu_ref.array_reg[4]);
                $fdisplay(file_output, "regfiles5 = %h", sc.sccpu.cpu_ref.array_reg[5]);
                $fdisplay(file_output, "regfiles6 = %h", sc.sccpu.cpu_ref.array_reg[6]);
                $fdisplay(file_output, "regfiles7 = %h", sc.sccpu.cpu_ref.array_reg[7]);
                $fdisplay(file_output, "regfiles8 = %h", sc.sccpu.cpu_ref.array_reg[8]);
                $fdisplay(file_output, "regfiles9 = %h", sc.sccpu.cpu_ref.array_reg[9]);
                $fdisplay(file_output, "regfiles10 = %h", sc.sccpu.cpu_ref.array_reg[10]);
                $fdisplay(file_output, "regfiles11 = %h", sc.sccpu.cpu_ref.array_reg[11]);
                $fdisplay(file_output, "regfiles12 = %h", sc.sccpu.cpu_ref.array_reg[12]);
                $fdisplay(file_output, "regfiles13 = %h", sc.sccpu.cpu_ref.array_reg[13]);
                $fdisplay(file_output, "regfiles14 = %h", sc.sccpu.cpu_ref.array_reg[14]);
                $fdisplay(file_output, "regfiles15 = %h", sc.sccpu.cpu_ref.array_reg[15]);
                $fdisplay(file_output, "regfiles16 = %h", sc.sccpu.cpu_ref.array_reg[16]);
                $fdisplay(file_output, "regfiles17 = %h", sc.sccpu.cpu_ref.array_reg[17]);
                $fdisplay(file_output, "regfiles18 = %h", sc.sccpu.cpu_ref.array_reg[18]);
                $fdisplay(file_output, "regfiles19 = %h", sc.sccpu.cpu_ref.array_reg[19]);
                $fdisplay(file_output, "regfiles20 = %h", sc.sccpu.cpu_ref.array_reg[20]);
                $fdisplay(file_output, "regfiles21 = %h", sc.sccpu.cpu_ref.array_reg[21]);
                $fdisplay(file_output, "regfiles22 = %h", sc.sccpu.cpu_ref.array_reg[22]);
                $fdisplay(file_output, "regfiles23 = %h", sc.sccpu.cpu_ref.array_reg[23]);
                $fdisplay(file_output, "regfiles24 = %h", sc.sccpu.cpu_ref.array_reg[24]);
                $fdisplay(file_output, "regfiles25 = %h", sc.sccpu.cpu_ref.array_reg[25]);
                $fdisplay(file_output, "regfiles26 = %h", sc.sccpu.cpu_ref.array_reg[26]);
                $fdisplay(file_output, "regfiles27 = %h", sc.sccpu.cpu_ref.array_reg[27]);
                $fdisplay(file_output, "regfiles28 = %h", sc.sccpu.cpu_ref.array_reg[28]);
                $fdisplay(file_output, "regfiles29 = %h", sc.sccpu.cpu_ref.array_reg[29]);
                $fdisplay(file_output, "regfiles30 = %h", sc.sccpu.cpu_ref.array_reg[30]);
                $fdisplay(file_output, "regfiles31 = %h", sc.sccpu.cpu_ref.array_reg[31]);
                
                $fdisplay(file_output, "instr = %h", inst);
                $fdisplay(file_output, "pc = %h", pc);
            end
          end
endmodule
