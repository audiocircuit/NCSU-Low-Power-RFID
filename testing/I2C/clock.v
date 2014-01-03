module clock_divider2(
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


module clock_divider4(
  input wire clk,
  input wire reset,
  input wire enabled,
  output reg clk_out
  );
  
  reg [3:0]counter; 

  always@(posedge clk)
    if( ~reset )
      begin
        clk_out <= 0;
        counter <= 0;
      end
    else if( enabled )
      begin
        if( counter < 4 )
          begin
            counter <= counter + 1;
            clk_out <= clk_out;
          end
        else
          begin
            clk_out <= !clk_out;
            counter <= 0;
          end
      end

endmodule

module clock_divider4_offset(
  input wire clk,
  input wire reset,
  input wire enabled,
  output reg clk_out
  );
  
  reg [3:0]counter; 

  always@(posedge clk)
    if( ~reset )
      begin
        clk_out <= 1;
        counter <= 1;
      end
    else if( enabled )
      begin
        if( counter < 4 )
          begin
            counter <= counter + 1;
            clk_out <= clk_out;
          end
        else
          begin
            clk_out <= !clk_out;
            counter <= 0;
          end
      end

endmodule

/*
module clock_test();



  reg clk;
  reg reset;
  reg enabled;
  wire clk_out1;
  wire clk_out2;
  wire clk_out3;


  clock_divider4 u2 (clk, reset, enabled, clk_out2);
  clock_divider4_offset u3 (clk, reset, enabled, clk_out3);

  always
    begin
      #5 clk <= !clk;
    end

  initial
    begin
      clk = 0;
      reset = 0;
      enabled = 0;
      #20
      reset = 1;
      enabled = 1;
      #600;
      $finish;
    end



endmodule

*/
