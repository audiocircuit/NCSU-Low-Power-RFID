/*module FIFO(
  input wire reset_n,
  input wire clock,
  input wire write_en,
  input wire read_en,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  input wire en,
  output wire empty,
  output wire full
  );
  
  FIFO_controller fifo_controller (


  );

  FIFO_Datapath fifo_datapath(


  );




endmodule
*/

module test_controller();
  reg clock = 1;
  reg reset_n = 1;
  reg write_en = 0;
  reg read_en = 0;
  wire [1:0] write_pointer;
  wire [1:0] read_pointer;
  wire full;
  wire empty;
  wire data_ready;


  FIFO_controller u1 (
    clock,
    reset_n,
    write_en,
    read_en,
    write_pointer,
    read_pointer,
    full,
    empty,
    data_ready
    );


  always #5 clock <= ~clock;

  initial
    begin
      #10
      reset_n = 0;
      #10
      reset_n = 1;
      #10
      write_en = 1;
      #200
      $finish;
    end


endmodule


module FIFO_controller(
  input wire clock,
  input wire reset_n,
  input wire write_en,
  input wire read_en,
  output wire [1:0] write_pointer,
  output wire [1:0] read_pointer,
  output wire full,
  output wire empty,
  output reg data_ready
  );

  reg [2:0] next_bin_write_pointer;
  reg [2:0] bin_write_pointer;
  reg [2:0] next_bin_read_pointer;
  reg [2:0] bin_read_pointer;

  assign full = (next_bin_write_pointer[2] != next_bin_read_pointer[2])&&(next_bin_write_pointer[1:0] == next_bin_read_pointer[1:0]) ? 1'b1 : 1'b0; 
  assign empty = (next_bin_write_pointer == next_bin_read_pointer);


  always@(posedge clock or negedge reset_n)
    begin
      bin_write_pointer <= next_bin_write_pointer;
    end

  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          next_bin_write_pointer <= 3'b0;
          data_ready <= 1'b0;
        end
      else
        begin
          if(write_en & !full & !data_ready)
            begin
              next_bin_write_pointer <= next_bin_write_pointer + 1'b1;
              data_ready <= 1'b1;
            end
          else
            begin
              next_bin_write_pointer <= next_bin_write_pointer;
              data_ready <= 1'b0;
            end
        end
    end


  assign write_pointer = {bin_write_pointer[1], bin_write_pointer[1] ^ bin_write_pointer[0]}; 

  always

  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          next_bin_read_pointer <= 3'b0;
          bin_read_pointer <= 2'b0;
        end
      else
        begin
          if(read_en && !empty)
            begin
              next_bin_read_pointer <= next_bin_read_pointer + 1'b1;
              bin_read_pointer <= next_bin_read_pointer;
            end
          else
            begin
              next_bin_read_pointer <= next_bin_read_pointer;
              bin_read_pointer <= bin_read_pointer;
            end
        end
    end


    assign read_pointer = {bin_read_pointer[1], bin_read_pointer[1] ^ bin_read_pointer[0]}; 

endmodule

/*
module FIFO_Datapath(


  );


endmodule*/
