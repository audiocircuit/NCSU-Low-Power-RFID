module FIFO(
  input wire reset_n,
  input wire en,
  input wire r_clk,
  input wire w_clk,
  input wire read,
  input wire write,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  output reg empty,
  output reg full
  );

  reg [3:0] write_pointer;
  reg [3:0] read_pointer;
  reg [7:0] memory [0:7];
  reg [7:0] data;
 
  


  always@(negedge r_clk or negedge reset_n)
    begin
      if( !reset_n || !en  )
        begin
          read_pointer <= 0;
        end
      else
        begin
          if( read && !empty )
            begin
              if((read_pointer + 1) < 16)
                begin
                  read_pointer <= read_pointer + 1'b1;
                end
              else
                begin
                  read_pointer <= 0;
                end
            end 
          else
            begin
              read_pointer <= read_pointer;
            end
        end
    end

  always@(posedge w_clk or negedge reset_n)
    begin
      if( !reset_n || !en  )
        begin
          write_pointer <= 0;
          data <= 0;
        end
      else
        begin
          if( write && !full )
            begin
              if((write_pointer + 1'b1) < 16)
                begin
                  write_pointer <= write_pointer + 1'b1;
                  data <= data_in;
                end
              else
                begin
                  write_pointer <= 0;
                  data <= data;
                end
            end
          else
            begin
              write_pointer <= write_pointer;
              data <= data;
            end
        end
    end

  always@( write_pointer or negedge reset_n or read_pointer)
    begin
      if( !reset_n )
        begin
          memory[0] <= 8'b0;
          memory[1] <= 8'b0;
          memory[2] <= 8'b0;
          memory[3] <= 8'b0;
          memory[4] <= 8'b0;
          memory[5] <= 8'b0;
          memory[6] <= 8'b0;
          memory[7] <= 8'b0;
          full <= 0;
        end
      else if( !full && write )
        begin
          case(write_pointer[2:0])
            0:
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
            1:
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
            2:
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
            3:
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
            4:
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
            5:
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
            6:
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
            7:
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
          endcase
          full <= ((read_pointer[2:0] == write_pointer[2:0]) &&(read_pointer[3] != write_pointer[3])) ? 1 : 0;
        end
      else
        begin
          memory[0] <= memory[0];
          memory[1] <= memory[1];
          memory[2] <= memory[2];
          memory[3] <= memory[3];
          memory[4] <= memory[4];
          memory[5] <= memory[5];
          memory[6] <= memory[6];
          memory[7] <= memory[7];
          full <= ((read_pointer[2:0] == write_pointer[2:0]) &&(read_pointer[3] != write_pointer[3])) ? 1 : 0;
        end
    end

  always@( read_pointer or negedge reset_n or write_pointer )
    begin
      if( !reset_n )
        begin
          data_out <= 8'bz;
          empty <= 1'b1;
        end
      else if( read )
        begin
          empty <= (read_pointer == write_pointer) ? 1'b1 : 1'b0;
          if( read_pointer == 0 )
            begin
              data_out <= memory[7];
            end
          else
            begin
              data_out <= memory[read_pointer - 1'b1];
            end
        end
      else
        begin
          data_out <= 8'bz;
          empty = (read_pointer == write_pointer) ? 1'b1 : 1'b0;
        end
    end
endmodule
