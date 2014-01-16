module clock_test();

  reg clk;
  reg reset;
  reg enabled;
  wire clk_out;
  wire clk_offset;

  clock_divider u1 (clk, reset, enabled, clk_out, clk_offset);

  always
    begin
      #5 clk <= !clk;
    end

  initial
    begin
      clk = 0;
      reset = 0;
      enabled = 0;
      #20000
      reset = 1;
      enabled = 1;
      #6000000;
      $finish;
    end

endmodule