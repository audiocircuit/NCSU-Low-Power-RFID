`timescale 10ns/10ns

module read_write_FIFO();
  reg reset_n = 1;
  reg en = 1;
  reg clk = 1;
  reg read = 0;
  reg write = 0;
  reg [7:0] data_in = 2;
  reg [8:0] clock_divider = 2;
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
      write = 1;
      read = 1;
      repeat(40)
        begin
          #20
          data_in = data_in + 1;
        end
      #10
      write = 0;
      #1400
      read = 0;
      #100

      $finish;
    end
  

endmodule
