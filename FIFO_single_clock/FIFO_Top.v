module FIFO(
  input wire clock,
  input wire reset_n,
  input wire write_en,
  input wire read_en,
  output wire empty,
  output wire full,
  input wire [7:0] data_in,
  output wire [7:0] data_out
  );

  wire data_ready, data_valid;
  wire [1:0] write_pointer, read_pointer;
  wire [7:0] data_value;

  assign data_out = (read_en) ? data_value : 8'bz;

  FIFO_controller controller_dut(
    .clock(clock),
    .reset_n(reset_n),
    .write_en(write_en),
    .read_en(read_en),
    .write_pointer(write_pointer),
    .read_pointer(read_pointer),
    .full(full),
    .empty(empty),
    .data_ready(data_ready),
    .data_valid(data_valid)
    );

  
  FIFO_Datapath datapath_dut(
    .reset_n(reset_n),
    .data_in(data_in),
    .data_out(data_value),
    .read_pointer(read_pointer),
    .write_pointer(write_pointer),
    .data_ready(data_ready),
    .data_valid(data_valid)
    );

endmodule
