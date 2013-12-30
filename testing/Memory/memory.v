module I2C_write_to_memory(
  input wire clk,
  input wire reset,
  input wire run,
  input wire [7:0] data_in,
  input wire empty,
  input wire ack,
  input wire [2:0] memory_number,
  output reg read,
  output reg [6:0] address,
  output reg [7:0] register,
  output reg mode,
  output reg en,
  output reg reset_I2C,
  output reg Start,
  output reg Stop,
  output reg repeat_start,
  );

  reg [4:0] state;

  always@(posedge clk)
    begin
      if( !reset )
        begin
          state <= 0;
          read <= 0;
          address <= 7'b0;
          register <= 8'b0;
          mode <= 0;
          en <= 0;
          reset_I2C <= 0;
          Start <= 0;
          Stop <= 0;
          repeat_start <= 0;
        end
      else
        begin
          case( state )
            0:
              begin
                if( run )
                  begin
                    state <= 1;
                    read <= 1;
                    address <= 7'b0;
                    register <= 8'b0;
                    mode <= 0;
                    en <= 1;
                    reset_I2C <= 0;
                    Start <= 0;
                    Stop <= 0;
                    repeat_start <= 0;
                 end
                else
                  begin
                    state <= 0;
                    read <= 0;
                    address <= 7'b0;
                    register <= 8'b0;
                    mode <= 0;
                    en <= 0;
                    reset_I2C <= 0;
                    Start <= 0;
                    Stop <= 0;
                    repeat_start <= 0;
                  end
              end
            1:
              begin
                if( empty )
                  begin
                    state <= 1;
                    read <= 1;
                    address <= 7'b0;
                    register <= 8'b0;
                    mode <= 0;
                    en <= 1;
                    reset_I2C <= 0;
                    Start <= 0;
                    Stop <= 0;
                    repeat_start <= 0;
                 end
                else
                  begin
                    state <= 0;
                    read <= 0;
                    address <= {4'b1010};
                    register <= 8'b0;
                    mode <= 0;
                    en <= 0;
                    reset_I2C <= 0;
                    Start <= 0;
                    Stop <= 0;
                    repeat_start <= 0;
                  end
              end
          endcase
        end
    end

endmodule



