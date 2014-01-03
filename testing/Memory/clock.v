
`timescale 1ns/1ps

module clock_divider(
  input wire clk,
  input wire reset,
  input wire enabled,
  output reg refresh_clk,
  output reg sys_clk
  );
  
  reg [8:0] counter1; 
  reg [8:0] counter2;
  reg [8:0] clk_divid;

  always@(posedge clk)
    begin
      if( ~reset )
        begin
          refresh_clk <= 1;
          sys_clk <= 0;
          counter1 <= 0;
          counter2 <= 63;
          clk_divid <= 127;
        end
      else if( enabled )
        begin
          clk_divid <= clk_divid;
          if( counter1 < clk_divid )
            begin
              counter1 <= counter1 + 1;
              refresh_clk <= refresh_clk;
            end
          else
            begin
              refresh_clk <= !refresh_clk;
              counter1 <= 0;
            end
          if( counter2 < clk_divid )
            begin
              counter2 <= counter2 + 1;
              sys_clk <= sys_clk;
            end
          else
            begin
              sys_clk <= !sys_clk;
              counter2 <= 0;
            end
        end
    end
endmodule

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
