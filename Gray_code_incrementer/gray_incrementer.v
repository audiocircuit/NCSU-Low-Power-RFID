module gray_incrementer(
  input wire [3:0] input_count,
  output wire [3:0] gray_count
  );

  wire [3:0] count;
  wire [3:0] next_count;
  assign count[3] = input_count[3];
  assign count[2] = count[3] ^ input_count[2];
  assign count[1] = count[2] ^ input_count[1];
  assign count[0] = count[1] ^ input_count[0];
  assign next_count = count + 1'b1;
  assign gray_count = {next_count[3],next_count[3] ^ next_count[2], next_count[2] ^ next_count[1], next_count[1] ^ next_count[0]};

endmodule



module count(
  input wire reset_n,
  input wire clk
  );

  reg [3:0] count;
  wire [3:0] next_count;

  gray_incrementer u5(
    .input_count(count),
    .gray_count(next_count)
    );

  always@(posedge clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          count <= 4'b0;
        end
      else
        begin
          count <= next_count;
        end
    end

endmodule
