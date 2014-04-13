module Top_testbench(); 

  reg reset_n = 1;
  reg clock = 0;
  reg start = 0;
  reg mode = 0;
  reg [6:0] sensor_address = 7'h70;
  reg [7:0] write_val = 8'h92;
  reg en = 1;
  reg [7:0] measure = 8'hf0;
  wire [7:0] read_val;
  wire data_ready;
  tri1 master_sda_line;
  tri1 master_scl_line;

  always@(*) 
    #5 clock <= ~clock;

  Sensor_top top(
    .reset_n(reset_n),
    .clock(clock),
    .start(start),
    .mode(mode),
    .sensor_address(sensor_address),
    .write_val(write_val),
    .data_ready(data_ready),
    .read_val(read_val),
    .master_sda_line(master_sda_line),
    .master_scl_line(master_scl_line)
  );


  slave Slave(
    .reset_n(reset_n),
    .en(en),
    .my_addr(sensor_address),
    .measurement(measure),
    .scl(master_scl_line),
    .sda(master_sda_line)
  );

  always@(posedge data_ready)
    begin
      measure <= measure + 1'd1;
      #10
      write_val <= write_val + 1'd1;
    end

  initial
    begin
      #10 reset_n = 0;
      #10 reset_n = 1;
      #20 start = 1;
      #2000;
      start = 0;
      #300;
      $finish;
    end

endmodule
