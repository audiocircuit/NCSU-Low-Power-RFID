module test();
  reg reset_n;
  reg clk;
  reg en;
  reg start;
  reg stop;
  reg mode;
  reg [6:0] address;
  reg [7:0] regist;
  reg [7:0] mess;
  tri1 sda;
  tri1 scl;
  wire [7:0]data_out;

  master master_test (reset_n, clk, en, start, stop, mode,
                      address, regist, sda, scl, data_out);

  slave slave_test (reset_n, en, address, mess, scl, sda);   

  always
    #5 clk <= ~clk;

  initial
    begin
      clk = 1;
      en = 0;
      reset_n = 1;
      start = 0;
      stop = 0;
      mode = 0;
      address = 7'b1110000;
      regist = 8'b01010101;
      mess = 8'b10101010;
      #20
      reset_n = 0;
      #20
      reset_n = 1;
      #20
      en = 1;
      #20
      start = 1;
      #160
      mode = 0;
      #400
      start = 0;
      stop = 1;
      #200
      $finish;
    end

endmodule

