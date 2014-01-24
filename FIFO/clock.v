module clock_divider(
  input wire clk,
  input wire reset_n,
  input wire [8:0] clk_divider,
  output reg sys_clk
  );
  
  reg [8:0] counter;

  always@(posedge clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          counter <= 0;
          sys_clk <= 1;
        end
      else
        begin
          if(counter < (clk_divider-1))
            begin
              counter <= counter + 1;
              sys_clk <= sys_clk;
            end
          else
            begin
              counter <= 0;
              sys_clk <= ~sys_clk;
            end
        end
    end
endmodule
