module test(
input wire clk,
input sda,
output reg out
);

always@(  posedge sda  )
  begin
    if( clk ==  1)
      begin
        out <= 1'b1;
      end
    else
      begin
        out <= 1'b0;
      end
  end

endmodule


module testbench();

reg clk, sda;
wire out;

test u1 (clk, sda, out);

always
  begin
    #5 clk = ~clk;
  end

initial
  begin
    clk = 0;
    sda = 1;
    #40
    sda = 0;
    #22
    sda = 1;
    #4
    sda = 0;
    #2
    sda = 1;
    #400
    
    
    $finish;
  end

endmodule
