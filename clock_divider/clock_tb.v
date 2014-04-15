module clock_test();

  reg clk = 1;
  reg reset = 1;
  reg enabled = 1;
  wire clk_out;
  wire clk_offset;

  clock_divider u1 (clk, reset, enabled, clk_out);

  always
    begin
      #5 clk <= !clk;
    end

  initial
    begin
      #100
      clk = 0;
      reset = 0;
      enabled = 0;
      #110
      reset = 1;
      enabled = 1;
      #6000000;
      $finish;
    end

endmodule
