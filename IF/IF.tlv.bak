\m4_TLV_version 1d: tl-x.org
\SV

//Here it reads instruction from the memory where binary instructions are stored using the value of PC.
//25-04-2021
//Himanshu Kumar - 191CS122
//Praneeth G - 191CS235
//Amal Majunu Vidya - 191CS107
//Aniket Srivastava - 191CS208
  
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   $pc[31:0] = >>1$next_pc;
   $next_pc[31:0] = $reset ? '0 : $pc+32'd4;
   `READONLY_MEM($pc, $$out[31:0]);
   //...

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule