//`timescale 1ns/1ps

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
  wire refresh_clk;
  wire sys_clk;

  reg clk;
  reg write;
  reg reset;
  reg run;
  reg [11:0] number_of_bytes;
  reg [2:0] memory_number;
  reg [14:0] memory_address;
  reg [7:0] data_in;
  reg [7:0] measurement;
  reg en;



  master u1 (slave_address, byte_to_be_writen, refresh_clk, sys_clk, 
            I2C_mode, I2C_en, reset_I2C, I2C_start, I2C_stop, 
            I2C_repeat_start, I2C_data_out, ack, sda, scl);
  
  I2C_write_to_memory u2 (sys_clk, reset, run, number_of_bytes, 
            memory_address, FIFO_data_out, empty, ack, memory_number, 
            FIFO_read, slave_address, byte_to_be_writen, I2C_mode, 
            I2C_en, reset_I2C, I2C_start, I2C_stop, I2C_repeat_start, 
            sda);
  
  FIFO_four u3  (sys_clk, reset, write, FIFO_read, data_in, 
            FIFO_data_out, full, FIFO_empty);

  clock_divider u4 (clk, reset, en, refresh_clk, sys_clk); 

  slave u5 (slave_address, measurement, en, reset, scl, sda);

  always
    begin
      #5 clk <= ~clk;
    end
  

  initial
    begin
    
    clk = 1;
    reset = 1;
    en = 1;
    write = 0;
    #200
    reset = 0;
    run = 0;
    number_of_bytes = 5;
    memory_address = 0;
    memory_number = 2;
    data_in = 0;
    #4000
    reset = 1;
    #1400
    while( !full )
      begin
        #1000
        write = 1;
        #1000
        write = 0;
        data_in = data_in + 3;
      end
    write = 0;
    run = 1;
    #30000

    $finish;
    end
    






endmodule
