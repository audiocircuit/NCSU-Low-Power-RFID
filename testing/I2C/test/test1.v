module test1(
input wire clk,
input wire reset,
input wire enabled,
input wire in,
input wire Start,
input wire Stop,
output wire sda
);

  reg start, done, data;

  always@( negedge Start or reset )
    begin
      if(~reset)
        begin
          start <= 1'b0;
        end
      else
        begin
          if( enabled == 1 )
            begin
              start <= 1'b1;
            end
          else
            begin
              start <= 1'b0;
            end
        end
    end
  
  always@( posedge Stop or reset )
    begin
      if(~reset)
        begin
          done <= 1'b0;
        end
      else
        begin
          if( enabled == 1 )
            begin
              done <= 1'b1;
            end
          else
            begin
              done <= 1'b0;
            end
        end
    end
   
  always@( posedge clk )
    begin
      data <= in;
    end

  assign sda = ( enabled == 1 ) ? ( start == 1) ? (done== 0) ? data : 1'bz : 1'bz : 1'bz;

endmodule


module testbench1();

reg reset, clk, enable, in, Start, Stop;
wire sda;

test1 u1 ( clk, reset, enable, in, Start, Stop, sda );

always
  begin
    #5 clk = ~clk;
  end

initial
  begin
    reset = 0;
    clk = 1;
    enable = 0;
    in = 0;
    Start = 0;
    Stop = 0;
    #20
    reset = 1;
    #40
    Start = 1;
    #20;
    Start = 0;
    #20
    enable = 1;
    #20
    enable = 0;
    #20
    enable = 1;
    Start = 1;
    #20
    Start = 0;
    in = 0;
    #20
    in = 1;
    #10
    in = 0;
    #10 
    in = 1;
    #10
    in = 0;
    #10 
    in = 1;
    #10
    in = 0;
    #10 
    in = 1;
    #10
    in = 0;
    #10 
    in = 1;
    Stop = 1;
    #2
    Stop = 0;
    #50





    
    
    $finish;
  end

endmodule
