//This module controls all I2C master communication

module master(
  input wire reset_n,
  input wire clk,
  input wire en,
  input wire start,
  input wire stop,
  input wire mode,
  input wire [6:0] address,
  input wire [7:0] registor,
  inout wire sda,
  inout wire scl,
  output reg [7:0]data_out
  );

  reg [3:0] master_state;
  reg [3:0] master_counter;
  reg sda_en;
  reg sda_out;
  reg scl_en;
  wire sda_in;
  wire scl_in;

  //State Parameters
  parameter WAIT = 0;
  parameter START = 1;
  parameter ADDRESS = 2;
  parameter MODE = 3;
  parameter ADDRESS_ACK = 4;
  parameter WRITE_DATA = 5;
  parameter READ_DATA = 6;
  parameter WRITE_ACK = 7;
  parameter READ_ACK = 8;
  parameter READ_NACK = 9;
  parameter STOP = 10;
  parameter DONE = 11;
  parameter BAD = 15;

  //tri-state buffer for sda and scl
  assign sda = (sda_en) ? sda_out ? 1'bz : 1'b0 : 1'bz;
  assign sda_in = sda;
  assign scl = (scl_en) ? (clk) ? 1'bz : 1'b0 : 1'bz;
  assign scl_in = scl;

  //capture incomming data on SDA line
  always@(posedge clk or negedge reset_n)
    begin
      if( !reset_n )    //initializes data out to high impedence
        begin
          data_out <= 8'bz;
        end
      else 
        begin
          if(master_state == READ_DATA) //left shifts in captured data
            begin
              data_out <= {data_out,sda_in};
            end
          //when looking for or sending ACK
          else if((master_state == READ_ACK) 
                  || (master_state == READ_NACK))
            begin
              data_out <= data_out;
            end
          else    //set line to high impedence
            begin
              data_out <= 8'bz;
            end
        end
    end

  //Datapath for the Moore state machine
  always@(master_state or reset_n or master_counter)
    begin
      if( !reset_n )  //disable all tri-state buffers
        begin
          sda_en <= 0;
          sda_out <= 0;
          scl_en <= 0;
        end
      else
        begin
          case( master_state )
            WAIT:     //disable all tri-state buffers
              begin
                sda_en <= 0;
                sda_out <= 0;
                scl_en <= 0; 
              end
            START:    //Sets start on SDA line
              begin
                sda_en <= 1;
                sda_out <= 0;
                scl_en <= 0;
            end
            ADDRESS:  //Sends address out SDA line
              begin
                sda_en <= 1;
                sda_out <= address[6 - master_counter];
                scl_en <= 1;
              end
            MODE:     //Sends mode out SDA line
             begin
                sda_en <= 1;
                sda_out <= mode;
                scl_en <= 1;
              end
            ADDRESS_ACK:    //Looks for address ACK
              begin
                sda_en <= 0;
                sda_out <= 0;
                scl_en <= 1;
              end
            WRITE_DATA:     //Sends regiester MSB first
              begin
                sda_en <= 1;
                sda_out <= registor[7 - master_counter];
                scl_en <= 1;
              end
            READ_DATA:    //Reads data on SDA line MSB first
              begin
                sda_en <= 0;
                sda_out <= 0;
                scl_en <= 1;
              end
            WRITE_ACK:    //looks for ACK from writing data
              begin
                sda_en <= 0;
                sda_out <= 0;
                scl_en <= 1;
              end
            READ_ACK:     //Sends ACK after reading data
              begin
                sda_en <= 1;
                sda_out <= 0;
                scl_en <= 1;
              end
            READ_NACK:  //tells slave the master is done receiving data
              begin
                sda_en <= 1;
                sda_out <= 1;
                scl_en <= 1;
              end
            STOP:       //begins the stop condition
              begin
                sda_en <= 1;
                sda_out <= 0;
                scl_en <= 1;
              end
            DONE:       //ends the stop condition
              begin
                sda_en <= 0;
                sda_out <= 0;
                scl_en <= 0;
              end
            BAD:      //fail safe for unpredictible data
              begin
                sda_en <= 0;
                sda_out <= 0;
                scl_en <= 0;
              end
          endcase
        end
    end

  //Control path for master I2C
  always@(negedge clk or negedge reset_n)
    begin
      if(!reset_n)  //initializes state machine
        begin
          master_state <= WAIT;
          master_counter <= 1'b0;
        end
      else
        case(master_state)
          WAIT:     //waiting to start I2C comm
            begin
              if(start && en )
                begin
                  master_state <= START;
                  master_counter <= 1'b0;
                end
              else
                begin
                  master_state <= WAIT;
                  master_counter <= 1'b0;
                end
            end
          START:    //Begin the I2C comm
            begin
              master_state <= ADDRESS;
              master_counter <= 1'b0;
            end
          ADDRESS:  //Send I2C address to slave
            begin
              if(master_counter < 6)
                begin
                  master_counter <= master_counter + 1'b1;
                  master_state <= ADDRESS;
                end
              else
                begin
                  master_state <= MODE;
                  master_counter <= 1'b0;
                end
            end
          MODE:     //Sends read/write mode to slave
            begin
              master_state <= ADDRESS_ACK;
              master_counter <= 1'b0;
            end
          ADDRESS_ACK:  //Receives Slave ACK for address
            begin
              if( !sda_in )
                begin
                  if( mode )
                    begin
                      master_state <= READ_DATA;
                      master_counter <= 1'b0;
                    end
                  else
                    begin
                      master_state <= WRITE_DATA;
                      master_counter <= 1'b0;
                    end
                end
              else
                begin
                  master_state <= STOP;
                  master_counter <= 0;
                end
            end
          WRITE_DATA:   //Sends the slave the data on write
            begin
              if(master_counter < 7)
                begin
                  master_state <= WRITE_DATA;
                  master_counter <= master_counter + 1'b1;
                end
              else
                begin
                  master_state <= WRITE_ACK;
                  master_counter <= 1'b0;
                end
            end
          WRITE_ACK:    //waits for ACK from slave on write
            begin
              if( sda_in || stop )
                begin
                  master_state <= STOP;
                  master_counter <= 1'b0;
                end
              else
                begin
                  master_state <= WRITE_DATA;
                  master_counter <= 1'b0;
                end
            end
          READ_DATA:    //reads data from Slave to master
            begin
              if(master_counter < 7)
                begin
                  master_state <= READ_DATA;
                  master_counter <= master_counter + 1'b1;
                end
              else
                if( stop )
                  begin
                    master_state <= READ_NACK;
                    master_counter <= 1'b0;
                  end
                else
                  begin
                    master_state <= READ_ACK;
                    master_counter <= 1'b0;
                  end
            end
          READ_ACK:   //Sends ACK after receiving data from slave
            begin
              master_state <= READ_DATA;
              master_counter <= 1'b0;
            end
          READ_NACK:  //Sends NACK when master is done reading data
            begin
              master_state <= STOP;
              master_counter <= 1'b0;
            end
          STOP:       //begins transmission of Stop bit
            begin
              master_state <= DONE;
              master_counter <= 1'b0;
            end 
          DONE:       //completes transmission of Stop bit
            begin
              master_state <= DONE;
              master_counter <= 1'b0;
            end
          BAD:        //State for BAD data
            begin
              master_state <= BAD;
              master_counter <= 1'b0;
            end
          default:    //Catch all for bad states
            begin
              master_state <= BAD;
              master_counter <= 1'b0;
            end
       endcase
    end

endmodule


