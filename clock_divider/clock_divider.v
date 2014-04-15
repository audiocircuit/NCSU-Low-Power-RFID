module clock_divider(
  input wire clock,
  input wire reset,
  input wire enabled,
  output reg clk_div
  );
  
  reg [8:0] counter; 

  always@(posedge clock or negedge reset)
    begin
      if( !reset )
        begin
          counter <= 9'b0;
          clk_div <= 1'b1;
        end
      else if( enabled )
        begin
          if(counter == 5'd0)
            begin
              clk_div <= ~clk_div;
              counter <= 9'b0;
            end
          else
            begin
              clk_div <= clk_div;
              counter <= counter + 1'b1;
            end
        end
    end
endmodule
