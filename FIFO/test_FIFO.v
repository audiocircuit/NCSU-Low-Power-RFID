module test_FIFO();
  reg reset_n;
  reg en;
  reg r_clk;
  reg w_clk;
  reg read;
  reg write;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire empty;
  wire full;


  FIFO fifo (
    reset_n,
    en,
    r_clk,
    w_clk,
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
      r_clk <= ~r_clk;
      w_clk <= ~w_clk;
    end

  initial
    begin
      reset_n =1;
      en = 1;
      r_clk = 1;
      w_clk = 1;
      read = 0;
      write = 0;
      data_in = 1;
      #20
      reset_n = 0;
      #20
      reset_n = 1;
      #15
      read = 1;
      write = 1;
      repeat(20)
        begin
          #10
          data_in = data_in + 2;
        end
      write = 0;
      #20
      read = 0;
      data_in = data_in -1;
      #50
      write = 1;
      repeat(20)
        begin
          #10
          data_in = data_in -1;
        end
      #10
      write = 0;
      #20
      read = 1;
      #300


      $finish;
    end
  

endmodule
