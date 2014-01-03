module I2C_slave(
  input wire [6:0] my_addr,
  input wire [7:0] measurement,
  input wire en,
  input wire reset,
  input wire scl,
  inout sda
);

  reg [3:0] state, count;
  wire sda_in, scl_in;
  reg sda_enable, sda_out, start, stop, sda_output, last_sda, last;

  reg [6:0] addr;
  reg [7:0] data;

  assign sda =  ( last_sda ) ? last ? 1'bz : 1'b0 : 1'dz;
  assign sda_in = sda;

  always@(negedge scl)
    begin
      last <= sda_out;
      last_sda <= sda_enable;
    end

  always@(negedge sda)    //if sda transitions to low while SCL is high, then this is a start condition
    begin
      if(scl)
        begin
          start <= 1;
        end
      else
        begin
          start <= 0;
        end
    end

  always@(posedge sda)    //if sda transitions to high while SCL is high then we have a stop condition
    begin
      if(scl)
        begin
          stop <= 1;
        end
      else
        begin
          stop <= 0;
        end
    end

  always@(posedge scl or negedge reset) 
    begin
      if(~reset)
        begin
          state <= 0;
          sda_enable <= 0;
          sda_out <= 0;
          start <= 0;
          count <= 0;
          stop <= 0;
        end
      else
        begin
          case(state)
            0:                //***************State 0: Reset********************
              begin
                if(~start)    //wait for a start signal
                  begin
                    state <= 0;
                    sda_enable <= 0;
                    sda_out <= 0;
                    data <= data;
                    start <= 0;
                    stop <= 0;
                    count <= 0;
                  end
                else          //Start signal received
                  begin
                    state <= 1;
                    sda_enable <= 0;
                    sda_out <= 0;
                    addr[7-count] <= sda;
                    data <= data;
                    count <= count + 1;
                  end
              end
            1:                //***************State 1: Check Address********************
              begin
                if(count<8)     //only collect 7 bits that corrospond to the address
                  begin
                    state <= 1;
                    sda_enable <= 0;
                    sda_out <= 0;
                    addr[7-count] <= sda;
                    data <= data;
                    count <= count +1;
                  end
                else
                  begin
                    if(addr == my_addr)     //if the address is the slave address
                      begin
                        if(sda)    //if sda is low after transmitting the address, then we move to the read state
                          begin
                            state <= 2;
                            sda_enable <= 1;    //send ACK to master to confirm address received
                            sda_out <= 0;
                            data <= data;
                            addr <= addr;
                            count <= 0;
                          end
                        else      //if sda is high after transmitting the address, then wemove to the write state
                          begin 
                            state <= 3;
                            sda_enable <= 1;
                            sda_out <= 0;       //send ACK to master to confirm address received
                            data <= data;
                            addr <= addr;
                            count <= 0;
                          end
                      end
                    else      //if the address transmitted is not the slave address, return to state 0
                      begin
                        state <= 0;
                        sda_enable <= 0;
                        sda_out <= 0;
                        addr <= addr;
                        data <= data;
                        count <= 0;
                      end
                  end
              end
            2:                //***************State 2: Read Data********************
              begin
                if(count < 8)       //send 8 bits of measurement to the master
                  begin
                    state <= 2;
                    sda_enable <= 1;
                    sda_out <= measurement[7-count];
                    addr <= addr;
                    data <= data;
                    count <= count + 1;
                  end
                else                //all data is sent to master
                  begin
                    if(!sda)          //if slave received ACK after sending measurement data, move to state 5
                      begin
                        state <= 5;
                        sda_enable <= 0;
                        sda_out <= 0;
                        addr <= addr;
                        data <= data;
                        count <= 0;
                      end
                    else              //if slave did not receive an ACK after sending the measurement data, return to the beginning
                      begin
                        state <= 0;
                        sda_enable <= 0;
                        sda_out <= 0;
                        addr <= addr;
                        data <= addr;
                        count <= 0;
                      end
                  end
              end
            3:                //***************State 3: Write Data********************
              begin
                if(count < 7)   //add 8 bits that the master sent to data
                  begin
                    state <= 3;
                    sda_enable <= 0;
                    sda_out <= 0;
                    addr <= addr;
                    data[7-count] <= sda;
                    count <= count + 1;
                  end
                else          //8 bits have been received from the slave
                  begin
                    sda_enable <= 1;
                    sda_out <= 0;
                    addr <= addr;
                    data <= data;
                    count <= 0;
                  end
              end
            4:               //***************State 4: Check for Stop after Write********************
              begin
                if(!stop)     //if there is no stop bit, then write again
                  begin
                    state <= 3;
                    sda_enable <= 0;
                    sda_out <= 0;
                    addr <= addr;
                    data <= 0;
                    count <= 0;
                  end
                else        //if stop bit, then done
                  begin
                    state <= 0;
                    sda_enable <= 0;
                    sda_out <= 0;
                    addr <= addr;
                    data <= data;
                    count <= 0;
                  end
              end
            5:                //***************State 5:Check for Stop after Read********************
              begin
                if(!stop)     //if there is no stop bit, then read again
                  begin
                    state <= 2;
                    sda_enable <= 0;
                    sda_out <= 0;
                    addr <= addr;
                    data <= data;
                    count <= 0;
                  end
                else
                  begin
                    state <= 0;
                    sda_out <= 0;
                    sda_out <= 0;
                    addr <= addr;
                    data <= data;
                    count <= 0;
                  end
              end
          endcase
        end
    end
endmodule
