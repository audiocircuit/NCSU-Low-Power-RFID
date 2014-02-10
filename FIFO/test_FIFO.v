`timescale 10ns/10ns

module test_FIFO();
  reg reset_n = 1;
  reg en = 1;
  reg clk = 1;
  reg read = 0;
  reg write = 0;
  reg write_ready = 0;
  wire write_valid;
  reg read_ready;
  wire read_valid = 0;
  reg [7:0] data_in = 2;
  reg [8:0] clock_divider = 1;
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
    clk,
    sys_clk,
    read,
    write,
    write_valid,
    write_ready,
    read_valid,
    read_ready,
    data_in,
    data_out,
    empty,
    full
  );

  always
    begin
      #5 
      clk <= ~clk;
    end

  initial
    begin
      #10
      reset_n = 0;
      #10
      reset_n = 1;
      #10
      repeat(20)
        begin
          #10
          write = 0;
          data_in = data_in + 1;
          #10
          write = 1;
        end
      #1000

      $finish;
    end
  

endmodule
