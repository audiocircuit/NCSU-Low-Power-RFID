module test();
  reg reset_n = 1;
  reg clk = 1;

  count u1 (
   .reset_n(reset_n),
   .clk(clk)
   );
  
  always #5 clk <= ~clk;

  initial
    begin
      #10
      reset_n = 0;
      repeat(100)
        begin
          #10
          reset_n = 1;
        end
      $finish;
    end

endmodule





