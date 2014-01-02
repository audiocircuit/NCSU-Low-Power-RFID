module write_to_memory_testbench();
  
  wire [6:0] slave_address;        // 7 bit alave address
  wire [7:0] byte_to_be_writen;            // 8 bit value for write 
  wire I2C_mode;                      // use to select between read and write
  wire I2C_start;
  wire I2C_stop;
  wire I2C_repeat_start;
  wire [7:0] I2C_data_out;
  wire ack;
  tri1 sda;
  tri1 scl;
  wire [7:0] FIFO_data_out;
  wire FIFO_empty;
  wire FIFO_read;
  wire full;
  wire I2C_en;                    // used to enable the memory write to memory
  wire reset_I2C;                 // used to reset the I2C machine

  reg clk;
  reg write;
  reg reset;
  reg run;
  reg [11:0] number_of_bytes;
  reg [2:0] memory_number;
  reg [14:0] memory_address;
  reg [7:0] data_in;





  I2C u1 (slave_address, byte_to_be_writen, clk, I2C_mode, I2C_en, reset_I2C, I2C_start, I2C_stop, I2C_repeat_start, I2C_data_out, ack, sda, scl);
  
  I2C_write_to_memory u2 (clk, reset, run, number_of_bytes, memory_address, FIFO_data_out, empty, ack, memory_number, FIFO_read, slave_address, byte_to_be_writen, mode, I2C_en, reset_I2C, I2C_start, I2C_stop, I2C_repeat_start, sda);
  
  FIFO_four u3  (clk, reset, write, FIFO_read, data_in, FIFO_data_out, full, FIFO_empty);   
  always
    begin
      #5 clk <= ~clk;
    end
  

  initial
    begin
    
    clk = 1;
    #20
    reset = 0;
    run = 0;
    number_of_bytes = 5;
    memory_address = 0;
    memory_number = 2;
    data_in = 0;
    #40
    reset = 1;
    while( !full )
      begin
        #10
        write = 1;
        #10
        write = 0;
        data_in = data_in + 3;
      end
    write = 0;
    run = 1;
    #100

    $finish;
    end
    






endmodule
