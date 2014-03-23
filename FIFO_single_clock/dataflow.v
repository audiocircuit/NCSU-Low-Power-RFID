
module FIFO_Datapath(
  input wire reset_n,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  input wire [1:0] read_pointer,
  input wire [1:0] write_pointer,
  input wire data_ready,
  input wire data_valid
  );
  integer i;
  reg [7:0] memory [0:3];
  
  always@(posedge data_ready or negedge reset_n)
    begin
      if(!reset_n)
        begin
          for(i = 5'b0; i < 5'd4; i = i + 1'b1)
            begin
              memory[i] <= 5'b0;
            end
        end
      else
        begin
          for(i = 5'b0; i < 5'd4; i = i + 1'b1)
            begin
              if(i == write_pointer)
                begin
                  memory[i] <= data_in;
                end
              else
                begin
                  memory[i] <= memory[i];
                end
            end
        end
    end

    always@(*)
      begin
        data_out <= memory[read_pointer];
      end


endmodule
