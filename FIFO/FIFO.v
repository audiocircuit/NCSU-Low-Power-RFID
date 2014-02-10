module FIFO(
  input wire reset_n,
  input wire en,
  input wire w_clk,
  input wire r_clk,
  input wire read,
  input wire write,
  input wire write_valid,
  output reg write_ready,
  output reg read_valid,
  input wire read_ready,
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
  reg sub, add;

  /*parameter S0 = 4'b0000;
  parameter S1 = 4'b0001;
  parameter S2 = 4'b0011;
  parameter S3 = 4'b0010;
  parameter S4 = 4'b0110;
  parameter S5 = 4'b0111;
  parameter S6 = 4'b0101;
  parameter S7 = 4'b0100;
  parameter S8 = 4'b1100;
  parameter S9 = 4'b1101;
  parameter S10 = 4'b1111;
  parameter S11 = 4'b1110;
  parameter S12 = 4'b1010;
  parameter S13 = 4'b1011;
  parameter S14 = 4'b1001;
  parameter S15 = 4'b1000;*/

  parameter S0 = 4'b000;
  parameter S1 = 4'b001;
  parameter S2 = 4'b011;
  parameter S3 = 4'b010;
  parameter S4 = 4'b110;
  parameter S5 = 4'b111;
  parameter S6 = 4'b101;
  parameter S7 = 4'b100;


  assign full = (counter == 8) ? 1'b1 : 1'b0;
  assign empty = (counter == 0) ? 1'b1 : 1'b0;


  always@(write_pointer or read_pointer or reset_n or add or sub)
    begin
      if(!reset_n)
        begin
          counter = 0;
        end
      else
        begin
          if(sub && add)
            begin
              counter <= counter;
            end
          else if(sub)
            begin
              counter <= counter - 1;
            end
          else if(add)
            begin
              counter <= counter + 1;
            end
          else
            begin
              counter <= counter;
            end
        end
    end

  always@(posedge w_clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          write_pointer <= S0;
          memory[S0] <= 8'bz;
          memory[S1] <= 8'bz;
          memory[S2] <= 8'bz;
          memory[S3] <= 8'bz;
          memory[S4] <= 8'bz;
          memory[S5] <= 8'bz;
          memory[S6] <= 8'bz;
          memory[S7] <= 8'bz;
        end
      else
        begin
          case(write_pointer)
            S0:
              begin
                if(write&&!full)
                  begin
                    write_pointer <= S1;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S0;
                    add <= 0;
                  end
              end
            S1:
              begin
                if(write&&!full)
                  begin
                    write_pointer <= S2;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S1;
                    add <= 0;
                  end
              end
            S2:
              begin
                if(write&&!full)
                  begin
                    write_pointer <= S3;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S2;
                    add <= 0;
                  end
              end
            S3:
              begin
                if(write&&!full)
                  begin
                    write_pointer <= S4;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S3;
                    add <= 0;
                  end
              end
            S4:
              begin
                if(write&!full)
                  begin
                    write_pointer <= S5;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S4;
                    add <= 0;
                  end
              end
            S5:
              begin
                if(write&!full)
                  begin
                    write_pointer <= S6;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S5;
                    add <= 0;
                  end
              end
            S6:
              begin
                if(write&&!full)
                  begin
                    write_pointer <= S7;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S6;
                    add <= 0;
                  end
              end
            S7:
              begin
                if(write&&!full)
                  begin
                    write_pointer <= S0;
                    add <= 1;
                  end
                else
                  begin
                    write_pointer <= S7;
                    add <= 0;
                  end
              end
          endcase
        end
    end

  always@(write_pointer or negedge reset_n)
    begin
      if(!reset_n)
        begin
          memory[S0] <= 8'b0;
          memory[S1] <= 8'b0;
          memory[S2] <= 8'b0;
          memory[S3] <= 8'b0;
          memory[S4] <= 8'b0;
          memory[S5] <= 8'b0;
          memory[S6] <= 8'b0;
          memory[S7] <= 8'b0;
        end
      else
        begin
          case(write_pointer)
            S0:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= memory[S1];
                memory[S2] <= memory[S2];
                memory[S3] <= memory[S3];
                memory[S4] <= memory[S4];
                memory[S5] <= memory[S5];
                memory[S6] <= memory[S6];
                memory[S7] <= data_in;
              end
            S1:
              begin
                memory[S0] <= data_in;
                memory[S1] <= memory[S1];
                memory[S2] <= memory[S2];
                memory[S3] <= memory[S3];
                memory[S4] <= memory[S4];
                memory[S5] <= memory[S5];
                memory[S6] <= memory[S6];
                memory[S7] <= memory[S7];
              end
            S2:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= data_in;
                memory[S2] <= memory[S2];
                memory[S3] <= memory[S3];
                memory[S4] <= memory[S4];
                memory[S5] <= memory[S5];
                memory[S6] <= memory[S6];
                memory[S7] <= memory[S7];
              end
            S3:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= memory[S1];
                memory[S2] <= data_in;
                memory[S3] <= memory[S3];
                memory[S4] <= memory[S4];
                memory[S5] <= memory[S5];
                memory[S6] <= memory[S6];
                memory[S7] <= memory[S7];
              end
            S4:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= memory[S1];
                memory[S2] <= memory[S2];
                memory[S3] <= data_in;
                memory[S4] <= memory[S4];
                memory[S5] <= memory[S5];
                memory[S6] <= memory[S6];
                memory[S7] <= memory[S7];
              end
            S5:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= memory[S1];
                memory[S2] <= memory[S2];
                memory[S3] <= memory[S3];
                memory[S4] <= data_in;
                memory[S5] <= memory[S5];
                memory[S6] <= memory[S6];
                memory[S7] <= memory[S7];
              end
            S6:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= memory[S1];
                memory[S2] <= memory[S2];
                memory[S3] <= memory[S3];
                memory[S4] <= memory[S4];
                memory[S5] <= data_in;
                memory[S6] <= memory[S6];
                memory[S7] <= memory[S7];
              end
            S7:
              begin
                memory[S0] <= memory[S0];
                memory[S1] <= memory[S1];
                memory[S2] <= memory[S2];
                memory[S3] <= memory[S3];
                memory[S4] <= memory[S4];
                memory[S5] <= memory[S5];
                memory[S6] <= data_in;
                memory[S7] <= memory[S7];
              end
          endcase
        end
    end


endmodule
