`timescale 1ns/1ps

module I2C_testbench();
  reg [6:0] address;
  reg [7:0] register; 
  reg clk;
  wire sys_clk;
  wire refresh_clk;
  reg mode;
  reg en;
  reg reset;
  reg Start;
  reg Stop;
  reg repeat_start;
  wire [7:0] out; 
  tri1 sda;
  tri1 scl;
  wire ack;
  
  wire sda_master, sda_slave;
  reg sda_master_reg, sda_slave_reg;
  reg[7:0] measurement;

  master u1 (address, register, refresh_clk, sys_clk, mode, en, reset, Start, Stop, repeat_start, out, ack, sda, scl);
  slave u2 (address, measurement, en, reset, scl, sda);
  clock_divider u3 (clk, reset, en, refresh_clk, sys_clk); 

  always
    begin
      #5 clk = ~clk;
    end

  initial
    begin
      address = 7'b1110001;
      register = 8'b11111111;
      measurement = 8'b11110000;
      clk = 1;
      mode = 1;
      en = 0;
      Stop = 0;
      Start = 0;
      reset = 1;
      repeat_start = 0;
      #1000
      reset = 0;
      #2000
      reset = 1;
      en = 1;
      #5000
      Start = 1;
      #100000 
      Stop = 1;
      #30000
      $finish;
    end
endmodule
