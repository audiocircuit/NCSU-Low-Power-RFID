module I2C(
input wire [6:0]Address,
input wire [7:0] Register, 
input wire Clk,  
input wire Mode,
input wire Start,
input wire Stop,
input wire Reset,
output reg Ack,
output reg [7:0] Out, 
inout wire Sda,
inout wire Scl
);

reg [2:0]state;
reg [4:0]counter;
reg sda;

assign Scl = (Start) ? Clk: 1'bz;
assign Sda = sda;

always@(posedge Clk)
  begin	
    if(~Reset)
      begin
        state <= 0;
        counter <= 5'bx;
      end
    else
      begin
        case(state)
          0:
            begin
              if(Start == 1)
                begin
                  sda <= 1'b0;
                  state <= 1;
                  Ack <= 1'bx;
                  Out <= 8'bx;
                  counter <= 0;
                end
              else
                begin
                  sda <= 1'bz;
                  state <= 0;
                  Ack <= 1'bx;
                  Out <= 8'bx; 
                  counter <= 5'bx;
                end
            end
          1:
            begin
              if(counter < 7)
                begin
                  sda <= Address[6-counter];
                  state <= 1;
                  Ack <= 1'bx;
                  Out <= 8'bx;
                  counter <= counter + 1;
                end
              else
                begin
                  sda <= Mode;
                  state <= 2;
                  Ack <= 1'bx;
                  Out <= 8'bx; 
                  counter <= 5'bx;
                end
            end
          2:
            begin
              if(Start)
                begin
                  sda <= 1'bz;
                  state <= 0;
                  Ack <= sda;
                  Out <= 8'bx;
                  counter <= 0;
                end
            end




        endcase
      end
  end
endmodule



module testbench();
  reg [6:0]Address;
  reg [7:0] Register; 
  reg Clk;
  reg Mode;
  reg Start;
  reg Stop;
  reg Reset;
  wire Ack;
  wire [7:0] Out; 
  wire Sda;
  wire Scl;

I2C u1 (Address, Register, Clk, Mode, Start, Stop, Reset, Ack, Out, Sda, Scl);

  always
    begin
      #5 Clk = ~Clk;
    end

  initial
    begin
      Address = 7'b1110000;
      Register = 8'b00001111;
      Clk = 1;
      Mode = 0;
      Start = 0;
      Stop = 0;
      Reset = 0;
      #10
      Reset = 1;
      #20
      Start = 1;
      #10
      Start = 0;




      #300 
      $finish;
    end

endmodule

