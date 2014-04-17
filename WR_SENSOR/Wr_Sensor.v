module Wr_Sensor(
    input wire reset_n,
    input wire clock,
    input wire start,
    input wire mode,
    input wire [6:0] sensor_addr,
    input wire [7:0] write_val,
    output reg data_ready,
    output reg [7:0] read_val,
    output reg master_en,
    output reg master_start,
    output reg master_stop,
    output reg master_mode,
    output reg [7:0] write_slave_data,
    input wire [7:0] read_slave_data,
    output reg [6:0] slave_addr
    );

  parameter IDLE = 4'd0;
  parameter ADDR = 4'd1;
  parameter WRITE_CONTROL = 4'd2;
  parameter WRITE_CONTROL_ACK = 4'd3;
  parameter WRITE = 4'd4;
  parameter WRITE_ACK = 4'd5;
  parameter READ_ADDR = 4'd6;
  parameter READ_VALUE = 4'd7;
  parameter READ = 4'd8;
  parameter READ_ACK = 4'd9;
  parameter READ_STOP = 4'd12;
  parameter WRITE_STOP = 4'd13;
  parameter READ_ACK_STOP = 4'd10;
  parameter WRITE_ACK_STOP = 4'd11;
  parameter WAIT = 4'd14;

  reg [3:0] state;
  reg [4:0] count;


  always@(*)
    begin
      case(state)
        IDLE:
          begin
            read_val <= 8'd0;
            master_en <= 1'd0;
            master_start <= 1'd0;
            master_stop <= 1'd1;
            master_mode <= 1'd0;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        ADDR: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd0;
            write_slave_data <= 8'd0;
            slave_addr <= sensor_addr;
            data_ready <= 1'd0;
          end
        WRITE_CONTROL: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd0;
            write_slave_data <= write_val;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        WRITE_CONTROL_ACK: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd0;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd1;
          end
        WRITE: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd0;
            write_slave_data <= write_val;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        WRITE_STOP: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd0;
            master_stop <= 1'd1;
            master_mode <= 1'd0;
            write_slave_data <= write_val;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        WRITE_ACK: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd0;
            write_slave_data <= write_val;
            slave_addr <= 7'd0;
            data_ready <= 1'd1;
          end
        WRITE_ACK_STOP: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd0;
            master_stop <= 1'd1;
            master_mode <= 1'd0;
            write_slave_data <= write_val;
            slave_addr <= 7'd0;
            data_ready <= 1'd1;
          end
        READ_ADDR: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd1;
            write_slave_data <= 8'd0;
            slave_addr <= sensor_addr;
            data_ready <= 1'd0;
          end
        READ: 
          begin
            read_val <= read_slave_data;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd1;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        READ_ACK: 
          begin
            read_val <= read_val;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd0;
            master_mode <= 1'd1;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd1;
          end
        READ_ACK_STOP: 
          begin
            read_val <= read_val;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd1;
            master_mode <= 1'd1;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd1;
          end
        READ_STOP: 
          begin
            read_val <= read_slave_data;
            master_en <= 1'd1;
            master_start <= 1'd1;
            master_stop <= 1'd1;
            master_mode <= 1'd1;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        WAIT: 
          begin
            read_val <= read_val;
            master_en <= 1'd1;
            master_start <= 1'd0;
            master_stop <= 1'd1;
            master_mode <= 1'd1;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        default: 
          begin
            read_val <= 8'd0;
            master_en <= 1'd0;
            master_start <= 1'd0;
            master_stop <= 1'd0;
            master_mode <= 1'd0;
            write_slave_data <= 8'd0;
            slave_addr <= 7'd0;
            data_ready <= 1'd0;
          end
        endcase
    end

  always@(posedge clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          count <= 5'd0;
          state <= 4'd0;
        end
      else
        begin
          case(state)
            IDLE: 
              begin
                if(start)
                  begin
                    if(count[0] == 1'd1)
                      begin
                        count <= 5'd0;
                        state <= ADDR;
                      end
                    else
                      begin
                        count <= count + 1'd1;
                        state <= IDLE;
                      end
                  end
                else
                  begin
                    count <= count + 1'd0;
                    state <= IDLE;
                  end
              end
            ADDR:   
              begin
                if(count == 5'd19)
                  begin
                    count <= 5'd0;
                    state <= WRITE_CONTROL;
                  end
                else
                  begin
                    count <= count + 1'd1;
                    state <= ADDR;
                  end
              end
            WRITE_CONTROL:
              begin
                if(count == 5'd16)
                  begin
                    count <= 5'd0;
                    state <= WRITE_CONTROL_ACK;
                  end
                else
                  begin
                    count <= count + 1'd1;
                    state <= WRITE_CONTROL;
                  end
              end
            WRITE_CONTROL_ACK:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= WRITE_CONTROL_ACK;
                  end
                else
                  begin
                    count <= 5'd0;
                    if(mode)
                      begin
                        state <= READ_ADDR;
                      end
                    else
                      begin
                        state <= WRITE;
                      end
                  end
              end
            WRITE:
              begin
                if(count == 5'd15)
                  begin
                    count <= 5'd0;
                    state <= WRITE_ACK;
                  end
                else if(count == 5'd13 & ! start)
                  begin
                    count <= 5'd0;
                    state <= WRITE_STOP;
                  end
                else
                  begin
                    count <= count + 1'd1;
                    state <= WRITE;
                  end
              end
            WRITE_STOP:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= WRITE_STOP;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= WRITE_ACK_STOP;
                  end
              end
            WRITE_ACK:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= WRITE_ACK;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= WRITE;
                  end
              end
            WRITE_ACK_STOP:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= WRITE_ACK_STOP;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= WAIT;
                  end
              end
            READ_ADDR:
              begin
                if(count == 5'd25)
                  begin
                    count <= 5'd0;
                    state <= READ;
                  end
                else
                  begin
                    count <= count + 1'd1;
                    state <= READ_ADDR;
                  end
              end
            READ:
              begin
                if(count == 5'd15)
                  begin
                    count <= 5'd0;
                    state <= READ_ACK;
                  end
                else if((count == 5'd13) & ! start )
                  begin
                    count <= 5'd0;
                    state <= READ_STOP;
                  end
                else
                  begin
                    count <= count + 1'd1;
                    state <= READ;
                  end
              end
            READ_ACK:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= READ_ACK;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= READ;
                  end
              end
            READ_ACK_STOP:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= READ_ACK_STOP;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= WAIT;
                  end
              end
            READ_STOP:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= READ_STOP;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= READ_ACK_STOP;
                  end
              end
            WAIT:
              begin
                if(!count[0])
                  begin
                    count <= count + 1'd1;
                    state <= WAIT;
                  end
                else
                  begin
                    count <= 5'd0;
                    state <= IDLE;
                  end
              end
          endcase
        end
    end





endmodule
