module I2C_write_to_memory(
  input wire clk,
  input wire reset,
  input wire run,
  input wire [11:0] number_of_bytes,
  input wire [14:0] memory_address,
  input wire [7:0] data_in,
  input wire empty,
  input wire ack,
  input wire [2:0] memory_number,
  output reg read,
  output reg [6:0] address,
  output reg [7:0] register,
  output reg mode,
  output reg I2C_en,
  output reg reset_I2C,
  output reg Start,
  output reg Stop,
  output reg repeat_start,
  input wire sda
  );

  reg [3:0] state;
  reg [11:0] counter;


  always@(posedge clk or negedge reset)
    begin
      if( !reset )
        begin
          state <= 0;
          read <= 0;
          address <= 7'b0;
          register <= 8'b0;
          mode <= 0;
          I2C_en <= 0;
          reset_I2C <= 0;
          Start <= 0;
          Stop <= 0;
          repeat_start <= 0;
          counter <= 0;
        end
      else
        begin 
          case( state )
            0:                              // initial state  
              begin
                if( run )                   // if run is not enabled
                  begin
                    state <= 1;
                    read <= 0;
                    address <= 7'b0;
                    register <= 8'b0;
                    mode <= 0;
                    I2C_en <= 1;            // Enable the I2C module
                    reset_I2C <= 0;         // reset the I2C module
                    Start <= 0;
                    Stop <= 0;
                    repeat_start <= 0;
                    counter <= 0;
                end
                else                      
                  begin
                    state <= 0;
                    read <= 0;
                    address <= 7'b0;
                    register <= 8'b0;
                    mode <= 0;
                    I2C_en <= 0;
                    reset_I2C <= 1;
                    Start <= 0;
                    Stop <= 0;
                    repeat_start <= 0;
                    counter <= 0;
                 end
              end
            1: 
              begin
                state <= 2;
                read <= 0;
                address <= {4'b1010, memory_number};  // set memory address;
                register <= 8'b0;
                mode <= 0;
                I2C_en <= 1;
                reset_I2C <= 1;               // Done with I2c reset
                Start <= 1;                   // Start the I2C module 
                Stop <= 0;
                repeat_start <= 0;
                counter <= 0;
              end
             2:
              begin
                if(counter < 8)
                  begin
                    state <= 2;
                    read <= 0;
                    address <= {4'b1010, memory_number};  // set memory address;
                    register <= 8'b0;
                    mode <= 0;
                    I2C_en <= 1;
                    reset_I2C <= 1;               // Done with I2c reset
                    Start <= 0;                   // Start the I2C module 
                    Stop <= 0;
                    repeat_start <= 0;
                    counter <= counter + 1;
                 end
                else
                  begin
                    state <= 3;
                    read <= 0;
                    address <= 0;
                    register <= 8'b0;
                    mode <= 0;
                    I2C_en <= 1;
                    reset_I2C <= 1;               // Done with I2c reset
                    Start <= 0;                   // Start the I2C module 
                    Stop <= 0;
                    repeat_start <= 0;
                    counter <= 0;
                  end
              end
            3:
              begin
                state <= 3;
                read <= 0;
                address <= 8'b0;  // set memory address;
                register <= 8'b0;
                mode <= 0;
                I2C_en <= 1;
                reset_I2C <= 1;               // Done with I2c reset
                Start <= 1;                   // Start the I2C module 
                Stop <= 0;
                repeat_start <= 0;
                counter <= 0;
              end
         endcase
        end
    end

endmodule



