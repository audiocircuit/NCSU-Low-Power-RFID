module slave(
  input wire reset_n,
  input wire en,
  input wire [6:0] my_addr,
  input wire [7:0] measurement,
  input wire scl,
  inout wire sda
  );

  reg stop;
  reg start; 
  reg mode;  
  reg [7:0] data_in; 
  reg [6:0] address;
  reg [2:0] slave_state; 
  reg [4:0] slave_counter; 
  reg sda_out;
  reg sda_en;
  reg sda_in;

  parameter WAIT = 0;
  parameter ADDRESS = 1;
  parameter MODE = 2;
  parameter ADDRESS_ACK = 3;
  parameter WRITE_DATA = 4;
  parameter READ_DATA = 5;
  parameter WRITE_ACK = 6;
  parameter READ_ACK = 7;


  assign sda = (sda_en) ? ( sda_out ) ? 1'bz : 1'b0 : 1'bz;
  
  always@(negedge sda or negedge reset_n)
    begin
      if(!reset_n)
        begin
          start <= 0;
        end
      else
        begin
          if( scl )
            begin
              start <= 1;
            end
          else
            begin
              start <= 0;
            end
        end
    end

  always@(posedge sda or negedge reset_n)
    begin
      if(!reset_n)
        begin
          stop <= 0;
        end
      else
        begin
          if( scl )
            begin
              stop <= 1;
            end
          else
            begin
              stop <= 0;
            end
        end
    end


  always@(posedge scl or negedge reset_n)
    begin
      sda_in <= sda;  
    end

  always@( sda_in or slave_state or slave_counter or negedge reset_n)
    begin
      if( !reset_n )
        begin
          sda_en <= 0;
          sda_out <= 0;
          address <= 7'b0;
          data_in <= 8'b0;
          mode <= 0;
        end
      else
        begin
          case(slave_state)
            WAIT:
              begin
                sda_en <= 0;
                sda_out <= 0;
                address <= {address, sda_in};
                data_in <= 8'b0;
                mode <= 0;
              end
            ADDRESS:
              begin
                sda_en <= 0;
                sda_out <= 0;
                address <= {address, sda_in};
                data_in <= 8'b0;
                mode <= 0;
              end
            MODE:
              begin
                sda_en <= 0;
                sda_out <= 0;
                address <= address;
                data_in <= 8'b0;
                mode <= sda;
              end
            ADDRESS_ACK:
              begin
                sda_en <= 1;
                sda_out <= 0;
                address <= address;
                data_in <= 8'b0;
                mode <= mode;             
              end
            WRITE_DATA:
              begin
                sda_en <= 1;
                sda_out <= measurement[7 - slave_counter];
                address <= 7'b0;
                data_in <= 8'b0;
                mode <= mode;           
              end
            WRITE_ACK:
              begin
                sda_en <= 0;
                sda_out <= 0;
                address <= address;
                data_in <= 8'b0;
                mode <= mode;               
              end
            READ_DATA:
              begin
                sda_en <= 0;
                sda_out <= 0;
                address <= address;
                data_in <= {data_in, sda_in};
                mode <= mode;               
              end
            READ_ACK:
              begin
                sda_en <= 1;
                sda_out <= 0;
                address <= address;
                data_in <= data_in;
                mode <= mode;  
              end
          endcase
        end
    end
  

  always@(negedge scl or negedge reset_n)
    begin
      if( !reset_n )
        begin
          slave_state = WAIT;
          slave_counter = 0;
        end
      else
        begin
          case(slave_state)
            WAIT:
              begin
                if( start && en )
                  begin
                    slave_state <= ADDRESS;
                    slave_counter <= 4'b0;
                  end
                else
                  begin
                    slave_state <= WAIT;
                    slave_counter <= 4'b0;
                  end
              end
            ADDRESS:
              begin
                if(slave_counter < 6)
                  begin
                    slave_state <= ADDRESS;
                    slave_counter <= slave_counter + 1'b1;
                  end
                else
                  begin
                    slave_state <= MODE;
                    slave_counter <= 0;
                  end
              end
            MODE:
              begin
                slave_state <= ADDRESS_ACK;
                slave_counter <= 0;
              end
            ADDRESS_ACK:
              begin
                if((address == my_addr) || ( stop ))
                  begin
                    if( mode )
                      begin
                        slave_state <= WRITE_DATA;
                        slave_counter <= 0;
                      end
                    else
                      slave_state <= READ_DATA;
                      slave_counter <= 0;
                  end
                else
                  begin
                    slave_state <= WAIT;
                    slave_counter <= 0;
                  end
              end
            WRITE_DATA:
              begin
                if(slave_counter < 7)
                  begin
                    slave_state <= WRITE_DATA;
                    slave_counter <= slave_counter + 1'b1;
                  end
                else 
                  begin
                    slave_state <= WRITE_ACK;
                    slave_counter <= 0;
                  end
              end
            WRITE_ACK:
              begin
                if( sda_in || stop )
                  begin
                    slave_state <= WAIT;
                    slave_counter = 0;
                  end
                else
                  begin
                    slave_state <= WRITE_DATA;
                    slave_counter <= 0;
                  end
              end
            READ_DATA:
              begin
                if(slave_counter < 7)
                  begin
                    slave_state <= READ_DATA;
                    slave_counter <= slave_counter + 1;
                  end
                else
                  begin
                    slave_state <= READ_ACK;
                    slave_counter <= 0;
                  end
              end
            READ_ACK:
              begin
                if( stop )
                  begin
                    slave_state <= WAIT;
                    slave_counter <= 0;
                  end
                else
                  begin
                    slave_state <= READ_DATA;
                    slave_counter <= 0;
                  end
              end
          endcase
        end
    end
endmodule
