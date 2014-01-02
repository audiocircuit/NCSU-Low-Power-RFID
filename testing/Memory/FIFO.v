module FIFO_four(
  input wire clk,
  input wire reset,
  input wire write,
  input wire read,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  output wire full,
  output wire empty
  );

  reg [4:0] write_pointer;
  reg [4:0] read_pointer;
  reg [7:0] memory [0:15];
  wire upper;
  wire [3:0] lower;

  assign empty = (read_pointer == write_pointer) ? 1'b1 : 1'b0;
  assign full = ((read_pointer[3:0] == write_pointer[3:0]) &&(read_pointer[4] != write_pointer[4]));

  always@(posedge clk)
    begin
      if( !reset )
        begin
          read_pointer <= 0;
          data_out <= 8'bz;
        end
      else
        begin
          case( read_pointer[3:0] )
            0:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            1:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            2:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            3:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            4:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            5:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            6:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            7:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            8:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            9:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            10:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            11:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <=  memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            12:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            13:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            14:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
            15:
              begin
                if( !empty && read )
                  begin
                    if( ( read_pointer + 1 ) < 32 )
                      begin
                        read_pointer <= read_pointer + 1;
                        data_out <= memory[read_pointer[3:0]];
                      end
                    else
                      begin
                        read_pointer <= 0;
                        data_out <= memory[read_pointer[3:0]];
                     end
                  end
                else
                  begin
                    read_pointer <= read_pointer;
                    data_out <= 8'bz;
                  end
              end
          endcase
        end
    end

  always@(posedge clk)
    begin
      if( !reset )
        begin
          write_pointer <= 0;
        end
      else
        begin
          case( write_pointer[3:0] )
            0:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                     end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            1:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            2:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            3:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
           4:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            5:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            6:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            7:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            8:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            9:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            10:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            11:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            12:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            13:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            14:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                  end
              end
            15:
              begin
                if( !full && write )
                  begin
                    if( ( write_pointer + 1 ) < 32 )
                      begin
                        write_pointer <= write_pointer + 1;
                        memory[write_pointer[3:0]] <= data_in;                      
                      end
                    else
                      begin
                        write_pointer <= 0;
                        memory[write_pointer[3:0]] <= data_in;           
                      end
                  end
                else
                  begin
                    write_pointer <= write_pointer;
                   end
              end
          endcase
        end
    end
endmodule
  
/*
module FIFO_testbench();

  reg clk;
  reg reset;
  reg write;
  reg read;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire full;
  wire empty;




  FIFO_four u1 (clk, reset, write, read, data_in, data_out, full, empty);
  
  always
    begin
     #5 clk <= ~clk; 
    end

  initial
    begin
      clk = 1;
      #20
      reset = 0;
      write = 0;
      read = 0;
      data_in = 0;
      #20
      reset = 1;
      #20
      repeat(18)
        begin
          #10
          write = 1;
          data_in = data_in + 2;
          #10
          write = 0;
        end
      $finish;
    end
endmodule
*/
