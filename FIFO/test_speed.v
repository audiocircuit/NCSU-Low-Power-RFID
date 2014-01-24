`timescale 10ns/10ns

module test();

reg clk = 1;
reg reset_n = 1;
reg [8:0] divider = 10;

clock_divider u1 (clk,reset_n,divider,sys_clk); 

always #25 clk <= ~clk;

initial
  begin
    #10
    reset_n = 0;
    #10
    reset_n = 1;
    #100000
    $finish;
  end

endmodule



