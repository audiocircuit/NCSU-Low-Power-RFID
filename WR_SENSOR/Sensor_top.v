
module Sensor_top(
  input wire reset_n,
  input wire clock,
  input wire start,
  input wire mode,
  input wire [6:0] sensor_address,
  input wire [7:0] write_val,
  output wire data_ready,
  output wire [7:0] read_val,
  inout tri1 master_sda_line,
  inout tri1 master_scl_line
  );
  
  wire master_enable, master_clock, master_start, master_stop;
  wire master_mode;
  wire [6:0] slave_address;
  wire [7:0] w_slave_data, r_slave_data;

  Wr_Sensor master_controllor(
    .reset_n(reset_n),
    .clock(clock),
    .start(start),
    .mode(mode),
    .sensor_addr(sensor_address),
    .write_val(write_val),
    .data_ready(data_ready),
    .read_val(read_val),
    .master_en(master_enable),
    .master_start(master_start),
    .master_stop(master_stop),
    .master_mode(master_mode),
    .write_slave_data(w_slave_data),
    .read_slave_data(r_slave_data),
    .slave_addr(slave_address)
    );



  clock_divider master_clk_divider(
    .clock(clock),
    .reset(reset_n),
    .enabled(master_enable),
    .clk_div(master_clock)
    );


  master controllor(
    .reset_n(reset_n),
    .clock(master_clock),
    .en(master_enable),
    .start(master_start),
    .stop(master_stop),
    .mode(master_mode),
    .address(slave_address),
    .registor(w_slave_data),
    .sda(master_sda_line),
    .scl(master_scl_line),
    .data_out(r_slave_data)
    );
endmodule
