\m4_TLV_version 1d: tl-x.org
\SV

   //ALU 64-bit is made here using binary signals which performs the operations based on the output of ALUCU.
// 22/04/2021
//Himanshu Kumar - 191CS122
//Praneeth G - 191CS235
//Amal Majunu Vidya - 191CS107
//Aniket Srivastava - 191CS208
 
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   $out[63:0] = $addi ? $rd1_data + $imm : $sub ? $rd2_data - $rd1_data : $add ? $rd1_data + $rd2_data : $and ? $rd1_data && $rd2_data : $or ? $rd1_data || $rd2_data : 64'b0;  

   //...

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule