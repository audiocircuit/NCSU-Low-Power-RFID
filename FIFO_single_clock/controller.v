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
  reg [1:0] write_state;
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
          write_state <= 1'b0;
          data_ready <= 1'b0;
        end
      else
        begin
          if(write_en)
            begin
              if(write_state == 1'b0 & !full)
                begin
                  data_ready <= 0'b0;
                  write_state <= 1'b1;
                  next_bin_write_pointer <= next_bin_write_pointer;
                end
              else if(write_state == 1'b1)
                begin
                  data_ready <= 1'b1;
                  write_state <= 1'b0;
                  next_bin_write_pointer <= next_bin_write_pointer + 1'b1;
                end
              else
                begin
                  next_bin_write_pointer <= next_bin_write_pointer;
                  write_state <= 1'b0;
                  next_bin_write_pointer <= next_bin_write_pointer;
                end
            end
          else
            begin
              next_bin_write_pointer <= next_bin_write_pointer;
              write_state <= 1'b0;
              next_bin_write_pointer <= next_bin_write_pointer;
            end
        end
    end


  assign write_pointer = {bin_write_pointer[1], bin_write_pointer[1] ^ bin_write_pointer[0]}; 

  /*always@(posedge clock or negedge reset_n)
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
*/
  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          bin_read_pointer <= 3'b0;
          next_bin_read_pointer <= 3'b0;
          data_valid <= 1'b1;
        end
      else
        begin
          if(read_en & !empty & data_valid)
            begin
              bin_read_pointer <= next_bin_read_pointer;
              next_bin_read_pointer <= bin_read_pointer;
              data_valid <= 1'b0;
            end
          else if(read_en & !empty & !data_valid)
            begin
              next_bin_read_pointer <= bin_read_pointer + 1'b1;
              bin_read_pointer <= bin_read_pointer;
              data_valid <= 1'b1;
            end
          else
            begin
              next_bin_read_pointer <= next_bin_read_pointer;
              bin_read_pointer <= next_bin_read_pointer;
              data_valid <= 1'b1;
            end
        end
    end


    assign read_pointer = {bin_read_pointer[1], bin_read_pointer[1] ^ bin_read_pointer[0]}; 

endmodule


