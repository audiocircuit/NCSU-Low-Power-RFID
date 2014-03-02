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
  wire data_valid;


  FIFO_controller u1 (
    clock,
    reset_n,
    write_en,
    read_en,
    write_pointer,
    read_pointer,
    full,
    empty,
    data_ready,
    data_valid
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
      while(!full)
      #40
      write_en = 0;
      #20
      read_en = 1;
      while(!empty)
      #100
      write_en = 1;
      #10
      read_en = 1;
      #200
      write_en = 0;
      #60
      read_en = 0;
      #40

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
  output reg data_ready,
  output reg data_valid
  );

  reg [2:0] next_bin_write_pointer;
  reg [2:0] bin_write_pointer;
  reg [2:0] next_bin_read_pointer;
  reg [2:0] bin_read_pointer;
  integer i;

  assign full = (next_bin_write_pointer[2] != next_bin_read_pointer[2])&&(next_bin_write_pointer[1:0] == next_bin_read_pointer[1:0]) ? 1'b1 : 1'b0; 
  assign empty = (next_bin_write_pointer == next_bin_read_pointer);


  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          bin_write_pointer <= 1'b0;
        end
      else
        begin
          bin_write_pointer <= next_bin_write_pointer;
        end
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

  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          bin_read_pointer <= 1'b0;
        end
      else
        begin
          bin_read_pointer <= next_bin_read_pointer;
        end
    end

  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          next_bin_read_pointer <= 3'b0;
          data_valid <= 1'b1;
        end
      else
        begin
          if(read_en & !empty & data_valid)
            begin
              next_bin_read_pointer <= next_bin_read_pointer + 1'b1;
              data_valid <= 1'b0;
            end
          else
            begin
              next_bin_read_pointer <= next_bin_read_pointer;
              data_valid <= 1'b1;
            end
        end
    end


    assign read_pointer = {bin_read_pointer[1], bin_read_pointer[1] ^ bin_read_pointer[0]}; 

endmodule


module FIFO_Datapath(
  input wire reset_n,
  input wire data_in,
  output reg data_out,
  input wire read_pointer,
  input wire write_pointer,
  input wire data_ready,
  input wire data_valid
  );
  integer i;
  reg [7:0] memory [0:3];
  
  always@(posedge data_ready or negedge reset_n)
    begin
      if(!reset_n)
        begin
          for(i = 5'b0; i < 5'd4; i = i + 1'b1)
            begin
              memory[i] <= 5'b0;
            end
        end
      else
        begin
          for(i = 5'b0; i < 5'd4; i = i + 1'b1)
            begin
              if(i == write_pointer)
                begin
                  memory[i] <= data_in;
                end
              else
                begin
                  memory[i] <= memory[i];
                end
            end
        end
    end

  always@(posedge data_valid or negedge reset_n)
    begin
      if(!reset_n)
        begin
          for(i = 5'b0; i < 5'd4; i = i + 1'b1)
            begin
              data_out <= 8'b0;
            end
        end
      else
        begin
          for(i = 5'b0; i < 5'd4; i = i + 1'b1)
            begin
              if(i == read_pointer)
                begin
                  data_out <= memory[i];
                end
              else
                begin
                  data_out <= data_out;
                end
            end
        end
    end

endmodule
