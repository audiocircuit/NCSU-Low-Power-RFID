module I2C_testbench();
  reg [6:0] address;
  reg [7:0] register; 
  reg clk;
  reg mode;
  reg en;
  reg reset;
  reg Start;
  reg Stop;
  reg repeat_start;
  wire ack;
  wire [7:0] aut; 
  tri0 sda;
  wire scl;
  
  wire sda_master, sda_slave;
  reg sda_master_reg, sda_slave_reg;

  I2C u1 (address, register, clk, mode, en, reset, Start, Stop, repeat_start, ack, out, sda, scl);

  always
    begin
      #5 clk = ~clk;
    end

  initial
    begin
      address = 7'b1110000;
      register = 8'b10110010;
      clk = 1;
      mode = 1;
      en = 0;
      Stop = 0;
      Start = 0;
      reset = 0;
      repeat_start = 1;
      #10
      reset = 1;
      #20
      en = 1;
      Start = 1;
      #300 
      Stop = 1;
      #200
      $finish;
    end

endmodule

