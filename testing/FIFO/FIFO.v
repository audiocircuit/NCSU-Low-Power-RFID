module FIFO(
  input wire reset_n,
  input wire en,
  input wire r_clk,
  input wire w_clk,
  input wire read,
  input wire write,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  output wire empty,
  output wire full
  );

  reg [4:0] write_pointer;
  reg [4:0] read_pointer;
  reg [7:0] memory [0:4];
  
  assign empty = (read_pointer == write_pointer) ? 1'b1 : 1'b0;
  assign full = ((read_pointer[3:0] == write_pointer[3:0]) && (read_pointer[4] != write_pointer[4])) ? 1'b1: 1'b0;


  always@(posedge r_clk)
    begin
      if( !reset_n )
        begin
        read_pointer <= 0;
        end
      else
        begin
          if(en)
            begin
              if( !empty && read )
                begin
                  if((read_pointer + 1'b1) < 16)
                    begin
                      read_pointer <= read_pointer +1'b1;
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
          else
            begin
              read_pointer <= 0;
            end
        end
    end

  always@(read_pointer or negedge reset) 
    begin
      if( !reset_n )
        begin
          data_out <= 8'bz;
        end
      else
        begin
          data_out <= memory[read_pointer[3:0]];
        end
    end

  always@(posedge w_clk)
    begin
      if( !reset_n )
        begin
        write_pointer <= 0;
        end
      else
        begin
          if(en)
            begin
              if( !full && write )
                begin
                  if((write_pointer + 1'b1) < 16)
                    begin
                      write_pointer <= write_pointer +1'b1;
                    end
                  else
                    begin
                      write_pointer <= 0;
                    end
                end
              else
                begin
                  write_pointer <= write_pointer;
                end
            end
          else
            begin
              write_pointer <= 0;
            end
        end
    end

  always@(write_pointer or data_in or negedge reset_n)
    begin
      if( !reset_n )
        begin
          memory[0] <= 1'b0;
          memory[1] <= 1'b0;
          memory[2] <= 1'b0;
          memory[3] <= 1'b0;
        end
      else
        begin
          case(write_pointer[3:0])
            0:
              begin
                memory[0] <= data_in;
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= memory[3];
              end
            1:
              begin
                memory[0] <= memory[0];
                memory[1] <= data_in;
                memory[2] <= memory[2];
                memory[3] <= memory[3];
              end
            2:
              begin
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= data_in;
                memory[3] <= memory[3];
              end
            3:
              begin
                memory[0] <= memory[0];
                memory[1] <= memory[1];
                memory[2] <= memory[2];
                memory[3] <= data_in;
              end

          endcase
        end
    end
endmodule


module FIFO_test();
  reg reset_n;
  reg en;
  reg r_clk;
  reg w_clk;
  reg read;
  reg write;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire empty;
  wire full;

  FIFO fifo( 
    reset_n,
    en,
    r_clk,
    w_clk,
    read,
    write,
    data_in,
    data_out,
    empty,
    full);


  always
    begin
      #5 r_clk <= ~r_clk;
       w_clk <= ~w_clk;
    end

  initial
    begin
    reset_n = 1;
    en = 0;
    r_clk = 0;
    w_clk = 0;
    read = 0;
    write = 0;
    data_in = 8'b10101010;
    #20
    reset_n = 0;
    #20
    reset_n = 1;
    #20
    en = 1;
    #10
    repeat(8)
      begin
        #10
        write = 1;
        data_in = data_in + 1;
      end
    #10
    write = 0;
    #30
    repeat(8)
      begin
        #10
        read = 1;
      end
    #20
    $finish;
    end


endmodule  


