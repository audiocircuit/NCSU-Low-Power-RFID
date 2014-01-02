module clock_divider(
  input wire clk,
  input wire reset,
  input wire enabled,
  output reg clk_out
  );

  always@(posedge clk)
    if( ~reset )
      begin
        clk_out <= 0;
      end
    else if( enabled )
      begin
        clk_out <= !clk_out;
      end

endmodule

module testbench();

reg clk;
reg reset;
reg enabled;
wire clk_out;

clock_divider u1  (clk,reset,enabled,clk_out);

always
  #5 clk = ~clk;

initial
  begin
    reset = 0;
    clk = 1;
    #10
    reset = 1;
    enabled = 1;
    #100
    $finish;
  end



endmodule
