module FIFO(
  input wire reset_n,
  input wire en,
  input wire w_clk,
  input wire r_clk,
  input wire read,
  input wire write,
  input wire [7:0] data_in,
  output reg [7:0] data_out,
  output reg empty,
  output reg full
  );

  reg [3:0] write_pointer;
  reg [3:0] read_pointer;
  wire [3:0] next_write_pointer;
  wire [3:0] next_read_pointer; 
  wire [4:0] write_state;
  wire [4:0] read_state;
  reg [15:0] valid;
  reg w_increment;
  reg r_increment;
  reg [7:0] memory [0:15];
  reg [7:0] data;

  parameter S0 = 4'b0000;
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
  parameter S15 = 4'b1000;

  /*parameter S0 = 4'b000;
  parameter S1 = 4'b001;
  parameter S2 = 4'b011;
  parameter S3 = 4'b010;
  parameter S4 = 4'b110;
  parameter S5 = 4'b111;
  parameter S6 = 4'b101;
  parameter S7 = 4'b100;*/

  
  gray_counter wrtie_counter(
    .reset_n(reset_n),
    .clk(w_clk),
    .increment(w_increment),
    .gray_count(next_write_pointer),
    .count_b(write_state)
  );

  gray_counter read_counter(
    .reset_n(reset_n),
    .clk(r_clk),
    .increment(r_increment),
    .gray_count(next_read_pointer),
    .count_b(read_state)
  );


  always@(posedge w_clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          w_increment <= 1'b0;
        end
      else
        begin
          if(!w_increment)
            begin
              if(write && !valid[write_pointer])
                begin
                  w_increment <= 1'b1;
                end
              else
                begin
                  w_increment <=  1'b0;
                end
            end
          else
            begin
              w_increment <= 1'b0;
            end
        end
    end

  always@(posedge r_clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          r_increment <= 1'b0;
        end
      else
        begin
          if(!r_increment)
            begin
              if(read && valid[read_pointer])
                begin
                  r_increment <= 1'b1;
                end
              else
                begin
                  r_increment <=  1'b0;
                end
            end
          else
            begin
              r_increment <= 1'b0;
            end
        end
    end

  always@(posedge w_clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          full <= 1'b0;
          empty <= 1'b0;
        end
      else
        begin
          full <= (write_state[3:0] == read_state[3:0]) & (write_state[4] != read_state[4]); 
          empty <= (write_state == read_state);
        end
    end

    always@(next_write_pointer or negedge reset_n)
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
             memory[S8] <= 8'b0;
             memory[S9] <= 8'b0;
             memory[S10] <= 8'b0;
             memory[S11] <= 8'b0;
             memory[S12] <= 8'b0;
             memory[S13] <= 8'b0;
             memory[S14] <= 8'b0;
             memory[S15] <= 8'b0;
             write_pointer <= 8'b0;
          end
        else
          begin
            memory[write_pointer] <= data_in;
            write_pointer <= next_write_pointer;
          end
      end

      always@(next_read_pointer or negedge reset_n)
        begin
          if(!reset_n)
            begin
              data_out <= 8'b0;
              read_pointer <= 8'b0;
            end
          else
            begin
              data_out <= memory[read_pointer];
              read_pointer <= next_read_pointer;
            end
        end

    always@(posedge r_increment or posedge w_increment or negedge reset_n)
      begin
        if(!reset_n)
          begin
            valid[S1] <= 1'b0;
            valid[S0] <= 1'b0;
            valid[S2] <= 1'b0;
            valid[S3] <= 1'b0;
            valid[S4] <= 1'b0;
            valid[S5] <= 1'b0;
            valid[S6] <= 1'b0;
            valid[S7] <= 1'b0;
            valid[S8] <= 1'b0;
            valid[S9] <= 1'b0;
            valid[S10] <= 1'b0;
            valid[S11] <= 1'b0;
            valid[S12] <= 1'b0;
            valid[S13] <= 1'b0;
            valid[S14] <= 1'b0;
            valid[S15] <= 1'b0;
          end
        else
          begin
            if(r_increment == w_increment)
              begin
                    valid[read_pointer] <= 1'b0;
                    valid[write_pointer] <= 1'b1;
              end
            else if(r_increment)
              begin
                valid[read_pointer] <= 1'b0;
              end
            else if(w_increment)
              begin
                valid[write_pointer] <= 1'b1;
              end
          end
      end

endmodule
