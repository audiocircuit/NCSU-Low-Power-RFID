module I2C(
input wire [6:0] address,
input wire [7:0] register, 
input wire clk,  
input wire mode,
input wire en,
input wire reset,
output reg ack,
output reg [7:0] out, 
inout wire Sda,
inout wire scl
);

reg sda;
reg [2:0] state;
reg [4:0] counter;

assign scl = (en == 1) ? clk: 1'bz;
assign Sda = sda;

always@(posedge clk)
  begin	
    if(~reset)
      begin
        state <= 0;
        counter <= 5'bx;
      end
    else
      begin
        case(state)
          0:
            begin
              if(en == 1)
                begin
                  sda <= 1'b0;
                  state <= 1;
                  ack <= 1'bx;
                  out <= 8'bx;
                  counter <= 0;
                end
              else
                begin
                  sda <= 1'bz;
                  state <= 0;
                  ack <= 1'bx;
                  out <= 8'bx; 
                  counter <= 5'bx;
                end
            end
          1:
            begin
              if(counter < 7)
                begin
                  sda <= address[6-counter];
                  state <= 1;
                  ack <= 1'bx;
                  out <= 8'bx;
                  counter <= counter + 1;
                end
              else
                begin
                  sda <= mode;
                  state <= 2;
                  ack <= 1'bx;
                  out <= 8'bx; 
                  counter <= 5'bx;
                end
            end
          2:
            begin
               sda <= 1'bz;
               state <= 3;
               ack <= 1'bx;
               out <= 8'bx;
               counter <= 0;
            end
          3:
            begin
              ack <= sda;
              if(sda == 1'bz)
                begin
                  sda <= 1'bz;
                  state <= 0;
                  out <= 8'bx;
                  counter <= 5'bx;
                end
             else if(sda == 1'b1)
                begin
                  if(mode == 1)
                    begin
                      out[7 - counter] <= sda;
                      sda <= 1'bz;
                      state <= 4;
                      out <= 8'bx;
                      counter <= counter + 1;
                    end
                  else
                     begin
                      sda <= register[7 - counter];
                      state <= 5;
                      out <= 8'bx;
                      counter <= counter + 1;
                    end                   
                end
               else if(sda == 1'b0)
                begin
                  sda <= 1'bz;
                  state <= 0;
                  out <= 8'bx;
                  counter <= 5'bx;
                end
            end
        4:
          begin
            if(counter > 7)
              begin
                sda <= 1'bz;
                state <= 6;
                out <= 8'bx;
                ack <= 1'bx;
                counter <= 1'bx;
                end 
            else
              begin
                out[7 - counter] <= sda;
                sda <= 1'bz;
                state <= 4;
                out <= 8'bx;
                ack <= 1'bx;
                counter <= counter + 1;
              end
          end
        5:
          begin
            if(counter > 7)
              begin
                sda <= 1'bz;
                state <= 6;
                out <= 8'bx;
                ack <= 1'bx;
                counter <= 1'bx;
                end 
            else
              begin
                sda <= register[7 - counter];
                sda <= 1'bz;
                state <= 5;
                out <= 8'bx;
                ack = 1'bx;
                counter <= counter + 1;
              end 
          end
        6:
          begin
            ack <= sda;
            if(sda == 1'bz)
              begin
                sda <= 1'bz;
                state <= 0;
                out <= 8'bx;
                counter <= 1'bx;
              end
             else if(sda == 1'b1)
              begin
                sda <= 1'bz;
                state <= 7;
                out <= 8'bx;
                counter <= 0;
              end
             else if(sda == 1'b0)
              begin
                sda <= 1'bz;
                state <= 7;
                out <= 8'bx;
                counter <= 0;
              end
          end
        7:
          begin
            state <= 0;
          end





        endcase
      end
  end
endmodule



module testbench();
  reg [6:0] address;
  reg [7:0] register; 
  reg clk;
  reg mode;
  reg en;
  reg reset;
  wire ack;
  wire [7:0] aut; 
  wire sda;
  wire scl;

I2C u1 (address, register, clk, mode, en, reset, ack, out, sda, scl);

  always
    begin
      #5 clk = ~clk;
    end

  initial
    begin
      address = 7'b1110000;
      register = 8'b00001111;
      clk = 1;
      mode = 0;
      en = 0;
      reset = 0;
      #10
      reset = 1;
      #20
      en = 1;

      #300 
      $finish;
    end

endmodule

