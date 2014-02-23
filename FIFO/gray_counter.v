module gray_counter(
  input wire reset_n,
  input wire clk,
  input wire increment,
  output wire [3:0] gray_count,
  output wire [4:0] count_b
  );

  reg [4:0] count;
  
  assign count_b = count;
  assign gray_count = {count[3],count[3] ^ count[2], count[2] ^ count[1], count[1] ^ count[0]};

  always@(posedge clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          count <= 5'b0;
        end
      else
        begin
          if(increment)
            begin
              if((count + 1) == 32)
                begin
                  count = 5'b0;
                end
              else
                begin
                  count <= count + 1'b1;
                end
            end
          else
            begin
              count <= count;
            end
        end

    end

endmodule
