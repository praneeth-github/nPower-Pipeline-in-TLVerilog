\m4_TLV_version 1d: tl-x.org
\SV
//ALU-CU helps us to identify which type of operations we should do based on the PO-code and XO-code
// 23-04-2021
//Himanshu Kumar - 191CS122
//Praneeth G - 191CS235
//Amal Majunu Vidya - 191CS107
//Aniket Srivastava - 191CS208
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   
   $po[5:0] = $instr[5:0];
   $ld = $po == 6'b111010;
   $sd = $po == 6'b111110;
   $beq = $po == 6'b010011;
   $addi = $po == 6'b001110;
   $add = $po == 6'b011111 ? $instr[30:22] == 9'b100001010 : 1'b0;
   $sub = $po == 6'b011111 ? $instr[30:22] == 9'b000101000 : 1'b0;
   $and = $po == 6'b011111 ? $instr[30:21] == 10'b0000111100 : 1'b0;
   $or = $po == 6'b011111 ? $instr[30:21] == 10'b0110111100 : 1'b0;

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
