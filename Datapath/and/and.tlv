\m4_TLV_version 1d: tl-x.org
\SV
// Here the add binary signal is hardcoded to perform and instruction. It is of the format "AND x4,x4,x5".
//24-04-2021
//Himanshu Kumar - 191CS122
//Praneeth G - 191CS235
//Amal Majunu Vidya - 191CS107
//Aniket Srivastava - 191CS208


   // This code can be found in: https://github.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/risc-v_shell.tlv
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/warp-v_includes/1d1023ccf8e7b0a8cf8e8fc4f0a823ebb61008e3/risc-v_defs.tlv'])
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/risc-v_shell_lib.tlv'])
	//m4_include_lib(['https://gist.githubusercontent.com/shivampotdar/4513b1659da026a9da2e8a00613b065c/raw/90ff045ffb6e2194ab351935525165aacb8cda90/tlv_memories.tlv'])


   //---------------------------------------------------------------------------------
   
   m4_asm(ADDI, x14, x0, 0)             // Initialize sum register a4 with 0
   m4_asm(ADDI, x12, x0, 1010)          // Store count of 10 in register a2.
   m4_asm(ADD, x13, x12, x14)             // Initialize loop count register a3 with 0
   // Loop:
   //m4_asm(SD, x14, x13)           // Incremental summation
  // m4_asm(ADDI, x13, x13, 1)            // Increment loop count by 1
  // m4_asm(BLT, x13, x12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   // Test result value in x14, and set x31 to reflect pass/fail.
  // m4_asm(ADDI, x30, x14, 111111010100) // Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
  // m4_asm(BEQ, x0, x0, 0) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_asm_end()
   m4_define(['M4_MAX_CYC'], 50)
   //---------------------------------------------------------------------------------



\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   /* verilator lint_on WIDTH */
\TLV
   
   $reset = *reset;  
   $pc[31:0] = >>1$next_pc;
   
   
   `READONLY_MEM($pc, $$instr[31:0]);
   $po[5:0] = $instr[5:0];
   $ld = 0;
   $sd = 0;
   $beq = 0;
   $addi = 0;
   $add = 0;
   $sub = 0;
   $and = 1;
   $or = 0;
   /*
   $ld = $po == 6'b111010;
   $sd = $po == 6'b111110;
   $beq = $po == 6'b010011;
   $addi = $po == 6'b001110;
   $add = $po == 6'b011111 ? $instr[30:22] == 9'b100001010 : 1'b0;
   $sub = $po == 6'b011111 ? $instr[30:22] == 9'b000101000 : 1'b0;
   $and = $po == 6'b011111 ? $instr[30:21] == 10'b0000111100 : 1'b0;
   $or = $po == 6'b011111 ? $instr[30:21] == 10'b0110111100 : 1'b0;
   */
   $rd1_en = 1;
   $rd2_en = $add || $sub || $and || $or || $beq; 
   $wr_en = $add || $sub || $and || $or || $ld || $addi; 
   $rs1[4:0] = $beq ? $instr[10:6] : $instr[15:11];
   $rs2[4:0] = $beq ? $instr[15:11] : $sd ? $instr[10:6] : $instr[20:16];
   $rd[4:0] = $beq || $sd ? $instr[20:16] : $instr[10:6];   
   $imm[31:0] = $addi ? {16'b0,$instr[31:16]} : $ld || $sd ?  {18'b0,$instr[29:16]} : 32'b0; 
   m4+rf(32, 32, $reset, $wr_en, $rd[4:0], $wr_data[31:0], $rd1_en, $rs1[4:0], $rd1_data, $rd2_en, $rs2[4:0], $rd2_data)
   
   $out[31:0] = $addi ? $rd1_data + $imm : $sub ? $rd2_data - $rd1_data : $add ? $rd1_data + $rd2_data : $and ? $rd1_data && $rd2_data : $or ? $rd1_data || $rd2_data : 32'b0;  
   $taken_br = $rd2_data == $rd1_data;
   $bt_pc[31:0] = $pc + $imm;
   $next_pc[31:0] = $reset ? '0 : $taken_br ? $bt_pc : $pc+32'd4;
   
   $addr[4:0] = $ld || $sd ? $rd1_data + $imm : 5'b0;
   //$rd_en = $ld;
   //$wr_en = $sd;   
   m4+dmem(32, 32, $reset, $addr[4:0], $sd, $rd2_data[31:0], $ld, $rd_data)
   //$wr_data[31:0] = $rs2[31:0];
   $wr_data[31:0] = $ld ? $rd_data : $out[31:0];
   
   
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = 1'b0;
   *failed = *cyc_cnt > M4_MAX_CYC;
   
   
   m4+cpu_viz()
\SV
                   
   endmodule