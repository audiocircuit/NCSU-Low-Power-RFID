`timescale 10ns/10ns

module test_FIFO();
  reg reset_n = 1;
  reg en = 1;
  reg clk = 1;
  reg read = 0;
  reg write = 0;
  reg [7:0] data_in = 2;
  reg [8:0] clock_divider = 10;
  wire [7:0] data_out;
  wire sys_clk;
  wire empty;
  wire full;
  

  clock_divider u2 (
    clk,
    reset_n,
    clock_divider,
    sys_clk
    );

  FIFO u1 (
    reset_n,
    en,
    sys_clk,
    read,
    write,
    data_in,
    data_out,
    empty,
    full
  );

  always
    begin
      #25 
      clk <= ~clk;
    end

  initial
    begin
      #1000
      reset_n = 0;
      #10
      reset_n = 1;
      #1000
      write = 1;
      repeat(20)
        begin
          #1000
          data_in = data_in + 1;
        end
      #100000

      $finish;
    end
  

endmodule
