module FIFO(
  input wire reset_n,
  input wire en,
  input wire clk,
  input wire read,
  input wire write,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  output wire empty,
  output wire full
  );

  reg [2:0] write_pointer;
  reg [2:0] read_pointer;
  reg [7:0] memory [0:7];
  reg [7:0] data;
  reg [3:0] counter;

  parameter S0 = 4'b000;
  parameter S1 = 4'b001;
  parameter S2 = 4'b011;
  parameter S3 = 4'b010;
  parameter S4 = 4'b110;
  parameter S5 = 4'b111;
  parameter S6 = 4'b101;
  parameter S7 = 4'b100;

  assign full = (counter >= 7) ? 1'b1 : 1'b0;
  assign empty = (counter == 0) ? 1'b1 : 1'b0;


  always@(posedge clk or negedge reset_n)
    begin
      if(!reset_n && en)
        begin
          write_pointer <= S0;
          read_pointer <= S0;
          counter <= 0;
        end
      else
        begin
          if(write && !full)
            begin
              counter <= counter + 1;
              case(write_pointer)
                S0: begin write_pointer <= S1; end
                S1: begin write_pointer <= S2; end
                S2: begin write_pointer <= S3; end
                S3: begin write_pointer <= S4; end
                S4: begin write_pointer <= S5; end
                S5: begin write_pointer <= S6; end
                S6: begin write_pointer <= S7; end
                S7: begin write_pointer <= S0; end
              endcase
            end
          else
            begin
              write_pointer <= write_pointer;
            end
          if(read && !empty)
            begin
              counter <= counter - 1;
              case(read_pointer)
                S0: begin read_pointer <= S1; end
                S1: begin read_pointer <= S2; end
                S2: begin read_pointer <= S3; end
                S3: begin read_pointer <= S4; end
                S4: begin read_pointer <= S5; end
                S5: begin read_pointer <= S6; end
                S6: begin read_pointer <= S7; end
                S7: begin read_pointer <= S0; end
              endcase
            end
          else
            begin
              read_pointer <= read_pointer;
            end
       end
    end
  
  always@(write_pointer or negedge reset_n)
    begin
      if(!reset_n)
        begin
        
          memory[0] <= 8'b0;
          memory[1] <= 8'b0;
          memory[2] <= 8'b0;
          memory[3] <= 8'b0;
          memory[4] <= 8'b0;
          memory[5] <= 8'b0;
          memory[6] <= 8'b0;
          memory[7] <= 8'b0;
        end
      else
        begin
          case(write_pointer)
            S0:
              begin        
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= memory[3];
                memory[4] <= data_in;
                memory[5] <= memory[5];
                memory[6] <= memory[6];
                memory[7] <= memory[7];
              end
            S1:
              begin        
                memory[0] <= data_in;
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= memory[3];
                memory[4] <= memory[4];
                memory[5] <= memory[5];
                memory[6] <= memory[6];
                memory[7] <= memory[7];
              end
            S2:
              begin        
                memory[0] <= memory[0];
                memory[1] <= data_in;
                memory[2] <= memory[2];
                memory[3] <= memory[3];
                memory[4] <= memory[4];
                memory[5] <= memory[5];
                memory[6] <= memory[6];
                memory[7] <= memory[7];
              end
            S3:
              begin        
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= data_in;
                memory[4] <= memory[4];
                memory[5] <= memory[5];
                memory[6] <= memory[6];
                memory[7] <= memory[7];
              end
            S4:
              begin        
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= data_in;
                memory[3] <= memory[3];
                memory[4] <= memory[4];
                memory[5] <= memory[5];
                memory[6] <= memory[6];
                memory[7] <= memory[7];
              end
            S5:
              begin        
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= memory[3];
                memory[4] <= memory[4];
                memory[5] <= memory[5];
                memory[6] <= data_in;
                memory[7] <= memory[7];
              end
            S6:
              begin        
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= memory[3];
                memory[4] <= memory[4];
                memory[5] <= memory[5];
                memory[6] <= memory[6];
                memory[7] <= data_in;
              end
            S7:
              begin        
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= memory[3];
                memory[4] <= memory[4];
                memory[5] <= data_in;
                memory[6] <= memory[6];
                memory[7] <= memory[7];
              end
         endcase
        end
    end
  



endmodule
